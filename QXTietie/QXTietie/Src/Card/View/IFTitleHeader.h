//
//  IFTitleHeader.h
//  QXTietie
//
//  Created by ifwang on 14-3-2.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const kTitleHeaderHeight;

@interface IFTitleHeader : UIView

- (void)setHeaderTintColor:(UIColor *)tintColor;

- (void)setTitle:(NSString*)text;


@end
