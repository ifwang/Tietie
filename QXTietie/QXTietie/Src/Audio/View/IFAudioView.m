//
//  IFAudioView.m
//  QXTietie
//
//  Created by ifwang on 14-2-19.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "IFAudioView.h"

static NSString *kBeginText = @"开始";
static NSString *kEndText = @"结束";


@interface IFAudioView()



@property (nonatomic, strong) IFLabel *audioBtnLbl;

@property (nonatomic, assign) BOOL isFunctioning;

@end

@implementation IFAudioView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _isFunctioning = NO;
    }
    return self;
}

- (void)initView
{
    self.audioPlot.backgroundColor = [UIColor whiteColor];
    // Waveform color
    self.audioPlot.color           = HEXCOLOR(0x58D3F7);
    // Plot type
    self.audioPlot.plotType        = EZPlotTypeBuffer;
    
    
    IFButton *button = [IFButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor grayColor]];
    [button setFrame:CGRectMake(0, [IFCommon screenSize].height - (IOS7_OR_LATER?0:64) - 40, [IFCommon screenSize].width, 40)];
    [self addSubview:button];
    
    self.audioBtnLbl = [[IFLabel alloc] initWithFrame:CGRectMake(0, 10, 320, 20)];
    _audioBtnLbl.textAlignment = NSTextAlignmentCenter;
    _audioBtnLbl.font = [UIFont systemFontOfSize:20];
    _audioBtnLbl.textColor = HEXCOLOR(0x58D3F7);
    _audioBtnLbl.highlightedTextColor = HEXCOLOR(0x084B8A);
    _audioBtnLbl.text = kBeginText;
    [button addSubview:_audioBtnLbl];
    [button addTarget:self action:@selector(audioAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)audioAction
{
    if(_isFunctioning)
    {
        [self stopFunctioning];
    }
    else
    {
        [self startFunctioning];
    }
}

- (void)stopFunctioning
{
    [_delegate onStopBtnClick];
    _audioBtnLbl.text = kBeginText;
    _isFunctioning = NO;
}

- (void)startFunctioning
{
    [_delegate onStartBtnClick];
    _audioBtnLbl.text = kEndText;
    _isFunctioning = YES;
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
