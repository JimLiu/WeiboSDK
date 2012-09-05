//
//  WebViewController.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-20.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "WebViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ZhiWeiboAppDelegate.h"

typedef enum {
    BUTTON_RELOAD,
    BUTTON_STOP,
} ToolbarButton;


@interface WebViewController (Private)
- (void)updateToolbar:(ToolbarButton)state;
@end;

@implementation WebViewController
@synthesize webView, titleLabel, toolbar, backButton, forwardButton;

@synthesize currentURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.hidesBottomBarWhenPushed = YES;
  	}
  	return self;
}

- (void)viewDidLoad
{
    //UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(postTweet:)];
    //self.navigationItem.rightBarButtonItem = postButton;
	
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
	
    
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.tintColor = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBar.topItem.titleView = titleLabel;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [webView stopLoading];
  	[webView loadHTMLString:@"<html><style>html { width:320px; height:480px; background-color:white; }</style><body></body></html>" baseURL:nil];
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	//[ZhiWeiboAppDelegate decreaseNetworkActivityIndicator];
}

- (void)viewDidDisappear:(BOOL)animated
{
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrient
{
    [self.navigationController setNavigationBarHidden:UIInterfaceOrientationIsLandscape(self.interfaceOrientation) animated:true];
}

- (void)updateToolbar:(ToolbarButton)button
{
    UIBarButtonItem *newItem;
	
    if (button == BUTTON_STOP) {
        newItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stop:)] autorelease];
    }
    else {
        newItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload:)] autorelease];
    }
    
    NSMutableArray *items = [toolbar.items mutableCopy];
    [items replaceObjectAtIndex:5 withObject:newItem];
    [toolbar setItems:items animated:false];
    
    [items release];
	
    // workaround to change toolbar state
    backButton.enabled = true;
    forwardButton.enabled = true;
    backButton.enabled = false;
    forwardButton.enabled = false;
    
    backButton.enabled = (webView.canGoBack) ? true : false;
    forwardButton.enabled = (webView.canGoForward) ? true : false;
    
    
}

- (IBAction)reload:(id)sender
{
    [webView reload];
    [self updateToolbar:BUTTON_STOP];
}

- (IBAction)stop:(id)sender
{
    [webView stopLoading];
    [self updateToolbar:BUTTON_RELOAD];
}

- (IBAction) goBack:(id)sender
{
    [webView goBack];
}

- (IBAction) goForward:(id)sender
{
    [webView goForward];
}

- (IBAction) onAction:(id)sender
{
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:@"在Safari中打开", @"复制链接", nil];
    [as showInView:self.navigationController.parentViewController.view];
    [as release];
    
}

- (void)actionSheet:(UIActionSheet *)as clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (as.cancelButtonIndex == buttonIndex) return;
	
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:currentURL];
    }
    else {
        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
		pasteBoard.URL = currentURL;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:openingURL];
    }
}


- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [openingURL release];
    openingURL = [request.URL copy];
    self.currentURL = [request.mainDocumentURL absoluteURL];
    titleLabel.text = @"加载中...";
    return true;
}

- (void)webViewDidStartLoad:(UIWebView *)aWebView
{
    [self updateToolbar:BUTTON_STOP];
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[ZhiWeiboAppDelegate increaseNetworkActivityIndicator];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [ZhiWeiboAppDelegate decreaseNetworkActivityIndicator];
	// Remove all a tag target
    titleLabel.text = [aWebView stringByEvaluatingJavaScriptFromString:
					   @"try {var a = document.getElementsByTagName('a'); for (var i = 0; i < a.length; ++i) { a[i].setAttribute('target', '');}}catch (e){}; document.title"];
    
    NSURL *aURL = aWebView.request.mainDocumentURL;
    self.currentURL = aURL;
    [self updateToolbar:BUTTON_RELOAD];
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error
{
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [ZhiWeiboAppDelegate decreaseNetworkActivityIndicator];
	if ([error code] <= NSURLErrorBadURL) {
        [[ZhiWeiboAppDelegate getAppDelegate] alert:@"页面加载失败: " message:[error localizedDescription]];
    }
    [self updateToolbar:BUTTON_RELOAD];
}

/*
- (void)setURL:(NSURL *)_url {
	if (url != _url) {
		[url release];
		url = [_url	 retain];
	}
}
 */


- (void)loadUrl:(NSURL *)_url {
	titleLabel.text = @"加载中...";
	[webView loadRequest:[NSURLRequest requestWithURL:_url]];
	self.currentURL = _url;
    [self updateToolbar:BUTTON_STOP];
}

- (void)loadHtml:(NSString *)html {
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
	[webView loadHTMLString:html baseURL:baseURL];
    [self updateToolbar:BUTTON_STOP];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}


- (void)dealloc {
	[webView stopLoading];
    [openingURL release];
    [currentURL release];
    //[url release];
	[super dealloc];
}

@end
