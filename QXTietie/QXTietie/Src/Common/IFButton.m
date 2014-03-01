//
//  IFButton.m
//  QXTietie
//
//  Created by ifwang on 14-2-20.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "IFButton.h"

@implementation IFButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
/**
 *  重载setHighlighted方法，是subView也一起高亮
 */
- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    for (UIView *view in self.subviews)
    {
        //TODO: 检查View 是否有highlighted属性
        if ([view respondsToSelector:@selector(setHighlighted:)])
        {
            [view setValue:@(highlighted) forKey:@"highlighted"];
        }
    }
    
}

- (void)setNormalImageColor:(UIColor*)color HighlightedImageColor:(UIColor*)highlightedImageColor
{
    [self setBackgroundImage:[IFCommon defaultColorImage:color] forState:UIControlStateNormal];
    [self setBackgroundImage:[IFCommon defaultColorImage:highlightedImageColor] forState:UIControlStateHighlighted];
}



@end
