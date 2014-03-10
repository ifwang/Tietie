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
#import "IFWebViewController.h"

@interface IFUploadViewController ()<IFUploadModelDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) IFUploadModel *upModel;

@property (nonatomic, strong) MDRadialProgressView *progressView;

@property (nonatomic, strong) UILabel *resultLbl;

@property (nonatomic, assign) BOOL isUploaded;

@property (nonatomic, strong) FUIButton *resultBtn;

@end

@implementation IFUploadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"上传";
        _isUploaded = NO;
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
    [self initResultBtn];
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

- (void)initResultBtn
{
    CGSize screenSize = [IFCommon screenSize];
    CGFloat height = screenSize.height - 44 - 60;
    
    self.resultBtn = [[FUIButton alloc] initWithFrame:CGRectMake(40, height, 240, 40)];
    _resultBtn.buttonColor = HEXCOLOR(0x2894FF);
    _resultBtn.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [_resultBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_resultBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    _resultBtn.shadowHeight = 3.0f;
    _resultBtn.cornerRadius = 6.0f;
    _resultBtn.shadowColor = HEXCOLOR(0x003E3E);
    [_resultBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_resultBtn setTitle:@"查看卡片" forState:UIControlStateNormal];
    _resultBtn.alpha = 0;
    [_resultBtn addTarget:self action:@selector(resultAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_resultBtn];

}

- (void)resultAction:(id)sender
{
    NSString *url = [NSString stringWithFormat:@"http://112.124.101.16/?qrcode=%@",_gift.cardId];

    IFWebViewController *vc = [[IFWebViewController alloc] init];
    vc.title = @"礼物卡片";
    vc.url = url;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

#pragma mark - Model Delegate Method
- (void)onUploadInProgress:(CGFloat)percent
{
    _progressView.progressCounter = floorf(percent*100);
}

- (void)onUploadSuccessAtIndex:(NSUInteger)currentIndex totalCount:(NSUInteger)totalCount
{
    
    _resultLbl.text = [NSString stringWithFormat:@"上传任务(%d/%d)已完成~",currentIndex+1,totalCount];
}

- (void)onUploadAllSuccess
{
    _progressView.progressCounter = 100;

    _resultLbl.text = @"上传任务全部完成~";
    [self showTextHud:@"上传成功~"];
    _isUploaded = YES;
    [UIView animateWithDuration:0.3 animations:^{
        _resultBtn.alpha = 1;
    }];
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

- (void)goBack
{
    if (_isUploaded)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"停止上传" message:@"确定停止上传？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [_upModel stop];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
