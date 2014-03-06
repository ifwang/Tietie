//
//  IFUploadToken.h
//  QXTietie
//
//  Created by ifwang on 14-3-6.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IFUploadToken : NSObject

@property (retain, nonatomic) NSString *scope;
@property (retain, nonatomic) NSString *callbackUrl;
@property (retain, nonatomic) NSString *callbackBody;
@property (retain, nonatomic) NSString *returnUrl;
@property (retain, nonatomic) NSString *returnBody;
@property (retain, nonatomic) NSString *asyncOps;
@property (retain, nonatomic) NSString *endUser;
@property int expires;

// Make uptoken string.
- (NSString *)makeToken:(NSString *)accessKey secretKey:(NSString *)secretKey;

@end
