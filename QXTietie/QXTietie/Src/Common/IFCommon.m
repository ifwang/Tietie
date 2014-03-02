//
//  IFCommon.m
//  QXTietie
//
//  Created by ifwang on 14-2-20.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "IFCommon.h"

@implementation IFCommon

+ (CGSize)screenSize
{
    return [UIScreen mainScreen].bounds.size;
}
+ (UIImage*)defaultColorImage:(UIColor*)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *reImage = UIGraphicsGetImageFromCurrentImageContext();
    
    
    UIGraphicsEndImageContext();
    
    return reImage;
    
}

+ (UIImage*)defaultClearImage
{
    
    UIColor *color = [UIColor clearColor];
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *reImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return reImage;
}

+ (NSString*)appDocPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}


@end
