//
//  IFAudioRecorder.m
//  QXTietie
//
//  Created by ifwang on 14-3-10.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "IFAudioRecorder.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#include "lame.h"

@interface IFAudioRecorder()

@property (nonatomic, strong) AVAudioRecorder *recorder;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation IFAudioRecorder

- (id)init
{
    if (self = [super init])
    {
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        
        if(session == nil)
            NSLog(@"Error creating session: %@", [sessionError description]);
        else
            [session setActive:YES error:nil];

        
    }
    
    return self;
}

+(NSInteger) getFileSize:(NSString*) path
{
    NSFileManager * filemanager = [[NSFileManager alloc]init];
    if([filemanager fileExistsAtPath:path]){
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:path error:nil];
        NSNumber *theFileSize;
        if ( (theFileSize = [attributes objectForKey:NSFileSize]) )
            return  [theFileSize intValue];
        else
            return -1;
    }
    else
    {
        return -1;
    }
}

- (void)recordWithFileUrl:(NSURL*)fieUrl
{
    if (!_isRecording)
    {
        NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithFloat: 44100],                  AVSampleRateKey,
                                  [NSNumber numberWithInt: kAudioFormatLinearPCM],                   AVFormatIDKey,
                                  [NSNumber numberWithInt: 2],                              AVNumberOfChannelsKey,
                                  [NSNumber numberWithInt: AVAudioQualityLow],               AVEncoderAudioQualityKey,
                                  nil];
        
        NSError* error;
        self.recorder = [[AVAudioRecorder alloc] initWithURL:fieUrl settings:settings error:&error];
        NSLog(@"%@", [error description]);
        if (error)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:@"your device doesn't support your setting"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            return;
        }
        _isRecording = YES;
        [_recorder prepareToRecord];
        _recorder.meteringEnabled = YES;
        [_recorder record];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:.01f
                                                  target:self
                                                selector:@selector(timerUpdate)
                                                userInfo:nil
                                                 repeats:YES];
    }
    else
    {
        NSLog(@"recorder Already recording");
    }
}

- (void)stop
{
    _isRecording = NO;
    
    [_timer invalidate];
    _timer = nil;
    
    if (_recorder != nil)
    {
        
    }
    
    [_recorder stop];
    _recorder = nil;
}

- (void)timerUpdate
{
    [_delegate onRecordingAtCurrentTime:_recorder.currentTime];
}


@end
