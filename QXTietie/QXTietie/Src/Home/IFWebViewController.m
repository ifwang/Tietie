//
//  IFWebViewController.m
//  QXTietie
//
//  Created by ifwang on 14-3-8.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "IFWebViewController.h"

@interface IFWebViewController ()<UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;


@end

@implementation IFWebViewController

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
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    
    NSString *htmlString = @"<!DOCTYPE HTML><html><body></body></html>";
    [self.webView loadHTMLString:htmlString baseURL:nil];
    [self.webView performSelector:@selector(loadRequest:) withObject:request afterDelay:0.8];

}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showActivator];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self dismisActivator];

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([[webView.request.URL absoluteString] isEqual:@"about:blank"])
    {
        switch (error.code)
        {
            case NSURLErrorNotConnectedToInternet:
            case NSURLErrorTimedOut:
            {
                NSString *errMsg = @"网络异常";
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errMsg
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles: nil];
                [alert show];
            }
                
            default:
                break;
        }
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
