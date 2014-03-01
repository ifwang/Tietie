//
//  IFHomeViewController.m
//  QXTietie
//
//  Created by ifwang on 14-2-19.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "IFHomeViewController.h"
#import "IFScanerViewController.h"
#import "IFAudioViewController.h"
@interface IFHomeViewController ()

@end

@implementation IFHomeViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  二维码扫描
 */
- (IBAction)onQRCodeScanBtnClicked:(id)sender
{
    IFScanerViewController *vc = [[IFScanerViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onAudioRecord:(id)sender
{
    IFAudioViewController *vc = [[IFAudioViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
@end
