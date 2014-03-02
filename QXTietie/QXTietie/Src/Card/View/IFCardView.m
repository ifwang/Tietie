//
//  IFCardView.m
//  QXTietie
//
//  Created by ifwang on 14-3-2.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "IFCardView.h"
#import "IFTextView.h"
#import "IFTitleHeader.h"
#import "IFAudioCardView.h"
#import "IFImageCardView.h"
#import "IFMapCardView.h"
static CGFloat const kSectionNum = 1;

typedef NS_ENUM(NSUInteger, kCardViewSection)
{
    kCardViewSectionText,
};

@interface IFCardView()<IFImageCardViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) IFTextView *textView;

@property (nonatomic, strong) IFAudioCardView *audioView;

@property (nonatomic, strong) IFImageCardView *imageView;

@property (nonatomic, strong) IFMapCardView *mapView;

@property (nonatomic, strong) UIView *coverView;

/**
 *  初始化页面所用高度记录
 */
@property (nonatomic, assign) CGFloat currentHeight;

@end

@implementation IFCardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initView
{
    self.coverView = [[UIView alloc] initWithFrame:self.bounds];
    _coverView.hidden = YES;
    _coverView.backgroundColor = [UIColor clearColor];
    _currentHeight = 10;
    
    UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCoverViewTap:)];
    [_coverView addGestureRecognizer:rec];
    [self addSubview:_coverView];
    
    [self initTextView];
    [self initAudioView];
    [self initImageView];
    [self initMapView];
    
    _scrollView.contentSize = CGSizeMake(320, _currentHeight + 20);
    
}

- (void)initTextView
{
    IFTitleHeader *header = [[IFTitleHeader alloc] initWithFrame:CGRectMake(0, _currentHeight, 320, kTitleHeaderHeight)];
    [header setTitle:@"祝福寄语"];
    [header setHeaderTintColor:HEXCOLOR(0x5F9EA0)];
    [_scrollView addSubview:header];
    
    _currentHeight += kTitleHeaderHeight;
    
    self.textView = [[IFTextView alloc] initWithFrame:CGRectMake(15, _currentHeight + 5, 290, 80)];
    [_scrollView addSubview:_textView];
    
    _currentHeight += 10 + 80;

}

- (void)initAudioView
{
    IFTitleHeader *header = [[IFTitleHeader alloc] initWithFrame:CGRectMake(0, _currentHeight, 320, kTitleHeaderHeight)];
    [header setTitle:@"音频卡片"];
    [header setHeaderTintColor:HEXCOLOR(0x0088FF)];
    [_scrollView addSubview:header];
    
    _currentHeight += kTitleHeaderHeight;

    
    IFAudioCardView *audioView = [[IFAudioCardView alloc] initWithFrame:CGRectMake(0, _currentHeight + 5, 320, kAudioCardViewHeight)];
    [_scrollView addSubview:audioView];
    [audioView addTarget:self onSeletor:@selector(onAudioViewClick:)];
    self.audioView = audioView;
    
    _currentHeight += kAudioCardViewHeight + 10;

    
}

- (void)initImageView
{
    IFTitleHeader *header = [[IFTitleHeader alloc] initWithFrame:CGRectMake(0, _currentHeight, 320, kTitleHeaderHeight)];
    [header setTitle:@"相册卡片"];
    [header setHeaderTintColor:HEXCOLOR(0xEE82EE)];
    [_scrollView addSubview:header];
    
    _currentHeight += kTitleHeaderHeight;
    
    self.imageView = [[IFImageCardView alloc] initWithFrame:CGRectMake(0, _currentHeight + 5, 320, kImageCardViewHeight)];
    _imageView.delegate = self;
    [_scrollView addSubview:_imageView];
    _currentHeight += kImageCardViewHeight + 10;
    
}

- (void)initMapView
{
    IFTitleHeader *header = [[IFTitleHeader alloc] initWithFrame:CGRectMake(0, _currentHeight, 320, kTitleHeaderHeight)];
    [header setTitle:@"实时位置卡片"];
    [header setHeaderTintColor:HEXCOLOR(0xD2691E)];
    [_scrollView addSubview:header];
    
    _currentHeight += kTitleHeaderHeight;
    
    self.mapView = [[IFMapCardView alloc] initWithFrame:CGRectMake(0, _currentHeight + 5, 320, kMapCardViewHeight)];
    [_scrollView addSubview:_mapView];
    _currentHeight += kMapCardViewHeight + 10;
    
}

#pragma mark - View Delegate Method

- (void)onAudioViewClick:(id)sender
{
    [_delegate onAudioViewClick];
}

- (void)onAddImageBtnClicked
{
    [_delegate onAddImageBtnClick];
}
- (void)onImageBtnClicked:(NSUInteger)index
{
    [_delegate onImageBtnClicked:index];
}


#pragma mark - Private Method

- (void)setAudioEmptyState:(BOOL)isEmpty
{
    [_audioView setAudioViewHidden:isEmpty];
}


- (void)onKeyBoardComeUp
{
    [self bringSubviewToFront:_coverView];
    _coverView.hidden = NO;
}

- (void)onCoverViewTap:(UIGestureRecognizer*)rec
{
    _coverView.hidden = YES;
    [self sendSubviewToBack:_coverView];
    [_textView hideKeyBoard];
}

- (void)addImageToCard:(UIImage*)image
{
    [_imageView addImage:image];
}


@end
