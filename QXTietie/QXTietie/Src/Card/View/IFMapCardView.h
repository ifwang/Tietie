//
//  IFMapCardView.h
//  QXTietie
//
//  Created by ifwang on 14-3-3.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLLocation;
extern CGFloat const kMapCardViewHeight;

@protocol IFMapCardViewDelegate

- (void)onMapingBtnClicked;

- (void)onMappingResult:(BOOL)success;

@end

@interface IFMapCardView : UIView

@property (nonatomic, weak) id<IFMapCardViewDelegate> delegate;

@property (nonatomic, assign) BOOL isLocated;

@property (nonatomic, strong) NSString *locationText;

@property (nonatomic, strong) CLLocation *location;

@end
