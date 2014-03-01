//
//  IFButton.h
//  QXTietie
//
//  Created by ifwang on 14-2-20.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IFButton : UIButton
/**
 *  设置按钮背景颜色
 *
 *  @param color                 正常颜色
 *  @param highlightedImageColor 高亮颜色
 */
- (void)setNormalImageColor:(UIColor*)color HighlightedImageColor:(UIColor*)highlightedImageColor;

@end
