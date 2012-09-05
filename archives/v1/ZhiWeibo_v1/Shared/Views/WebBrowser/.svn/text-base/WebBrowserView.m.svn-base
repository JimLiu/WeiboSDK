//
//  WebBrowserView.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-5.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "WebBrowserView.h"


@implementation WebBrowserView
@synthesize webBrowserViewDelegate;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"light-hash-background.png"]];
		
		webView = [[UIWebView alloc]initWithFrame:CGRectZero];
		webView.backgroundColor = [UIColor clearColor];
		webView.frame = CGRectMake(0,44,frame.size.width,frame.size.height-44);
		webView.scalesPageToFit = YES;
		webView.delegate = self;
		[self addSubview: webView];
		
		toolBar = [[UIToolbar alloc]initWithFrame:CGRectZero];
		toolBar.frame = CGRectMake(0, 0, frame.size.width, 44);
		//toolBar.translucent = YES;
		//toolBar.tintColor = [UIColor colorWithWhite:0.85 alpha:1.0];
		//toolBar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iPad-bottom-toolbar.png"]];
		//toolBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iPad-bottom-toolbar.png"]];
		//toolBar.backgroundColor = [UIColor clearColor];
		//toolBar.opaque = NO;
		
		[self addSubview:toolBar];
		
		btnGoForward = [[UIBarButtonItem alloc]
						initWithImage:[UIImage imageNamed:@"iPad-webforward.png"]
						style:UIBarButtonItemStylePlain 
						target:self 
						action:@selector(didBtnGoForwardTouch:)];
		btnGoForward.enabled = NO;
		btnGoForward.width = 50;
		btnGoBack = [[UIBarButtonItem alloc]
					 initWithImage:[UIImage imageNamed:@"iPad-webback.png"]
					 style:UIBarButtonItemStylePlain 
					 target:self 
					 action:@selector(didBtnGoBackTouch:)];
		btnGoBack.enabled = NO;
		btnGoBack.width = 50;
		btnZoomOut = [[UIBarButtonItem alloc]
					  initWithTitle:@"关闭"
					  style:UIBarButtonItemStyleDone
					  target:self action:@selector(didBtnZoomOutTouch:)];
		btnZoomOut.width = 50;
		btnAction = [[UIBarButtonItem alloc]
					 initWithImage:[UIImage imageNamed:@"action.png"]
					 style:UIBarButtonItemStylePlain
					 target:self action:@selector(didBtnActionTouch:)];
		btnAction.width = 50;
		
		UIImageView *_view = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"iPad-web-bar-clean.png"] stretchableImageWithLeftCapWidth:30.0 topCapHeight:30.0]];
		space = [[UIBarButtonItem alloc]initWithCustomView:_view];
		space.width = toolBar.frame.size.width - 270;
		[_view release];
		
		[toolBar setItems:[NSArray arrayWithObjects:btnGoBack,btnGoForward,space,btnAction,btnZoomOut,nil]];
		
		btnRefresh = [[UIButton alloc] initWithFrame:CGRectMake(135, 7, 30, 30)];
		btnRefresh.backgroundColor = [UIColor clearColor];
		[btnRefresh setImage:[UIImage imageNamed:@"iPad-web-reload.png"] forState:UIControlStateNormal];
		[btnRefresh addTarget:self action:@selector(didBtnRefreshTouch:) forControlEvents:UIControlEventTouchUpInside];
		[toolBar addSubview:btnRefresh];
		
		lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(165,7,400,26)];
		lblTitle.backgroundColor = [UIColor clearColor];
		lblTitle.text = @"";
		[toolBar addSubview:lblTitle];
		
		loadingView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iPad-web-bar-refresh.png"]];
		loadingView.frame = CGRectMake(133, 7, 30, 30);
		loadingView.hidden = YES;
		[toolBar addSubview:loadingView];
		
		activityIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
		[loadingView addSubview:activityIndicatorView];
		
		actionSheet = [[UIActionSheet alloc]initWithTitle:nil
												 delegate:self
										cancelButtonTitle:nil
								   destructiveButtonTitle:nil
										otherButtonTitles:@"在Safari中打开", @"复制网页链接",nil];
		
		
    }
    return self;
}

