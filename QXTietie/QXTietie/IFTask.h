//
//  IFTask.h
//  QXTietie
//
//  Created by ifwang on 14-3-7.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, IFTaskType)
{
    IFTaskTypeImage,
    IFTaskTypeAudio,
};

@interface IFTask : NSObject

@property (nonatomic, strong) NSString *format;

@property (nonatomic, assign) IFTaskType taskType;

@property (nonatomic, strong) NSString *fileUrl;

@property (nonatomic, copy) NSString *key;

@end


@interface IFImageTask : IFTask

@end

@interface IFAudioTask : IFTask



@end