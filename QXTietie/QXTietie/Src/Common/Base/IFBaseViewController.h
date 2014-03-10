//
//  IFBaseViewController.h
//  QXTietie
//
//  Created by ifwang on 14-2-19.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IFBaseViewController : UIViewController

- (void)showTextHud:(NSString*)text;

- (void)showActivator;
- (void)dismisActivator;

- (void)goBack;

@end
