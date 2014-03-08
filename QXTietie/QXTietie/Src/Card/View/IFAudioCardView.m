//
//  IFAudioCardView.m
//  QXTietie
//
//  Created by ifwang on 14-3-2.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "IFAudioCardView.h"
#import "EZAudioPlot.h"
#import "IFCardButton.h"
CGFloat const kAudioCardViewHeight = 90;


@interface IFAudioCardView()

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UIImageView *micIcon;

@property (nonatomic, strong) UILabel *emptyLbl;

@property (nonatomic, strong) EZAudioPlot *audioPlot;

@end

@implementation IFAudioCardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initView];
    }
    return self;
}

- (void)initView
{
    FUIButton *button = [IFCardButton button];
    [button setFrame:CGRectMake(15, 15, 290, 60)];
    
    UIImageView *micImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mic"]];
    micImg.frame = CGRectMake(20, 20, 20, 20);
    micImg.userInteractionEnabled = YES;
    [button addSubview:micImg];
    self.micIcon = micImg;
    
    UILabel *emptyLbl = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 180, 20)];
    emptyLbl.backgroundColor = [UIColor clearColor];
    emptyLbl.font = [UIFont flatFontOfSize:16];
    emptyLbl.textColor = HEXCOLOR(0x3C3C3C);
    emptyLbl.text = @"点击制作声音卡片";
    self.emptyLbl = emptyLbl;
    [button addSubview:emptyLbl];
    
    self.audioPlot = [[EZAudioPlot alloc] initWithFrame:CGRectMake(0, 10, 290, 40)];
    _audioPlot.backgroundColor = [UIColor cloudsColor];
    _audioPlot.plotType = EZPlotTypeBuffer;
    _audioPlot.color = HEXCOLOR(0x0088FF);
    _audioPlot.alpha = 0;
    [button addSubview:_audioPlot];
    
    [self addSubview:button];
    self.button = button;
    
}

- (void)setAudioViewHidden:(BOOL)hidden
{
        if (hidden)
        {
            _emptyLbl.text = @"点击制作声音卡片";

        }
        else
        {
            _emptyLbl.text = @"点击修改您的声音卡片";

        }
}

- (void)addTarget:(id)target onSeletor:(SEL)seletor
{
    [_button addTarget:target action:seletor forControlEvents:UIControlEventTouchUpInside];
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
