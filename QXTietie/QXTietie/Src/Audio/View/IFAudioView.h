//
//  IFAudioView.h
//  QXTietie
//
//  Created by ifwang on 14-2-19.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZAudio.h"

@protocol IFAudioViewDelegate <NSObject>

- (void)onStartBtnClick;

- (void)onStopBtnClick;

@end

@interface IFAudioView : UIView

@property (nonatomic, weak) id<IFAudioViewDelegate> delegate;

/**
 The CoreGraphics based audio plot
 */
@property (nonatomic,weak) IBOutlet EZAudioPlot *audioPlot;


/**
 *  初始化AudioView
 */
- (void)initView;

- (void)stopFunctioning;

@end
