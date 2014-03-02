//
//  IFTextView.h
//  QXTietie
//
//  Created by ifwang on 14-3-2.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IFTextView : UIView

- (void)hideKeyBoard;

- (void)setText:(NSString*)text;

- (void)setPlaceHolderText:(NSString*)text;

- (NSString*)text;

@end
