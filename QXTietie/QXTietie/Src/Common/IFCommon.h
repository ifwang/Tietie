//
//  IFCommon.h
//  QXTietie
//
//  Created by ifwang on 14-2-20.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define AdjustInsetsDisable                        \
if (IOS7_OR_LATER)                              \
{                                                \
self.edgesForExtendedLayout = UIRectEdgeNone; \
self.extendedLayoutIncludesOpaqueBars = YES;   \
self.automaticallyAdjustsScrollViewInsets = NO; \
}


@interface IFCommon : NSObject

+ (NSString*)UUID;

/**
 *  获取屏幕尺寸
 */
+ (CGSize)screenSize;

/**
 *  生成色块图
 *
 *  @param color 色块颜色
 *
 *  @return 色块图
 */
+ (UIImage*)defaultColorImage:(UIColor*)color;

/**
 *  ifwang 生成透明色块
 *
 *  @return 透明Image
 */
+ (UIImage*)defaultClearImage;

+ (NSString*)appDocPath;

+ (NSString *)ToHex:(long long int)tmpid;
/**
 *  从http链接中提取出卡片id参数
 *
 *  @param url 提取的链接
 *
 *  @return 卡片id
 */
+ (NSString*)cardIdFromUrl:(NSString*)url;

@end
