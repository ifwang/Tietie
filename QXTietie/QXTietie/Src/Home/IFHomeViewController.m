//
//  IFHomeViewController.m
//  QXTietie
//
//  Created by ifwang on 14-2-19.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "IFHomeViewController.h"
#import "IFCardViewController.h"
#import "ZBarSDK.h"
#import "IFScanLayerView.h"
#import "AFNetworking.h"
#import "IFWebViewController.h"
@interface IFHomeViewController ()<ZBarReaderDelegate>

@property (nonatomic, strong) IBOutlet FUIButton *scanBtn;

@property (nonatomic, strong) IBOutlet FUIButton *settingBtn;



//动画所需变量
@property (nonatomic, strong) IFScanLayerView *scanView;

@end

@implementation IFHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
        self.title = @"二维码贴纸";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _scanBtn.buttonColor = HEXCOLOR(0xD2691E);
    _scanBtn.shadowColor = HEXCOLOR(0x8B0000);
    _scanBtn.titleLabel.font = [UIFont boldFlatFontOfSize:20];
    [_scanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_scanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    _scanBtn.shadowHeight = 3.0f;
    _scanBtn.cornerRadius = 6.0f;
    
    _settingBtn.buttonColor = HEXCOLOR(0xF08080);
    _settingBtn.shadowColor = HEXCOLOR(0xA52A2A);
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
    [self scanAction];
//    IFCardViewController *vc = [[IFCardViewController alloc] init];
//    vc.cardId = @"YO53SUsZTVy78Rnup0QD";
//    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onClearMemoryBtnClick:(id)sender
{
    [self showActivator];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
        NSEnumerator *e = [contents objectEnumerator];
        NSString *filename;
        while ((filename = [e nextObject])) {
            
            [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismisActivator];
            [self showTextHud:@"清除成功！"];
        });
    });
    

}


- (void)scanAction
{
    [self showActivator];
    
    ZBarReaderViewController * reader = [ZBarReaderViewController new];
    //设置代理
    reader.readerDelegate = self;
    //支持界面旋转
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    reader.showsHelpOnFail = NO;
    reader.scanCrop = CGRectMake(0.1, 0.2, 0.8, 0.8);//扫描的感应框
    ZBarImageScanner * scanner = reader.scanner;
    [scanner setSymbology:ZBAR_I25
                   config:ZBAR_CFG_ENABLE
                       to:0];
    CGSize screenSize = [IFCommon screenSize];

    IFScanLayerView *view = [[IFScanLayerView alloc] initWithFrame:CGRectMake(0, 0, 320, screenSize.height)];
    reader.cameraOverlayView = view;
    self.scanView = view;
    
    
    [self presentViewController:reader animated:YES completion:^{
        [self dismisActivator];
    }];
    
}

#pragma zbar Delegate Methpd

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"dismiss");
    [_scanView stopAnimation];
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
        
        
    }];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [_scanView stopAnimation];
    [self showActivator];

    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
        UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
        //初始化
        ZBarReaderController * read = [ZBarReaderController new];
        //设置代理
        read.readerDelegate = self;
        CGImageRef cgImageRef = image.CGImage;
        ZBarSymbol * symbol = nil;
        id <NSFastEnumeration> results = [read scanImage:cgImageRef];
        for (symbol in results)
        {
            break;
        }
        NSString * result;
        if ([symbol.data canBeConvertedToEncoding:NSShiftJISStringEncoding])
            
        {
            result = [NSString stringWithCString:[symbol.data cStringUsingEncoding: NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
        }
        else
        {
            result = symbol.data;
        }
        
        
        [self requestCardIdValid:result];

    }];
}

- (void)requestCardIdValid:(NSString*)url
{
    if (url == nil)
    {
        [self showTextHud:@"卡片未存在"];
        return;
    }
    
    NSString *cardId = [IFCommon cardIdFromUrl:url];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:kCardIDValid parameters:@{@"qrcode":cardId}
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self dismisActivator];
             NSDictionary *dict = responseObject;
             NSString *errCode = [dict objectForKey:@"code"];
             
         if ([errCode integerValue] == 300)
         {
             [self showTextHud:@"读取卡片信息成功"];
             
             double delayInSeconds = 1;
             dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
             dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                 IFCardViewController *vc = [[IFCardViewController alloc] init];
                 vc.cardId = cardId;
                 [self.navigationController pushViewController:vc animated:YES];
             });
             
         }
         else if([errCode integerValue] == 200)
         {
             [self showTextHud:@"读取卡片信息成功"];
             double delayInSeconds = 1;
             dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
             dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                 IFWebViewController *vc = [[IFWebViewController alloc] init];
                 vc.title = @"礼物卡片";
                 vc.url = url;
                 [self.navigationController pushViewController:vc animated:YES];
             });
         }
         else
         {
             [self showTextHud:@"卡片未存在"];
         }
             
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [self showTextHud:@"网络错误"];

    }];
}



@end
