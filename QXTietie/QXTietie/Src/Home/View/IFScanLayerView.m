//
//  IFScanLayerView.m
//  QXTietie
//
//  Created by ifwang on 14-3-8.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "IFScanLayerView.h"

@interface IFScanLayerView()

@property (nonatomic, strong) UIImageView *line;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) BOOL isDown;

@end

@implementation IFScanLayerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initView];
        _isDown = YES;
    }
    return self;
}

- (id)init
{
    return [self initWithFrame:CGRectZero];
}

- (void)initView
{
//    UIView *coverView = [[UIView alloc] initWithFrame:self.bounds];
//    coverView.backgroundColor = [UIColor blackColor];
//    coverView.alpha = 0.5;
//    [self addSubview:coverView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, 240, 70)];
    label.text = @"将二维码至于下面的框内,即可自动扫描";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.numberOfLines = 2;
    label.font = [UIFont flatFontOfSize:18];
    label.backgroundColor = [UIColor clearColor];
    [self addSubview:label];
    
    UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ZBarPickBg@2x"]];
    image.frame = CGRectMake(40, 80, 240, 240);
    [self addSubview:image];
    
    self.line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ZBarLine@2x"]];
    _line.frame = CGRectMake(20, 0, 200, 2);
    [image addSubview:_line];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(lineAnimation) userInfo:nil repeats:YES];
}

- (void)lineAnimation
{
    if(_isDown)
    {
        _line.center = CGPointMake(_line.center.x, _line.center.y + 2);
        
        if (_line.center.y >235)
        {
            _isDown = NO;
        }
    }
    else
    {
        _line.center = CGPointMake(_line.center.x, _line.center.y - 2);
        if (_line.center.y < 5)
        {
            _isDown = YES;
        }
    }
}

- (void)stopAnimation
{
    [_timer invalidate];
}


@end
