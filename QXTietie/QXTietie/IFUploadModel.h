//
//  IFUploadModel.h
//  QXTietie
//
//  Created by ifwang on 14-3-7.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IFGiftVO.h"

@protocol IFUploadModelDelegate

- (void)onUploadInProgress:(CGFloat)percent;

- (void)onUploadSuccessAtIndex:(NSUInteger)currentIndex totalCount:(NSUInteger)totalCount;

- (void)onUploadAllSuccess;

- (void)onUploadFailedAtIndex:(NSUInteger)currentIndex totalCount:(NSUInteger)totalCount;

@end

@interface IFUploadModel : NSObject

@property (nonatomic, weak) id<IFUploadModelDelegate> delegate;

- (void)uploadGift:(IFGiftVO*)gift;

- (void)stop;

@end
