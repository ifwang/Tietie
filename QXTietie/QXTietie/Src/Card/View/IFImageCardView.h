//
//  IFImageCardView.h
//  QXTietie
//
//  Created by ifwang on 14-3-2.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import <UIKit/UIKit.h>
extern CGFloat const kImageCardViewHeight;

@protocol IFImageCardViewDelegate

- (void)onAddImageBtnClicked;

- (void)onImageBtnClicked:(NSUInteger)index;

@end

@interface IFImageCardView : UIView

@property (nonatomic, weak) id<IFImageCardViewDelegate> delegate;

- (void)addImage:(UIImage*)image;


@end
