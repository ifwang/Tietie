//
//  IFUploadViewController.m
//  QXTietie
//
//  Created by ifwang on 14-3-6.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "IFUploadViewController.h"
#import "IFUploader.h"
@interface IFUploadViewController ()

@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) IFUploader *uploader;

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
    
    self.uploader = [[IFUploader alloc] init];
    
    UIImage *image = _gift.imageList[0];
    _imageView.image = image;
    [_uploader uploadImage:image];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
