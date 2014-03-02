//
//  IFImageCardView.m
//  QXTietie
//
//  Created by ifwang on 14-3-2.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "IFImageCardView.h"
#import "IFCardButton.h"
#import "LBorderView.h"
static CGFloat const kImageItemRadius = 80;
static CGFloat const kTopInset = 25;
static NSUInteger const kMaxImageCount = 4;
CGFloat const kImageCardViewHeight = 130;


@interface IFImageCardView()

@property (nonatomic, strong) LBorderView *addBtn;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) CGFloat currentAddBtnOffset;

@property (nonatomic, assign) NSUInteger imageCount;

@end

@implementation IFImageCardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageCount = 0;
        [self initView];
    }
    return self;
}

- (id)init
{
    return [self initWithFrame:CGRectZero];
}

- (void)initView
{
    IFCardButton *button = [IFCardButton button];
    [button setFrame:CGRectMake(15, 15, 290, 100)];
    [self addSubview:button];
    [button setUserInteractionEnabled:NO];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(30, kTopInset, 260, kImageItemRadius)];
    _scrollView.showsHorizontalScrollIndicator = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.contentSize = CGSizeMake(kImageItemRadius, kImageItemRadius);
    [self addSubview:_scrollView];
    
    _currentAddBtnOffset = 0;
    
    self.addBtn = [[LBorderView alloc] initWithFrame:CGRectMake(_currentAddBtnOffset, 0, kImageItemRadius, kImageItemRadius)];
    _addBtn.backgroundColor = [UIColor clearColor];
    _addBtn.borderType = BorderTypeDashed;
    _addBtn.borderColor = HEXCOLOR(0xA9A9A9);
    _addBtn.dashPattern = 8;
    _addBtn.spacePattern = 8;
    _addBtn.borderWidth = 1;
    _addBtn.cornerRadius = 5;
    [_scrollView addSubview:_addBtn];
    
    UIImageView *addImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Plus"]];
    addImg.frame = CGRectMake(25, 25, 30, 30) ;
    addImg.userInteractionEnabled = NO;
    [_addBtn addSubview:addImg];
    
    UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clickBtn.frame = _addBtn.bounds;
    clickBtn.backgroundColor = [UIColor clearColor];
    [clickBtn addTarget:self action:@selector(onAddBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_addBtn addSubview:clickBtn];
    
}

- (void)addImage:(UIImage*)image
{
    _imageCount ++;
    
    UIImageView *newImageView = [[UIImageView alloc] initWithImage:image];
    newImageView.frame = CGRectMake(_currentAddBtnOffset, 0, kImageItemRadius, kImageItemRadius);
    newImageView.contentMode = UIViewContentModeScaleAspectFit;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = newImageView.frame;
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(onImageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = _imageCount - 1;
    
    [UIView animateWithDuration:0.3 animations:^{
        _addBtn.frame = CGRectMake(_currentAddBtnOffset + kImageItemRadius + 10, 0, kImageItemRadius, kImageItemRadius);
        if (_imageCount == kMaxImageCount)
        {
            _addBtn.alpha = 0;
        }
    }completion:^(BOOL finished) {
        _currentAddBtnOffset += kImageItemRadius + 10;
        [_scrollView addSubview:newImageView];
        [_scrollView addSubview:button];
        if (_imageCount == kMaxImageCount)
        {
            [_addBtn removeFromSuperview];
        }
        else
        {
            [_scrollView setContentSize:CGSizeMake((_imageCount +1) * kImageItemRadius + 10 * _imageCount, kImageItemRadius)];
        }
    }];
}

- (void)onAddBtnClicked:(id)sender
{
    [_delegate onAddImageBtnClicked];
}

- (void)onImageBtnClicked:(UIButton*)button
{
    NSUInteger index = button.tag;
    
    [_delegate onImageBtnClicked:index];
    
    
    
}

@end
