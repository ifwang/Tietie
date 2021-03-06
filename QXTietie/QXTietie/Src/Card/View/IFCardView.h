//
//  IFCardView.h
//  QXTietie
//
//  Created by ifwang on 14-3-2.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@protocol IFCardViewDelegate

- (void)onAudioViewClick;

- (void)onAddImageBtnClick;

- (void)onImageBtnClicked:(NSUInteger)index;

@end

@interface IFCardView : UIView

@property (nonatomic, weak) id<IFCardViewDelegate> delegate;

- (void)initView;
/**
 *  告知视图键盘出现
 */
- (void)onKeyBoardComeUp;

/**
 *  告知视图键盘消失
 */
- (void)onKeyBoardComeDown;

/**
 *  声音卡片是否为空
 *
 *  @param isEmpty 是否为空
 */
- (void)setAudioEmptyState:(BOOL)isEmpty;

/**
 *  添加照片到相册卡片
 *
 *  @param image 添加的照片
 */
- (void)addImageToCard:(UIImage*)image;

/**
 *  获取用户输入寄语
 *
 *  @return 寄语文本
 */
- (NSString*)gitfText;

/**
 *  获取用户地址
 *
 *  @return 地址文本
 */
- (NSString*)locationText;
/**
 *  获取用户位置
 *
 *  @return 用户位置
 */
- (CLLocation*)location;

@end
