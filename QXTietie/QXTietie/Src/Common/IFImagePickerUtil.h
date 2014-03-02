//
//  IFImagePickerUtil.h
//  QXTietie
//
//  Created by ifwang on 14-3-2.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface IFImagePickerUtil : NSObject
/**
 *  摄像头是否可用
 */
+ (BOOL) isCameraAvailable;
/**
 *  前方摄像头是否可用
 */
+ (BOOL) isFrontCameraAvailable;

// 后面的摄像头是否可用
+ (BOOL) isRearCameraAvailable;
// 判断是否支持某种多媒体类型：拍照，视频
+ (BOOL)cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType;

// 相册是否可用
+ (BOOL) isPhotoLibraryAvailable;
// 是否可以在相册中选择视频
+ (BOOL) canUserPickVideosFromPhotoLibrary;
// 是否可以在相册中选择视频
+ (BOOL) canUserPickPhotosFromPhotoLibrary;

+ (BOOL) doesCameraSupportShootingVideos;

+ (BOOL) doesCameraSupportTakingPhotos;

@end
