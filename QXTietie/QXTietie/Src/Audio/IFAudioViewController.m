//
//  IFAudioViewController.m
//  QXTietie
//
//  Created by ifwang on 14-2-19.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "IFAudioViewController.h"
#import "IFAudioView.h"
#import "EZRecorder.h"
#import "EZAudioPlayer.h"

static CGFloat const kMaxRecordTime = 150;

@interface IFAudioViewController ()<EZMicrophoneDelegate,IFAudioViewDelegate,EZAudioPlayerDelegate>

@property (nonatomic, weak) IBOutlet IFAudioView *audioView;
/**
 *  右上角播放按钮
 */
@property (nonatomic, strong) UIBarButtonItem *playBtn;
/**
 *  录音器
 */
@property (nonatomic, strong) EZRecorder *recorder;

/**
 *  播放器
 */
@property (nonatomic, strong) EZAudioPlayer *player;
/**
 *  录音音频格式
 */
@property (nonatomic, assign) AudioStreamBasicDescription abDescription;
/**
 *  录音定时器，最大录音时间为15秒
 */
@property (nonatomic, strong) NSTimer *recordTimer;

@property (nonatomic, assign) NSUInteger recordTime;
/**
 The microphone component
 */
@property (nonatomic,strong) EZMicrophone *microphone;
@end

@implementation IFAudioViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"15秒音频";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    srand((int)time(0));

    // Do any additional setup after loading the view from its nib.
    [self initController];
    
    if (_currentUrl != nil)
    {
        [_audioView changeToStatus:AudioViewStatusRecorded];
        _playBtn.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_player stop];
    _player = nil;
    
    [_microphone stopFetchingAudio];
    _microphone = nil;
    
    [_recorder closeAudioFile];
    _recorder = nil;
    
}

#pragma mark - init Method

- (void)initController
{
    self.microphone = [[EZMicrophone alloc] initWithMicrophoneDelegate:self];
    
    self.audioView = (IFAudioView*)self.view;
    [_audioView initView];
    _audioView.delegate = self;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(play)];
    self.navigationItem.rightBarButtonItem = item;
    self.playBtn = item;
    _playBtn.enabled = NO;
}

#pragma mark - View Delegate

- (void)onStartBtnClick
{
    [_microphone startFetchingAudio];
    
    [self deleteAudio:_currentUrl];
    self.currentUrl = [self createAudioFile];
    self.recorder = [EZRecorder recorderWithDestinationURL:_currentUrl andSourceFormat:_abDescription];
    _playBtn.enabled = NO;
    
    [self startRecordTimer];
}

- (void)onStopBtnClick
{
    if ([_recordTimer isValid])
    {
        [_recordTimer invalidate];
    }
    
    [_microphone stopFetchingAudio];
    [_recorder closeAudioFile];
    _playBtn.enabled = YES;
}

- (void)onReStartBtnClick
{
    if (_player.isPlaying)
    {
        [_player stop];
    }
    _playBtn.enabled = NO;
}


- (void)onSubmitBtnClick
{
    if (_microphone.microphoneOn)
    {
        [_microphone stopFetchingAudio];
        [_recorder closeAudioFile];
        
        if (_player.isPlaying)
        {
            [_player stop];
            _player = nil;
        }
    }
    [_delegate onAudioControllerSubmitAudioWithURL:_currentUrl];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)play
{
    if (_microphone.microphoneOn)
    {
        [_microphone stopFetchingAudio];
        [_recorder closeAudioFile];
    }
    
    if (_player.isPlaying)
    {
        [_player stop];
        _player = nil;
    }

    self.player = [[EZAudioPlayer alloc] initWithURL:_currentUrl withDelegate:self];
    [self.player play];
    
}



