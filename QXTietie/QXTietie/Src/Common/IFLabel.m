//
//  IFLabel.m
//  QXTietie
//
//  Created by ifwang on 14-2-20.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "IFLabel.h"

@implementation IFLabel
- (id)init
{
    self = [self initWithFrame:CGRectZero];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.textAlignment = NSTextAlignmentLeft;
        self.numberOfLines = 0;
        self.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    
    return self;
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