- (void)layoutSubviews {
	webView.frame = CGRectMake(0, 44, self.frame.size.width, self.frame.size.height - 44);
	toolBar.frame = CGRectMake(0, 0, self.frame.size.width, 44);
	space.width = toolBar.frame.size.width - 270;
}

- (void)dealloc {
    [super dealloc];
	[webView release];
	[toolBar release];
	[btnGoBack release];
	[btnGoForward release];
	[btnRefresh release];
	[btnZoomOut release];
	[btnAction release];
	[activityIndicatorView release];
	[actionSheet release];
	[space release];
	[lblTitle release];
}


- (void)hideActionSheet {
	if ([actionSheet isVisible]) {
		[actionSheet dismissWithClickedButtonIndex:-1 animated:YES];
	}
}

- (void)loadURL:(NSURL *)url {
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[webView loadRequest:request];
	webView.frame = CGRectMake(0, self.frame.size.height, webView.frame.size.width, webView.frame.size.height);
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelay:0.5];
	[UIView setAnimationDuration:1.0];
	webView.frame = CGRectMake(0, 44, webView.frame.size.width, webView.frame.size.height);
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark ButtonTough

- (void)didBtnGoForwardTouch:(id)sender {
	[webView goForward];
}

- (void)didBtnGoBackTouch:(id)sender {
	[webView goBack];
}

- (void)didBtnRefreshTouch:(id)sender {
	[webView reload];
}

- (void)didBtnActionTouch:(id)sender {
	if(![actionSheet isVisible]){
		actionSheet.title = [[webView.request URL] absoluteString];
		[actionSheet showFromBarButtonItem:sender animated:YES];
	}
	else
	{
		[actionSheet dismissWithClickedButtonIndex:-1 animated:YES];
	}
}

-(void) didBtnOpenInSafariTouch:(id)sender {
	if([[UIApplication sharedApplication] canOpenURL:[webView.request URL]])
		[[UIApplication sharedApplication] openURL:[webView.request URL]];
}

-(void) didBtnCopyLinkTouch:(id)sender {
	UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
	pasteBoard.URL = [webView.request URL];
}

- (void)didBtnZoomOutTouch:(id)sender {
	[self hideActionSheet];
	[webView stopLoading];
	[self loadURL:[NSURL URLWithString:@"about:blank"]];
	if (webBrowserViewDelegate) {
		[webBrowserViewDelegate hideWebBrowser];
	}
}


#pragma mark -
#pragma mark WebViewDelegate

- (BOOL)webView:(UIWebView *)_webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType { 
	
	lblTitle.text = [[request URL] absoluteString];
    return YES; 
}

- (void)webViewDidStartLoad:(UIWebView *)_webView {
	loadingView.hidden = NO;
	[activityIndicatorView startAnimating];
	btnRefresh.enabled = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)_webView {
	btnGoForward.enabled = [webView canGoForward];
	btnGoBack.enabled = [webView canGoBack];
	lblTitle.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
	
	//NSString *state = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
	//if([state isEqualToString:@"complete"])
	//{
		loadingView.hidden = YES;
		[activityIndicatorView stopAnimating];
		btnRefresh.enabled = YES;
	//}
	//[webView stringByEvaluatingJavaScriptFromString:@"{ var a = document.getElementsByTagName(\"a\");  for (var i=0; i<a.length; i++)  { a.target = \"_self\"; }     }"];
}

- (void)webView:(UIWebView *)_webView didFailLoadWithError:(NSError *)error {
	NSLog(@"error");
}

#pragma mark -
#pragma mark ActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	switch (buttonIndex) {
		case 0:
			[self didBtnOpenInSafariTouch:nil];
			break;
		case 1:
			[self didBtnCopyLinkTouch:nil];
			break;
		default:
			break;
	}
}

@end
