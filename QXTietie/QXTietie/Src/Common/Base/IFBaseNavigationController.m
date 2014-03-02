//
//  IFBaseNavigationController.m
//  QXTietie
//
//  Created by ifwang on 14-3-2.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "IFBaseNavigationController.h"
#import "IFNavigationBar.h"
@interface IFBaseNavigationController ()<UINavigationControllerDelegate>

@end

@implementation IFBaseNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.delegate = self;
        [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor belizeHoleColor]];

    }
    return self;
}

- (id)init
{
    self = [super initWithNavigationBarClass:[IFNavigationBar class] toolbarClass:nil];
    if(self) {
        // Custom initialization here, if needed.
        IFNavigationBar *navigationBar = (IFNavigationBar *)self.navigationBar;
        
        [navigationBar setBarTintColor:[UIColor cloudsColor]];
        if (!IOS7_OR_LATER)
        {
            [navigationBar setBackgroundImage:[IFCommon defaultColorImage:[UIColor cloudsColor]] forBarMetrics:UIBarMetricsDefault];
        }
        
        self.delegate = self;
    }
    return self;
    
    return self;
}
- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithNavigationBarClass:[IFNavigationBar class] toolbarClass:nil];
    if(self){
        self.viewControllers = @[rootViewController];
        
        IFNavigationBar *navigationBar = (IFNavigationBar *)self.navigationBar;
        [navigationBar setBarTintColor:[UIColor cloudsColor]];
        if (!IOS7_OR_LATER)
        {
            [navigationBar setBackgroundImage:[IFCommon defaultColorImage:[UIColor cloudsColor]] forBarMetrics:UIBarMetricsDefault];
        }
        
        self.delegate = self;
    }
    
    return self;

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
