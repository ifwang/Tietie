//
//  IFHomeViewController.m
//  QXTietie
//
//  Created by ifwang on 14-2-19.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "IFHomeViewController.h"
#import "IFCardViewController.h"
@interface IFHomeViewController ()

@property (nonatomic, strong) IBOutlet FUIButton *scanBtn;

@property (nonatomic, strong) IBOutlet FUIButton *settingBtn;

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
    
    _scanBtn.buttonColor = HEXCOLOR(0xD2691E);
    _scanBtn.titleLabel.font = [UIFont boldFlatFontOfSize:20];
    [_scanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_scanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    _scanBtn.shadowHeight = 3.0f;
    _scanBtn.cornerRadius = 6.0f;
    
    _settingBtn.buttonColor = HEXCOLOR(0xF08080);
    _settingBtn.titleLabel.font = [UIFont boldFlatFontOfSize:20];
    [_settingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_settingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    _settingBtn.shadowHeight = 3.0f;
    _settingBtn.cornerRadius = 6.0f;
    
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
    IFCardViewController *vc = [[IFCardViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onAudioRecord:(id)sender
{

}


@end
