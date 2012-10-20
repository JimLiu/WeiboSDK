//
//  WeiboSignInViewController.m
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-8-26.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "WeiboSignInViewController.h"
#import "MBProgressHUD.h"

@interface WeiboSignInViewController ()

@end

@implementation WeiboSignInViewController
@synthesize authentication = _authentication;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
        _stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stop:)];
        _refreshButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
        _stopButton.style = UIBarButtonItemStylePlain;
        _refreshButton.style = UIBarButtonItemStylePlain;
    }
    return self;
}

- (void)dealloc {
    [_cancelButton release];
    [_stopButton release];
    [_refreshButton release];
    [_authentication release];
    [super dealloc];
}

- (void)cancel:(id)sender {
    [HUD hide:YES];
    _closed = YES;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)stop:(id)sender {
    
}

- (void)refresh:(id)sender {
    _closed = NO;
    NSURL *url = [NSURL URLWithString:self.authentication.authorizeRequestUrl];
    NSLog(@"request url: %@", url);
    NSURLRequest *request =[NSURLRequest requestWithURL:url
                                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                        timeoutInterval:60.0];
    [_webView loadRequest:request];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin
                | UIViewAutoresizingFlexibleTopMargin
                | UIViewAutoresizingFlexibleRightMargin
                | UIViewAutoresizingFlexibleBottomMargin
                | UIViewAutoresizingFlexibleWidth
                | UIViewAutoresizingFlexibleHeight;
    _webView.delegate = self;
    [self.view addSubview:_webView];
    [_webView release];
    
    NSString *html = [NSString stringWithFormat:@"<html><body><div align=center>%@</div></body></html>", @"加载中..."/*NSLocalizedString(@"SignInWebView_InitialMessageHTMLString", @"InitialMessageHTMLString")*/];
    [_webView loadHTMLString:html baseURL:nil];
    
    self.navigationItem.leftBarButtonItem = _cancelButton;
    self.navigationItem.rightBarButtonItem = _refreshButton;
    
    [self refresh:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _webView = nil;
    [HUD hide:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIWebViewDelegate Methods

- (void)webViewDidStartLoad:(UIWebView *)aWebView
{
	self.title = @"加载中...";//NSLocalizedString(@"WebView_Loading", @"Loading");
    self.navigationItem.rightBarButtonItem = _stopButton;
    
    if (!HUD) {
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.view addSubview:HUD];
        
        HUD.delegate = self;
        HUD.labelText = @"加载中...";//NSLocalizedString(@"WebView_Loading", @"Loading");
        [HUD show:YES];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
	self.title = [aWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.rightBarButtonItem = _refreshButton;
    [HUD hide:YES];
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error
{
    if (error.code != NSURLErrorCancelled && !_closed) {
        self.title = @"网页加载失败";//NSLocalizedString(@"WebView_FailedToLoad", @"Failed to load web page");
        self.navigationItem.rightBarButtonItem = _refreshButton;
        HUD.labelText = @"网页加载失败";//NSLocalizedString(@"WebView_FailedToLoad", @"Failed to load web page");
        [HUD hide:YES afterDelay:2];
    }
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSRange range = [request.URL.absoluteString rangeOfString:@"code="];
    
    if (range.location != NSNotFound)
    {
        NSString *code = [request.URL.absoluteString substringFromIndex:range.location + range.length];
        NSLog(@"code: %@", code);
        
        if ([_delegate respondsToSelector:@selector(didReceiveAuthorizeCode:)])
        {
            [_delegate performSelector:@selector(didReceiveAuthorizeCode:) withObject:code];
        }
        [self cancel:nil];
    }
    
    return YES;
}


#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	[HUD release];
	HUD = nil;
}
@end
