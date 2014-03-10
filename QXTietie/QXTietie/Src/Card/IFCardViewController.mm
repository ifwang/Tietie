//
//  IFCardViewController.m
//  QXTietie
//
//  Created by ifwang on 14-3-2.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "IFCardViewController.h"
#import "IFAudioViewController.h"
#import "IFCardView.h"
#import "IFImageCardView.h"
#import "IFImagePickerUtil.h"
#import "UIImage+Compress.h"
#import "IFImageListViewController.h"
#import "IFUploadViewController.h"
@interface IFCardViewController ()<IFAudioViewControllerDelegate,IFCardViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) NSURL *audioURL;

@property (nonatomic, strong) IFCardView *cardView;

@property (nonatomic, strong) NSMutableArray *pickedImages;

@property (nonatomic, strong) NSMutableArray *compressImages;

@end

@implementation IFCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        
        self.title = @"礼物卡片";
        self.pickedImages = [[NSMutableArray alloc] init];
        self.compressImages = [[NSMutableArray alloc] init];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    AdjustInsetsDisable
    
    self.cardView = (IFCardView*)self.view;
    _cardView.delegate = self;
    [_cardView initView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    FUIButton *button = [[FUIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    button.buttonColor = HEXCOLOR(0x2894FF);
    button.shadowColor = HEXCOLOR(0x005757);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.shadowHeight = 2;
    button.cornerRadius = 3;
    [button setTitle:@"提交" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont flatFontOfSize:14];
    [button addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Submit Method

- (void)submit
{
    if ([_cardView gitfText].length == 0)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.animationType = MBProgressHUDAnimationZoomOut;
        hud.labelText = @"祝福寄语不能为空";
        [hud hide:YES afterDelay:0.5];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定上传内容？" delegate:self cancelButtonTitle:@"再改改" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        IFGiftVO *giftVO = [[IFGiftVO alloc] init];
        giftVO.cardId = _cardId;
        if (_audioURL)
        {
            giftVO.audioUrl = _audioURL;
        }
        
        giftVO.imageList = _pickedImages;
        
        giftVO.text = [_cardView gitfText];
        
        giftVO.location = _cardView.location;
        
        giftVO.locationText = _cardView.locationText;
        
        IFUploadViewController *vc = [[IFUploadViewController alloc] init];
        vc.gift = giftVO;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

#pragma mark - KeyBoard Method

- (void)keyboardShow:(NSNotification*)notification
{
    [_cardView onKeyBoardComeUp];
}

- (void)keyboardHide:(NSNotification*)notification
{
    [_cardView onKeyBoardComeDown];
}

#pragma mark - View Delegate Method
- (void)onAudioViewClick
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
    [_cardView setAudioEmptyState:NO];
}

- (void)onImageBtnClicked:(NSUInteger)index
{
    IFImageListViewController *vc = [[IFImageListViewController alloc] init];
    vc.images = _pickedImages;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ImagePicker View Delegate

- (void)onAddImageBtnClick
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择",nil];
    [sheet showInView:_cardView];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self pickImageFromCamera];
    }
    else if(buttonIndex == 1)
    {
        [self pickImageFromLibrary];
    }
}

- (void)pickImageFromCamera
{
    if ([IFImagePickerUtil isCameraAvailable] && [IFImagePickerUtil doesCameraSupportTakingPhotos])
    {
        [self pickImageFromSource:UIImagePickerControllerSourceTypeCamera];
    }
    else
    {
        [self showTextHud:@"设备不支持拍照"];
    }
    
}

- (void)pickImageFromLibrary
{
    if ([IFImagePickerUtil canUserPickPhotosFromPhotoLibrary])
    {
        [self pickImageFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    else
    {
        [self showTextHud:@"进入相册失败"];
    }
}

- (void)pickImageFromSource:(UIImagePickerControllerSourceType)type
{
    // 初始化图片选择控制器
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    [controller setSourceType:type];// 设置类型
    
    // 设置所支持的类型，设置只能拍照，或则只能录像，或者两者都可以
    NSString *requiredMediaType = ( NSString *)kUTTypeImage;
    NSArray *arrMediaTypes=[NSArray arrayWithObjects:requiredMediaType,nil];
    [controller setMediaTypes:arrMediaTypes];

    [controller setAllowsEditing:YES];// 设置是否可以管理已经存在的图片或者视频
    controller.delegate = self;
    
    [self.navigationController presentViewController:controller animated:YES
                                          completion:^{
                                              
                                          }];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    [self showActivator];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    // 判断获取类型：图片
    if ([mediaType isEqualToString:( NSString *)kUTTypeImage])
    {
        UIImage *theImage = nil;
        // 判断，图片是否允许修改
        if ([picker allowsEditing]){
            //获取用户编辑之后的图像
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            // 照片的元数据参数
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [_pickedImages addObject:theImage];
            
            UIImage *compressImg = [theImage scaleToSize:CGSizeMake(80, 80)];
            [_compressImages addObject:compressImg];
            dispatch_async(dispatch_get_main_queue(),^{
                [self dismisActivator];
                [_cardView addImageToCard:compressImg];
            });
        });
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
