//
//  IFLocationAnnotion.m
//  QXTietie
//
//  Created by ifwang on 14-3-4.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "IFLocationAnnotion.h"

@interface IFLocationAnnotion()

@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;

@end

@implementation IFLocationAnnotion

- (id)initWithLatitue:(double)alatitude longitude:(double)alongitude
{
    if(self=[super init])
    {
        self.latitude = alatitude;
        self.longitude = alongitude;
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate;
{
    CLLocationCoordinate2D currentCoordinate;
    currentCoordinate.latitude = self.latitude ;
    currentCoordinate.longitude = self.longitude;
    return currentCoordinate; 
}

- (NSString *)title
{
    return @"当前位置";
}
// optional
- (NSString *)subtitle
{
    return @"";
}

@end
