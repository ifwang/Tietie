//
//  IFTitleHeader.m
//  QXTietie
//
//  Created by ifwang on 14-3-2.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "IFTitleHeader.h"
CGFloat const kTitleHeaderHeight = 30;

@interface IFTitleHeader()

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UIView *line;

@end

@implementation IFTitleHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        [self initView];
    }
    return self;
}

- (id)init
{
    return [self initWithFrame:CGRectZero];
}

- (void)initView
{
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 280, 20)];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.font = [UIFont boldFlatFontOfSize:20];
    [self addSubview:titleLbl];
    self.titleLbl = titleLbl;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 28, 320, 2)];
    [self addSubview:line];
    self.line = line;
}

- (void)setTitle:(NSString*)text
{
    _titleLbl.text = text;
}

- (void)setHeaderTintColor:(UIColor *)tintColor
{
    _titleLbl.textColor = tintColor;
    
    _line.backgroundColor = tintColor;
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
