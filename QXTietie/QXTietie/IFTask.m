//
//  IFTask.m
//  QXTietie
//
//  Created by ifwang on 14-3-7.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "IFTask.h"

@implementation IFTask

@end

@implementation IFImageTask

- (id)init
{
    if(self = [super init])
    {
        self.format = @".jpg";
        self.taskType = IFTaskTypeImage;
    }
    return self;
}

@end

@implementation IFAudioTask

- (id)init
{
    if(self = [super init])
    {
        self.format = @".caf";
        self.taskType = IFTaskTypeAudio;
    }
    return self;
}

@end