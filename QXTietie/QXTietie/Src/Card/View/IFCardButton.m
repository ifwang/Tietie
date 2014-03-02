//
//  IFCardButton.m
//  QXTietie
//
//  Created by ifwang on 14-3-2.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "IFCardButton.h"

@implementation IFCardButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(IFCardButton*)button
{
    IFCardButton *button = [[IFCardButton alloc] init];
    button.buttonColor = [UIColor cloudsColor];
    button.shadowColor = HEXCOLOR(0xDCDCDC);
    button.shadowHeight = 3;
    button.cornerRadius = 5;
    return button;
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
