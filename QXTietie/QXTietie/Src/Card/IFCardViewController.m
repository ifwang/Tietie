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
@interface IFCardViewController ()<IFAudioViewControllerDelegate,IFCardViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) NSURL *audioURL;

@property (nonatomic, strong) IFCardView *cardView;

@property (nonatomic, strong) NSMutableArray *pickedImages;

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

#pragma mark - KeyBoard Method

- (void)keyboardShow:(NSNotification*)notification
{
    [_cardView onKeyBoardComeUp];
}

- (void)keyboardHide:(NSNotification*)notification
{
    
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
