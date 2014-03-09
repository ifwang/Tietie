//
//  IFAudioView.h
//  QXTietie
//
//  Created by ifwang on 14-2-19.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZAudio.h"
typedef NS_ENUM(NSUInteger, AudioViewStatus)
{
    /**
     *  未开始录音
     */
    AudioViewStatusNew,
    /**
     *  正在录音
     */
    AudioViewStatusRecording,
    /**
     *  已经录完
     */
    AudioViewStatusRecorded,
};

@protocol IFAudioViewDelegate <NSObject>

- (void)onStartBtnClick;

- (void)onStopBtnClick;

- (void)onReStartBtnClick;

- (void)onSubmitBtnClick;

@end

@interface IFAudioView : UIView

@property (nonatomic, weak) id<IFAudioViewDelegate> delegate;

@property (nonatomic, assign) AudioViewStatus status;


/**
 The CoreGraphics based audio plot
 */
@property (nonatomic,weak) IBOutlet EZAudioPlot *audioPlot;


/**
 *  初始化AudioView
 */
- (void)initView;

- (void)setProgress:(CGFloat)progress;

- (void)changeToStatus:(AudioViewStatus)status;

- (void)setRecordViewHidden:(BOOL)isHidden;

- (void)setRecordTimeText:(NSString*)text;

@end
