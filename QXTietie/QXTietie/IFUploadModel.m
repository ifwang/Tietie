//
//  IFUploadModel.m
//  QXTietie
//
//  Created by ifwang on 14-3-7.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "IFUploadModel.h"
#import "IFTask.h"
@interface IFUploadModel()

@property (nonatomic, strong) NSMutableArray *taskQueue;

@end

@implementation IFUploadModel

- (id)init
{
    if(self = [super init])
    {
        self.taskQueue = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)uploadGift:(IFGiftVO *)gift
{
    if ([gift.imageList count] > 0)
    {
        [gift.imageList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            IFImageTask *task = [[IFImageTask alloc] init];
            
            UIImage *image = obj;
            NSString *imageName = [NSString stringWithFormat:@"tmpImg%d.jpg",idx];
            
            NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:imageName];
            NSLog(@"image Upload Path: %@", filePath);
            NSData *webData = UIImageJPEGRepresentation(image, 1);
            [webData writeToFile:filePath atomically:YES];
            
            task.fileUrl = filePath;
            
            [_taskQueue addObject:task];
            
        }];
    }
    
    if(gift.audioUrl != nil)
    {
        IFAudioTask *task = [[IFAudioTask alloc] init];
        task.fileUrl = gift.audioUrl.absoluteString;
        [_taskQueue addObject:task];
    }
}

- (void)start
{
    
}

@end

