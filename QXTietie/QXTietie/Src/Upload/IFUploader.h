//
//  IFUploader.h
//  QXTietie
//
//  Created by ifwang on 14-3-6.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IFGiftVO.h"
#import "IFTask.h"

@protocol IFUploaderDelegate

- (void)onUploadInProgress:(CGFloat)percent;

- (void)onUploadSuccess;

- (void)onUploadFailed;

@end

@interface IFUploader : NSObject

@property (nonatomic, weak) id delegate;

- (void)uploadTask:(IFTask*)task;

@end
