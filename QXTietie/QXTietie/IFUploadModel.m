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
#import "IFAudioUtil.h"
#import "NSString+UTF8.h"
#import "AFNetworking.h"
@interface IFUploadModel()<IFUploaderDelegate>

@property (nonatomic, strong) NSMutableArray *taskQueue;

@property (nonatomic, strong) IFUploader *uploader;

@property (nonatomic, assign) NSUInteger totalTaskCount;

@property (nonatomic, assign) NSUInteger currentTaskIndex;

@property (nonatomic, strong) IFGiftVO *gift;

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
    self.gift = gift;
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
    
    if(task.taskType == IFTaskTypeAudio)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            task.fileUrl = [self convertCafToMp3:task.fileUrl];
            [_uploader uploadTask:task];
        });
    }
    else
    {
    
    [_uploader uploadTask:task];
    }
}

- (NSString*)convertCafToMp3:(NSString*)cafUrl
{
    NSLog(@"convert caf : %@",cafUrl);
    if (cafUrl!= nil)
    {
        return [IFAudioUtil audio_PCMtoMP3WithUrl:cafUrl];
    }
    else
    {
        return nil;
    }
}

#pragma mark - Uploader Delegate Method

- (void)onUploadInProgress:(CGFloat)percent
{
    NSLog(@"model progress %f",percent);
    if (percent < 1)
    {
        CGFloat allPercent = (1.0/_totalTaskCount) * (_currentTaskIndex + percent);
        [_delegate onUploadInProgress:allPercent];
    }

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
        [self uploadInfo];
        
    }
}

- (void)onUploadFailed
{
    [_delegate onUploadFailedAtIndex:_currentTaskIndex totalCount:_totalTaskCount];
    NSLog(@"model faied");
}

- (void)uploadInfo
{
    NSMutableArray *imageArray = [NSMutableArray array];
    __block NSString *audioKey = nil;
    [_taskQueue enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        IFTask *task = obj;
        if (task.taskType == IFTaskTypeImage)
        {
            [imageArray addObject:[NSString stringWithFormat:@"%@%@",kFileBaseUrl,task.key]];
        }
        else if(task.taskType == IFTaskTypeAudio)
        {
            audioKey = [NSString stringWithFormat:@"%@%@",kFileBaseUrl,task.key];
        }
    }];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"qrcode"] = _gift.cardId;
    param[@"article"] = _gift.text;
    if(audioKey != nil)
    {
        param[@"audio"] = audioKey;
    }
    
    if ([imageArray count] > 0)
    {
        NSMutableString *imageStr = [[NSMutableString alloc] init];
        
        [imageArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (idx != 0)
            {
                [imageStr appendString:@","];
            }
            [imageStr appendString:obj];
        }];
        param[@"photo"] = imageStr;
    }
    
    if (_gift.location != nil)
    {
        param[@"location"] = _gift.locationText;
        param[@"latitude"] = [@(_gift.location.coordinate.latitude) stringValue];
        param[@"longitude"] = [@(_gift.location.coordinate.longitude) stringValue];
    }
    [AFHTTPRequestOperationManager manager].requestSerializer = [AFJSONRequestSerializer serializer];
    [[AFHTTPRequestOperationManager manager] POST:kUploadInfo parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response:%@",responseObject);
        
        NSString *code = [responseObject objectForKey:@"code"];
        if ([code integerValue] == 200)
        {
            NSLog(@"上传成功:%@",responseObject);
            [_delegate onUploadAllSuccess];
        }
        else
        {
            NSLog(@"上传失败");
            [_delegate onUploadFailedAtIndex:_totalTaskCount totalCount:_totalTaskCount];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传失败:%@",error);
        [_delegate onUploadFailedAtIndex:_totalTaskCount totalCount:_totalTaskCount];

    }];
    
}

@end

