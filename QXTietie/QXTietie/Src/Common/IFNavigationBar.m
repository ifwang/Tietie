//
//  IFNavigationBar.m
//  QXTietie
//
//  Created by ifwang on 14-3-2.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "IFNavigationBar.h"

@interface IFNavigationBar()

@property (nonatomic, strong) CALayer *colorLayer;

@end

static CGFloat const kDefaultColorLayerOpacity = 0.4f;
static CGFloat const kSpaceToCoverStatusBars = 20.0f;

@implementation IFNavigationBar


- (void)setBarTintColor:(UIColor *)barTintColor {
    if (IOS7_OR_LATER)
    {
        [super setBarTintColor:barTintColor];
        
        if (self.colorLayer == nil) {
            self.colorLayer = [CALayer layer];
            self.colorLayer.opacity = kDefaultColorLayerOpacity;
            [self.layer addSublayer:self.colorLayer];
        }
        
        CGFloat red, green, blue, alpha;
        [barTintColor getRed:&red green:&green blue:&blue alpha:&alpha];
        
        CGFloat opacity = kDefaultColorLayerOpacity;
        
        CGFloat minVal = MIN(MIN(red, green), blue);
        
        if ([self convertValue:minVal withOpacity:opacity] < 0) {
            opacity = [self minOpacityForValue:minVal];
        }
        
        self.colorLayer.opacity = opacity;
        
        red = [self convertValue:red withOpacity:opacity];
        green = [self convertValue:green withOpacity:opacity];
        blue = [self convertValue:blue withOpacity:opacity];
        
        red = MAX(MIN(1.0, red), 0);
        green = MAX(MIN(1.0, green), 0);
        blue = MAX(MIN(1.0, blue), 0);
        
        self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha].CGColor;
    }
    else
    {
        [self setTintColor:barTintColor];
    }
}

- (CGFloat)minOpacityForValue:(CGFloat)value
{
    return (0.4 - 0.4 * value) / (0.6 * value + 0.4);
}

- (CGFloat)convertValue:(CGFloat)value withOpacity:(CGFloat)opacity
{
    return 0.4 * value / opacity + 0.6 * value - 0.4 / opacity + 0.4;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.colorLayer != nil) {
        self.colorLayer.frame = CGRectMake(0, 0 - kSpaceToCoverStatusBars, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + kSpaceToCoverStatusBars);
        
        [self.layer insertSublayer:self.colorLayer atIndex:1];
    }
}


@end
