//
//  IFAudioView.m
//  QXTietie
//
//  Created by ifwang on 14-2-19.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "IFAudioView.h"
#import "THProgressView.h"

static NSString *kBeginText = @"开始";
static NSString *kEndText = @"结束";

#define kViewTintColor HEXCOLOR(0x0088FF)




@interface IFAudioView()

@property (nonatomic, strong) FUIButton *audioBtn;

@property (nonatomic, strong) FUIButton *submitBtn;

@property (nonatomic, strong) THProgressView *progressView;

@property (nonatomic, strong) UILabel *recordView;

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
    [self initRecordView];
    [self initProgress];
    [self initButton];
    
    [self changeToStatus:AudioViewStatusNew];
    
}

- (void)initRecordView
{
    self.recordView = [[UILabel alloc] initWithFrame:CGRectMake(10, 180, 300, 40)];
    _recordView.backgroundColor = [UIColor clearColor];
    _recordView.font = [UIFont flatFontOfSize:40];
    _recordView.numberOfLines =1;
    _recordView.textColor = kViewTintColor;
    _recordView.textAlignment = NSTextAlignmentCenter;
    _recordView.alpha = 0;
    
    [self addSubview:_recordView];
    
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
    button.shadowColor = HEXCOLOR(0x000079);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(audioAction:) forControlEvents:UIControlEventTouchUpInside];
    self.audioBtn = button;
    
    [self addSubview:button];
    
    height += button.frame.size.height + 10;
    
    
    self.submitBtn = [[FUIButton alloc] initWithFrame:CGRectMake(40, height, 240, 40)];
    _submitBtn.buttonColor = HEXCOLOR(0x2E8B57);
    _submitBtn.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    _submitBtn.shadowHeight = 3.0f;
    _submitBtn.cornerRadius = 6.0f;
    _submitBtn.shadowColor = HEXCOLOR(0x003E3E);
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitBtn setTitle:@"录好啦~" forState:UIControlStateNormal];
    _submitBtn.alpha = 0;
    [_submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_submitBtn];
    
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
            _audioBtn.shadowColor = HEXCOLOR(0x000079);
            [_progressView setProgress:0 animated:YES];
            
            [UIView animateWithDuration:1 animations:^{
                _submitBtn.alpha = 0;
            }];
            
            break;
        }
        case AudioViewStatusRecording:
        {
            [_audioBtn setTitle:@"停止录音" forState:UIControlStateNormal];
            [_audioBtn setButtonColor:HEXCOLOR(0x008B8B)];
            _audioBtn.shadowColor = HEXCOLOR(0x005757);
            [UIView animateWithDuration:1 animations:^{
                _submitBtn.alpha = 0;
            }];
            break;
        }
        case AudioViewStatusRecorded:
        {
            [_audioBtn setTitle:@"重新录音" forState:UIControlStateNormal];
            [_audioBtn setButtonColor:HEXCOLOR(0xCD5C5C)];
            _audioBtn.shadowColor = HEXCOLOR(0x750000);
            [_progressView setProgress:1 animated:YES];
            [UIView animateWithDuration:1 animations:^{
                _submitBtn.alpha = 1;
            }];
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
            [_delegate onReStartBtnClick];
            break;
        }
    }
}

- (void)submitAction:(id)sender
{
    [_delegate onSubmitBtnClick];
}

- (void)setRecordViewHidden:(BOOL)isHidden
{
    [UIView animateWithDuration:0.5 animations:^{
        _recordView.alpha = isHidden?0:1;
        _audioPlot.alpha = isHidden?1:0;
    }];
}
- (void)setRecordTimeText:(NSString*)text
{
    _recordView.text = text;
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
