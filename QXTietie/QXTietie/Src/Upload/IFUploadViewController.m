//
//  IFUploadViewController.m
//  QXTietie
//
//  Created by ifwang on 14-3-6.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "IFUploadViewController.h"
#import "IFUploadModel.h"
#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressLabel.h"

@interface IFUploadViewController ()<IFUploadModelDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) IFUploadModel *upModel;

@property (nonatomic, strong) MDRadialProgressView *progressView;

@property (nonatomic, strong) UILabel *resultLbl;

@end

@implementation IFUploadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"上传";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
    
    self.upModel = [[IFUploadModel alloc] init];
    _upModel.delegate = self;
    [_upModel uploadGift:_gift];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View init Method
- (void)initView
{
    [self initProgressView];
    [self initLabel];
}

- (void)initProgressView
{
    MDRadialProgressView *radialView3 = [self progressViewWithFrame:CGRectMake(40, 120, 240, 240)];
	
	radialView3.progressTotal = 100;
    radialView3.progressCounter = 0;
	radialView3.theme.completedColor = HEXCOLOR(0x2894FF);
	radialView3.theme.incompletedColor = [UIColor whiteColor];
    radialView3.theme.thickness = 10;
    radialView3.theme.labelColor = HEXCOLOR(0x2894FF);
    radialView3.label.textColor = HEXCOLOR(0x2894FF);
    radialView3.theme.sliceDividerHidden = YES;
	radialView3.theme.centerColor = [UIColor cloudsColor];
    self.progressView = radialView3;
    [self.view addSubview:_progressView];
}

- (void)initLabel
{
    self.resultLbl = [[UILabel alloc] initWithFrame:CGRectMake(40,[IFCommon screenSize].height - 100 - 44, 240, 20)];
    _resultLbl.backgroundColor = [UIColor clearColor];
    _resultLbl.font = [UIFont flatFontOfSize:16];
    _resultLbl.textAlignment = NSTextAlignmentCenter;
    _resultLbl.textColor = HEXCOLOR(0x4F4F4F);
    _resultLbl.numberOfLines = 1;
    _resultLbl.text = @"上传任务进行中";
    [self.view addSubview:_resultLbl];
}

#pragma mark - Model Delegate Method
- (void)onUploadInProgress:(CGFloat)percent
{
    _progressView.progressCounter = floorf(percent*100);
}

- (void)onUploadSuccessAtIndex:(NSUInteger)currentIndex totalCount:(NSUInteger)totalCount
{
    _progressView.progressCounter = 100;
    
    _resultLbl.text = [NSString stringWithFormat:@"上传任务(%d/%d)已完成~",currentIndex+1,totalCount];
}

- (void)onUploadAllSuccess
{
    _resultLbl.text = @"上传任务全部完成~";
    [self showTextHud:@"上传成功~"];
    double delayInSeconds = 1.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
}

- (void)onUploadFailedAtIndex:(NSUInteger)currentIndex totalCount:(NSUInteger)totalCount
{
    _resultLbl.text = @"上传任务失败~";
}


#pragma mark - Private Method

- (MDRadialProgressView *)progressViewWithFrame:(CGRect)frame
{
	MDRadialProgressView *view = [[MDRadialProgressView alloc] initWithFrame:frame];

	return view;
}

@end
