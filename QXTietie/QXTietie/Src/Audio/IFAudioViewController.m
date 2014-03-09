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
#import "IFAudioRecorder.h"
static CGFloat const kMaxRecordTime = 150;

@interface IFAudioViewController ()<EZMicrophoneDelegate,IFAudioViewDelegate,EZAudioPlayerDelegate,IFAudioRecorderDelegate>

@property (nonatomic, weak) IBOutlet IFAudioView *audioView;
/**
 *  右上角播放按钮
 */
@property (nonatomic, strong) UIBarButtonItem *playBtn;

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

@property (nonatomic, strong) IFAudioRecorder *recorder;

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
    if (_recorder.isRecording)
    {
        [_recorder stop];
    }
    [_player stop];
    _player = nil;
    
}

#pragma mark - init Method

- (void)initController
{
    self.recorder = [[IFAudioRecorder alloc] init];
    _recorder.delegate = self;
    
    self.audioView = (IFAudioView*)self.view;
    [_audioView initView];
    _audioView.delegate = self;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(play)];
    self.navigationItem.rightBarButtonItem = item;
    self.playBtn = item;
    _playBtn.enabled = NO;
    
    [_audioView setRecordViewHidden:NO];
    [_audioView setRecordTimeText:[self timeText:0]];
}

#pragma mark - View Delegate

- (void)onStartBtnClick
{
    [_audioView setRecordViewHidden:NO];
    
    [self deleteAudio:_currentUrl];
    self.currentUrl = [self createAudioFile];
    
    [_recorder recordWithFileUrl:_currentUrl];
    
    _playBtn.enabled = NO;
    [self startRecordTimer];
}

- (void)onStopBtnClick
{
    [_recorder stop];
    
    if ([_recordTimer isValid])
    {
        [_recordTimer invalidate];
    }
    
    _playBtn.enabled = YES;
}

- (void)onReStartBtnClick
{
    
    [_audioView setRecordViewHidden:NO];
    [_audioView setRecordTimeText:[self timeText:0]];
    
    if(_recorder.isRecording)
    {
        [_recorder stop];
    }
    
    if (_player.isPlaying)
    {
        [_player stop];
    }
    _playBtn.enabled = NO;
}


- (void)onSubmitBtnClick
{
    [_audioView setRecordViewHidden:YES];

    if(_recorder.isRecording)
    {
        [_recorder stop];
    }
    
    [_delegate onAudioControllerSubmitAudioWithURL:_currentUrl];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)play
{
    [_audioView setRecordViewHidden:YES];

    if(_recorder.isRecording)
    {
        [_recorder stop];
    }
    
    if (_player.isPlaying)
    {
        [_player stop];
        _player = nil;
    }

    self.player = [[EZAudioPlayer alloc] initWithURL:_currentUrl withDelegate:self];
    [self.player play];
    
}

#pragma mark - Recorder Delegate Method

- (void)onRecordingAtCurrentTime:(NSTimeInterval)currentTime
{
    [_audioView setRecordTimeText:[self timeText:currentTime]];
}

- (NSString*)timeText:(NSTimeInterval)time
{
    int s = ((int)time) % 60;
    int ss = (time - ((int)time)) * 100;

    if (s == 15)
    {
        ss = 0;
    }
    
    NSString *text = [NSString stringWithFormat:@"%.2d:%.2d'' / 15:00''",s,ss];
    
    return text;
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
