//
//  IFCardViewController.m
//  QXTietie
//
//  Created by ifwang on 14-3-2.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "IFCardViewController.h"
#import "IFAudioViewController.h"
@interface IFCardViewController ()<IFAudioViewControllerDelegate>

@property (nonatomic, strong) NSURL *audioURL;

@end

@implementation IFCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        
        self.title = @"礼物卡片";
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

- (IBAction)onAudioClick:(id)sender
{
    IFAudioViewController *vc = [[IFAudioViewController alloc] init];
    if (_audioURL != nil)
    {
        vc.currentUrl = _audioURL;
    }
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onAudioControllerSubmitAudioWithURL:(NSURL *)audioURL
{
    self.audioURL = audioURL;
}


@end
