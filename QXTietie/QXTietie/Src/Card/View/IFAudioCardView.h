//
//  IFAudioCardView.h
//  QXTietie
//
//  Created by ifwang on 14-3-2.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const kAudioCardViewHeight;

@interface IFAudioCardView : UIView

- (void)setAudioViewHidden:(BOOL)hidden;

- (void)addTarget:(id)target onSeletor:(SEL)seletor;

@end
