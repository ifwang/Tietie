//
//  IFUploadModel.m
//  QXTietie
//
//  Created by ifwang on 14-3-7.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "IFUploadModel.h"
#import "IFUploader.h"
#import "IFTask.h"

@interface IFUploadModel()<IFUploaderDelegate>

@property (nonatomic, strong) NSMutableArray *taskQueue;

@property (nonatomic, strong) IFUploader *uploader;

@property (nonatomic, assign) NSUInteger totalTaskCount;

@property (nonatomic, assign) NSUInteger currentTaskIndex;

@end

@implementation IFUploadModel

- (id)init
{
    if(self = [super init])
    {
        self.taskQueue = [[NSMutableArray alloc] init];
        self.uploader = [[IFUploader alloc] init];
        _uploader.delegate = self;
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
    
    [self start];
}

- (void)start
{
    _totalTaskCount = [_taskQueue count];
    _currentTaskIndex = 0;
    [self fetchTaskAtIndex:_currentTaskIndex];
}

- (void)fetchTaskAtIndex:(NSUInteger)index
{
    IFTask *task = _taskQueue[index];
    
    [_uploader uploadTask:task];
}

#pragma mark - Uploader Delegate Method

- (void)onUploadInProgress:(CGFloat)percent
{
    NSLog(@"model progress %f",percent);
    
    CGFloat allPercent = (1.0/_totalTaskCount) * (_currentTaskIndex + percent);
    
    [_delegate onUploadInProgress:allPercent];
}

- (void)onUploadSuccess
{
    NSLog(@"model success");
    [_delegate onUploadSuccessAtIndex:_currentTaskIndex totalCount:_totalTaskCount];

    _currentTaskIndex ++;
    if (_currentTaskIndex < _totalTaskCount)
    {
        [self fetchTaskAtIndex:_currentTaskIndex];
    }
    else
    {
        [_delegate onUploadAllSuccess];
        NSLog(@"model All success");
    }
}

- (void)onUploadFailed
{
    [_delegate onUploadFailedAtIndex:_currentTaskIndex totalCount:_totalTaskCount];
    NSLog(@"model faied");
}

@end

