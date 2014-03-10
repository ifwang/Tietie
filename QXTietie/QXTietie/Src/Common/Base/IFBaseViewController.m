//
//  IFBaseViewController.m
//  QXTietie
//
//  Created by ifwang on 14-2-19.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "IFBaseViewController.h"

@interface IFBaseViewController ()

@property (nonatomic, strong) UILabel *titleView;

@end

@implementation IFBaseViewController

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
	// Do any additional setup after loading the view.
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldFlatFontOfSize:18];
    titleLabel.text = self.title;
    CGSize size = [titleLabel.text sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(200, 20)];
    titleLabel.frame = CGRectMake(0, 0, size.width, 20);
    titleLabel.textColor = HEXCOLOR(0x272727);
    self.navigationItem.titleView = titleLabel;
    self.titleView = titleLabel;
    
    if ([self.navigationController.viewControllers count]> 1)
    {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:[UIImage imageNamed:@"NavigationBackIcon"] forState:UIControlStateNormal];
        backBtn.frame = CGRectMake(0, 0, 20, 20);
        [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        self.navigationItem.leftBarButtonItem = item;
    }

    
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    _titleView.text = title;
    CGSize size = [_titleView.text sizeWithFont:_titleView.font constrainedToSize:CGSizeMake(200, 20)];
    _titleView.frame = CGRectMake(0, 0, size.width, 20);
}

- (void)showTextHud:(NSString*)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.labelText = text;
    [hud hide:YES afterDelay:1];
}

- (void)showActivator
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.animationType = MBProgressHUDAnimationZoom;
}

- (void)dismisActivator
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