#pragma mark - EZMicrophoneDelegate
// Note that any callback that provides streamed audio data (like streaming microphone input) happens on a separate audio thread that should not be blocked. When we feed audio data into any of the UI components we need to explicity create a GCD block on the main thread to properly get the UI to work.
-(void)microphone:(EZMicrophone *)microphone
 hasAudioReceived:(float **)buffer
   withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels {
    // Getting audio data as an array of float buffer arrays. What does that mean? Because the audio is coming in as a stereo signal the data is split into a left and right channel. So buffer[0] corresponds to the float* data for the left channel while buffer[1] corresponds to the float* data for the right channel.
    
    // See the Thread Safety warning above, but in a nutshell these callbacks happen on a separate audio thread. We wrap any UI updating in a GCD block on the main thread to avoid blocking that audio flow.
    dispatch_async(dispatch_get_main_queue(),^{
        // All the audio plot needs is the buffer data (float*) and the size. Internally the audio plot will handle all the drawing related code, history management, and freeing its own resources. Hence, one badass line of code gets you a pretty plot :)
        [self.audioView.audioPlot updateBuffer:buffer[0] withBufferSize:bufferSize];
    });
}

-(void)microphone:(EZMicrophone *)microphone hasAudioStreamBasicDescription:(AudioStreamBasicDescription)audioStreamBasicDescription {
    // The AudioStreamBasicDescription of the microphone stream. This is useful when configuring the EZRecorder or telling another component what audio format type to expect.
    // Here's a print function to allow you to inspect it a little easier
    _abDescription = audioStreamBasicDescription;
}

-(void)microphone:(EZMicrophone *)microphone
    hasBufferList:(AudioBufferList *)bufferList
   withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels {
    // Getting audio data as a buffer list that can be directly fed into the EZRecorder or EZOutput. Say whattt...
    
    if (microphone.microphoneOn)
    {
        [_recorder appendDataFromBufferList:bufferList withBufferSize:bufferSize];
    }
    
}

#pragma mark - Player Delegate Method
-(void)  audioPlayer:(EZAudioPlayer*)audioPlayer
            readAudio:(float**)buffer
       withBufferSize:(UInt32)bufferSize
 withNumberOfChannels:(UInt32)numberOfChannels
          inAudioFile:(EZAudioFile*)audioFile
{
    dispatch_async(dispatch_get_main_queue(),^{
        // All the audio plot needs is the buffer data (float*) and the size. Internally the audio plot will handle all the drawing related code, history management, and freeing its own resources. Hence, one badass line of code gets you a pretty plot :)
        if (_player.isPlaying&&!_player.endOfFile)
        {
            [self.audioView.audioPlot updateBuffer:buffer[0] withBufferSize:bufferSize];
            
            CGFloat duration = _player.totalDuration;
            CGFloat currentTime = _player.currentTime;
            [_audioView setProgress:(currentTime/duration)];
            
        }
    });
}

#pragma mark - Timer Method

- (void)startRecordTimer
{
    _recordTime = 0;
    self.recordTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(recordTimerFire) userInfo:nil repeats:YES];
                       
}

- (void)recordTimerFire
{
    _recordTime ++;
    if (_recordTime >= kMaxRecordTime)
    {
        [self onStopBtnClick];
        [_audioView changeToStatus:AudioViewStatusRecorded];
    }
    else
    {
        [_audioView setProgress:((float)_recordTime/kMaxRecordTime)];
    }
}

#pragma mark - Private Method


- (void)deleteAudio:(NSURL*)fileUrl
{
    NSError *error = nil;
    NSFileManager *filemanager = [NSFileManager defaultManager];
    
    if ([filemanager fileExistsAtPath:[fileUrl absoluteString]])
    {
        [filemanager removeItemAtPath:[fileUrl absoluteString] error:&error];
    }
    
    if (error)
    {
        NSLog(@"删除错误:%@",error);
    }
    else
    {
        NSLog(@"删除成功");
    }
}

- (NSURL*)createAudioFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *randomStr = [NSString stringWithFormat:@"%d.caf",(rand())];
    
    NSURL *fileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",docDir,randomStr]];
    [self deleteAudio:fileUrl];
    return fileUrl;
    
}

- (NSURL*)audioPathUrl
{
      return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",[IFCommon appDocPath],kIFAudioTmpPath]];
}




@end
