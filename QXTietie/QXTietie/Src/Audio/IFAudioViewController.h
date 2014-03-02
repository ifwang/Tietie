//
//  IFAudioViewController.h
//  QXTietie
//
//  Created by ifwang on 14-2-19.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "IFBaseViewController.h"

@protocol IFAudioViewControllerDelegate

- (void)onAudioControllerSubmitAudioWithURL:(NSURL*)audioURL;

@end

@interface IFAudioViewController : IFBaseViewController

@property (nonatomic, weak) id<IFAudioViewControllerDelegate> delegate;

/**
 *  目前音频URL
 */
@property (nonatomic, strong) NSURL *currentUrl;

@end
