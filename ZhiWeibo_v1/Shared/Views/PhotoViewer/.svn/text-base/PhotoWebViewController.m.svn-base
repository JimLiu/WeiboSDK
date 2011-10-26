    //
//  PhotoWebViewController.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-6.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "PhotoWebViewController.h"
#import "ZhiWeiboAppDelegate.h"


@implementation PhotoWebViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	webView = [[UIWebView alloc]initWithFrame:self.view.frame];
	webView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
	webView.delegate = self;
	[self.view addSubview:webView];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)viewWillDisappear:(BOOL)animated
{
    [webView stopLoading];
  	[webView loadHTMLString:@"<html><style>html { width:320px; height:480px; background-color:white; }</style><body></body></html>" baseURL:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [webView stopLoading];
	[webView release];
    [super dealloc];
}

- (NSMutableString *)generateImageHtml:(NSString *)photoUrl {
	NSMutableString *html = [NSMutableString string];
	[html appendString:@"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">"];
	[html appendString:@"<html>"];
	[html appendString:@"<head>"];
	[html appendString:@"<meta http-equiv=\"Content-type\" content=\"text/html; charset=UTF-8\" />"];
	[html appendString:@"<title>Image View</title>"];
	[html appendString:@"<meta name=\"viewport\" content=\"width=device-width; minimum-scale=1.0; maximum-scale=1.0; user-scalable=0;\"/>"];
	[html appendString:@"<link rel=\"stylesheet\" type=\"text/css\" href=\"tweet_details.css\" media=\"screen\" />"];
	[html appendString:@"<link rel=\"stylesheet\" type=\"text/css\" href=\"tweet_details_retina.css\" media=\"only screen and (-webkit-min-device-pixel-ratio: 2)\">"];
	[html appendString:@"</head>"];
	[html appendString:@"<body bgColor=\"white\" style=\"margin:0px;padding:0px;\">"];
	[html appendFormat:@"<img src=\"%@\" style=\"margin:0px;\" />", photoUrl];
	[html appendString:@"</body>"];
	[html appendString:@"</html>"];
	return html;
}

- (void)loadImage:(NSString *)imageUrl {
	NSString *html = [self generateImageHtml:imageUrl];
	[self loadHtml:html];
}

- (void)loadHtml:(NSString *)html {
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
	[webView loadHTMLString:html baseURL:baseURL];
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request 
 navigationType:(UIWebViewNavigationType)navigationType
{
    return true;
}

- (void)webViewDidStartLoad:(UIWebView *)aWebView
{
	[ZhiWeiboAppDelegate increaseNetworkActivityIndicator];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    [ZhiWeiboAppDelegate decreaseNetworkActivityIndicator];
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error
{
    [ZhiWeiboAppDelegate decreaseNetworkActivityIndicator];
	if ([error code] <= NSURLErrorBadURL) {
        [[ZhiWeiboAppDelegate getAppDelegate] alert:@"加载失败: " 
											message:[error localizedDescription]];
    }
}

@end
