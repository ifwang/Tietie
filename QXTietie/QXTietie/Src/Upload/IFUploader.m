//
//  IFUploader.m
//  QXTietie
//
//  Created by ifwang on 14-3-6.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "IFUploader.h"
#import "QiniuUploadDelegate.h"
#import "QiniuSimpleUploader.h"
#import "IFUploadToken.h"

static NSString *kAccessKey = @"FRbD3yIWCYEfMWrtvUnWpvZ7cH5k9v5OYYSX-Uj7";
static NSString *kSecretKey = @"hDdfuDKUqKYyUpbQLCBNtFm1F5V4TF8eD97psqKG";
static NSString *kBucketName = @"tietie-qrcode";

@interface IFUploader()<QiniuUploadDelegate>

@property (nonatomic, strong) QiniuSimpleUploader *uploader;

@end

@implementation IFUploader
- (void)uploadTask:(IFTask*)task
{
    NSString *key = [self currentKeyWithTask:task];
    [self uploadFile:task.fileUrl bucket:kBucketName key:key];
}

- (NSString*)currentKeyWithTask:(IFTask*)task
{
    NSString *uuid = [IFCommon UUID];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd-HH-mm-ss"];
    //Optionally for time zone conversions
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    NSString *timeDesc = [formatter stringFromDate:[NSDate date]];
    NSString *key = [NSString stringWithFormat:@"%@_%@%@",uuid,timeDesc, task.format];
    
    return key;
    
    
}

- (void)uploadFile:(NSString *)filePath bucket:(NSString *)bucket key:(NSString *)key
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]) {
        
        self.uploader = [[QiniuSimpleUploader alloc ] initWithToken:[self tokenWithScope:bucket key:key]];
        _uploader.delegate = self;
        
        [_uploader uploadFile:filePath key:key extra:nil];
    }
}

- (NSString *)tokenWithScope:(NSString *)scope key:(NSString*)key
{
    IFUploadToken *policy = [[IFUploadToken alloc] init];
    policy.scope = [NSString stringWithFormat:@"%@:%@",scope,key];
    policy.expires = 36000;
    return [policy makeToken:kAccessKey secretKey:kSecretKey];
}



#pragma mark - uploadSuccess

// Progress updated. 1.0 indicates 100%.
- (void)uploadProgressUpdated:(NSString *)filePath percent:(float)percent
{
    
    NSLog(@"upload:%@::::%f",filePath,percent);
    [_delegate onUploadInProgress:percent];
    
    
    
}


- (void)uploadSucceeded:(NSString *)filePath ret:(NSDictionary *)ret
{
    NSString *hash = [ret objectForKey:@"hash"];
    NSString *message = [NSString stringWithFormat:@"Successfully uploaded %@ with hash: %@",  filePath, hash];
    NSLog(@"%@", message);

    [_delegate onUploadSuccess];
    
}

// Upload failed.
- (void)uploadFailed:(NSString *)filePath error:(NSError *)error
{
    NSLog(@"upload error!:%@::::",error);

    [_delegate onUploadFailed];
}

@end
