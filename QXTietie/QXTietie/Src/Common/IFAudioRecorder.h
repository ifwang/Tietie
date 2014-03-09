//
//  IFAudioRecorder.h
//  QXTietie
//
//  Created by ifwang on 14-3-10.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IFAudioRecorderDelegate

- (void)onRecordingAtCurrentTime:(NSTimeInterval)currentTime;

@end

@interface IFAudioRecorder : NSObject

@property (nonatomic, assign) BOOL isRecording;

@property (nonatomic, weak) id<IFAudioRecorderDelegate> delegate;

+ (NSInteger) getFileSize:(NSString*) path;

- (void)recordWithFileUrl:(NSURL*)fieUrl;

- (void)stop;

@end
