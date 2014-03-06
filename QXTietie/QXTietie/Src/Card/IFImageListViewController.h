//
//  IFImageListViewController.h
//  QXTietie
//
//  Created by ifwang on 14-3-3.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "IFBaseViewController.h"

@interface IFImageListViewController : IFBaseViewController

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSMutableArray *images;

@end
