//
//  IFMapCardView.h
//  QXTietie
//
//  Created by ifwang on 14-3-3.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

extern CGFloat const kMapCardViewHeight;
@interface IFMapCardView : UIView

@property (nonatomic, assign) BOOL isLocated;

@property (nonatomic, strong) NSString *locationText;

@property (nonatomic, assign) CLLocationCoordinate2D location;

@end
