//
//  IFAudioView.m
//  QXTietie
//
//  Created by ifwang on 14-2-19.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "IFAudioView.h"
#import "FlatUIKit.h"
#import "THProgressView.h"

static NSString *kBeginText = @"开始";
static NSString *kEndText = @"结束";

#define kViewTintColor HEXCOLOR(0x0088FF)




@interface IFAudioView()

@property (nonatomic, strong) FUIButton *audioBtn;

@property (nonatomic, strong) THProgressView *progressView;

@end

@implementation IFAudioView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setProgress:(CGFloat)progress
{
    [self.progressView setProgress:progress];
}


#pragma mark - init view Method

- (void)initView
{
    [self initPlot];
    [self initProgress];
    [self initButton];
    
    [self changeToStatus:AudioViewStatusNew];
    
}

- (void)initPlot
{
    self.audioPlot.backgroundColor = [UIColor whiteColor];
    // Waveform color
    self.audioPlot.color           = kViewTintColor;
    // Plot type
    self.audioPlot.plotType        = EZPlotTypeBuffer;
}

- (void)initButton
{
    CGSize screenSize = [IFCommon screenSize];
    CGFloat height = IOS7_OR_LATER?screenSize.height - 140:screenSize.height - 140 - 64;
    FUIButton *button = [[FUIButton alloc] initWithFrame:CGRectMake(40, height, 240, 40)];

    button.buttonColor = kViewTintColor;
    button.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    button.shadowHeight = 3.0f;
    button.cornerRadius = 6.0f;
    [button setTitle:@"hehe" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(audioAction:) forControlEvents:UIControlEventTouchUpInside];
    self.audioBtn = button;
    
    [self addSubview:button];
    
}

- (void)initProgress
{
    CGSize screenSize = [IFCommon screenSize];
    CGFloat height = IOS7_OR_LATER?screenSize.height - 200:screenSize.height - 200 - 64;
    
    self.progressView = [[THProgressView alloc] initWithFrame:CGRectMake(40, height, 240, 20)];
    _progressView.progressTintColor = kViewTintColor;
    _progressView.borderTintColor = kViewTintColor;
    [self addSubview:_progressView];
}


#pragma mark - button Method Delegate

- (void)changeToStatus:(AudioViewStatus)status
{
    _status = status;
    switch (status) {
        case AudioViewStatusNew:
        {
            [_audioBtn setTitle:@"开始录音" forState:UIControlStateNormal];
            [_audioBtn setButtonColor:kViewTintColor];
            [_progressView setProgress:0 animated:YES];
            break;
        }
        case AudioViewStatusRecording:
        {
            [_audioBtn setTitle:@"停止录音" forState:UIControlStateNormal];
            [_audioBtn setButtonColor:kViewTintColor];
            break;
        }
        case AudioViewStatusRecorded:
        {
            [_audioBtn setTitle:@"重新录音" forState:UIControlStateNormal];
            [_audioBtn setButtonColor:HEXCOLOR(0xCD5C5C)];
            [_progressView setProgress:1 animated:YES];
        }
    }
}

- (void)audioAction:(id)sender
{
    switch (_status)
    {
        case AudioViewStatusNew:
        {
            [self changeToStatus:AudioViewStatusRecording];
            [_delegate onStartBtnClick];
            break;
        }
        case AudioViewStatusRecording:
        {
            [self changeToStatus:AudioViewStatusRecorded];
            [_delegate onStopBtnClick];
            break;
        }
        case AudioViewStatusRecorded:
        {
            [self changeToStatus:AudioViewStatusNew];
            break;
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
