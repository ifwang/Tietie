//
//  IFLocationAnnotion.h
//  QXTietie
//
//  Created by ifwang on 14-3-4.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface IFLocationAnnotion : NSObject<MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
- (id)initWithLatitue:(double)alatitude longitude:(double)alongitude;

@end
