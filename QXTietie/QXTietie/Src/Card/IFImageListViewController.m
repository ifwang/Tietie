//
//  IFImageListViewController.m
//  QXTietie
//
//  Created by ifwang on 14-3-3.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "IFImageListViewController.h"
#import "SwipeView.h"
@interface IFImageListViewController ()<SwipeViewDataSource,SwipeViewDelegate>

@property (nonatomic, strong) SwipeView *swipeView;

@end

@implementation IFImageListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor cloudsColor];
    
    [self initView];
    
    [self updateTitle];
    [_swipeView scrollToPage:_currentIndex duration:0.5];
    
    
}

                  
- (void)initView
{
    SwipeView *swipeView = [[SwipeView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:swipeView];
    swipeView.delegate = self;
    swipeView.dataSource = self;
    swipeView.itemsPerPage = 1;
    swipeView.pagingEnabled = YES;
    swipeView.wrapEnabled = NO;
    swipeView.scrollEnabled = YES;
    swipeView.alignment = SwipeViewAlignmentCenter;
    self.swipeView = swipeView;
}
- (void)updateTitle
{
    if(_images==nil || [_images count] ==0)
    {
        self.title = @"相册卡片";
    }
    else
    {
        self.title = [NSString stringWithFormat:@"相册卡片(%d/%d)",_currentIndex+1,[_images count]];
    }
}
                  
#pragma mark - SwipeView Delegate Method

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return (_images == nil)?0:[_images count];
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIImageView *imageView = (UIImageView*)view;
    if (imageView == nil)
    {
        imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        imageView.backgroundColor = [UIColor blackColor];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    imageView.image = [_images objectAtIndex:index];
    
    return imageView;
}

- (void)swipeViewDidEndDragging:(SwipeView *)swipeView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        _currentIndex = swipeView.currentItemIndex;
        [self updateTitle];
    }

}

- (void)swipeViewDidEndDecelerating:(SwipeView *)swipeView
{
    _currentIndex = swipeView.currentItemIndex;
    [self updateTitle];
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
