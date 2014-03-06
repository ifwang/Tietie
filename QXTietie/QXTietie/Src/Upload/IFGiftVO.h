//
//  IFGiftVO.h
//  QXTietie
//
//  Created by ifwang on 14-3-6.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface IFGiftVO : NSObject

@property (nonatomic, strong) NSURL *audioUrl;

@property (nonatomic, strong) NSArray *imageList;

@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) NSString *locationText;

@property (nonatomic, strong) CLLocation *location;

@end
