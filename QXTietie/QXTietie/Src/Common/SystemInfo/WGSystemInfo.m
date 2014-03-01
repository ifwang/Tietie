//
//  WGSystemInfo.m
//  wego
//
//  Created by ifwang on 13-10-18.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "WGSystemInfo.h"
#import "UIDevice+Hardware.h"

@implementation WGSystemInfo


+ (NSString *)osVersion
{
	return [NSString stringWithFormat:@"%@%@", [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion];
}

+ (NSString *)appVersion
{
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)buildVersion
{
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString *)deviceModel
{
	return [UIDevice currentDevice].model;
}





static const char * __jb_app = NULL;

+ (BOOL)isJailBroken
{
	static const char * __jb_apps[] =
	{
		"/Application/Cydia.app",
		"/Application/limera1n.app",
		"/Application/greenpois0n.app",
		"/Application/blackra1n.app",
		"/Application/blacksn0w.app",
		"/Application/redsn0w.app",
		NULL
	};
    
	__jb_app = NULL;
    
	// method 1
    for ( int i = 0; __jb_apps[i]; ++i )
    {
        if ( [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:__jb_apps[i]]] )
        {
			__jb_app = __jb_apps[i];
			return YES;
        }
    }
	
    // method 2
	if ( [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"] )
	{
		return YES;
	}
	
	// method 3
	if ( 0 == system("ls") )
	{
		return YES;
	}
	
    return NO;
}

+ (NSString *)jailBreaker
{
	if ( __jb_app )
	{
		return [NSString stringWithUTF8String:__jb_app];
	}
	else
	{
		return @"";
	}
}


+ (NSString *) platform
{
    return [[UIDevice currentDevice] platform];
}

+ (NSString *) hwmodel
{
    return [[UIDevice currentDevice] hwmodel];
}

+ (NSUInteger) platformType
{
    return [[UIDevice currentDevice] platformType];
}

+ (NSString *) platformString
{
    return [[UIDevice currentDevice] platformString];
}



+ (BOOL)isDevicePhone
{
	NSString * deviceType = [UIDevice currentDevice].model;
	
	if ( [deviceType rangeOfString:@"iPhone" options:NSCaseInsensitiveSearch].length > 0 ||
		[deviceType rangeOfString:@"iPod" options:NSCaseInsensitiveSearch].length > 0 ||
		[deviceType rangeOfString:@"iTouch" options:NSCaseInsensitiveSearch].length > 0 )
	{
		return YES;
	}
	
	return NO;
}

+ (BOOL)isDevicePad
{
	NSString * deviceType = [UIDevice currentDevice].model;
	
	if ( [deviceType rangeOfString:@"iPad" options:NSCaseInsensitiveSearch].length > 0 )
	{
		return YES;
	}
	return NO;
}

+ (BOOL)isPhone35
{
	return [WGSystemInfo isScreenSize:CGSizeMake(320, 480)];
}

+ (BOOL)isPhoneRetina35
{
	return [WGSystemInfo isScreenSize:CGSizeMake(640, 960)];
}

+ (BOOL)isPhoneRetina4
{
	return [WGSystemInfo isScreenSize:CGSizeMake(640, 1136)];
}

+ (BOOL)isPad
{
	return [WGSystemInfo isScreenSize:CGSizeMake(768, 1024)];
}

+ (BOOL)isPadRetina
{
	return [WGSystemInfo isScreenSize:CGSizeMake(1536, 2048)];
}

+ (BOOL)isScreenSize:(CGSize)size
{
	if ( [UIScreen instancesRespondToSelector:@selector(currentMode)] )
	{
		CGSize screenSize = [UIScreen mainScreen].currentMode.size;
		CGSize size2 = CGSizeMake( size.height, size.width );
        
		if ( CGSizeEqualToSize(size, screenSize) || CGSizeEqualToSize(size2, screenSize) )
		{
			return YES;
		}
	}
	
	return NO;
}
@end
