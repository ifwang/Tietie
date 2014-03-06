//
//  IFUploadToken.m
//  QXTietie
//
//  Created by ifwang on 14-3-6.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "IFUploadToken.h"
#import <CommonCrypto/CommonHMAC.h>
#import "GTMBase64.h"
#import "JSONKit.h"
@implementation IFUploadToken
- (NSString *)makeToken:(NSString *)accessKey secretKey:(NSString *)secretKey
{
    const char *secretKeyStr = [secretKey UTF8String];
    
	NSString *policy = [self marshal];
    
    NSData *policyData = [policy dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *encodedPolicy = [GTMBase64 stringByWebSafeEncodingData:policyData padded:YES];
    const char *encodedPolicyStr = [encodedPolicy cStringUsingEncoding:NSUTF8StringEncoding];
    
    char digestStr[CC_SHA1_DIGEST_LENGTH];
    bzero(digestStr, 0);
    
    CCHmac(kCCHmacAlgSHA1, secretKeyStr, strlen(secretKeyStr), encodedPolicyStr, strlen(encodedPolicyStr), digestStr);
    
    NSString *encodedDigest = [GTMBase64 stringByWebSafeEncodingBytes:digestStr length:CC_SHA1_DIGEST_LENGTH padded:TRUE];
    
    NSString *token = [NSString stringWithFormat:@"%@:%@:%@",  accessKey, encodedDigest, encodedPolicy];
	return token;
}

// Marshal as JSON format string.

- (NSString *)marshal
{
    time_t deadline;
    time(&deadline);
    
    deadline += (self.expires > 0) ? self.expires : 3600; // 1 hour by default.
    NSNumber *deadlineNumber = [NSNumber numberWithLongLong:deadline];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (self.scope) {
        [dic setObject:self.scope forKey:@"scope"];
    }
    if (self.callbackUrl) {
        [dic setObject:self.callbackUrl forKey:@"callbackUrl"];
    }
    if (self.callbackBody) {
        [dic setObject:self.callbackBody forKey:@"callbackBody"];
    }
    if (self.returnUrl) {
        [dic setObject:self.returnUrl forKey:@"returnUrl"];
    }
    if (self.returnBody) {
        [dic setObject:self.returnBody forKey:@"returnBody"];
    }
    if (self.endUser) {
        [dic setObject:self.endUser forKey:@"endUser"];
    }
    [dic setObject:deadlineNumber forKey:@"deadline"];
    
    NSString *json = [dic JSONString];
    
    
    return json;
}

@end
