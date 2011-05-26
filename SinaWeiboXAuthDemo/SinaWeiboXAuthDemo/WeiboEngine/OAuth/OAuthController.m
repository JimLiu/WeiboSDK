//
//  OAuthController.m
//  Zhiweibo2
//
//  Created by junmin liu on 11-2-15.
//  Copyright 2011 Openlab. All rights reserved.
//

#import "OAuthController.h"
#import <QuartzCore/CoreAnimation.h>

@implementation OAuthController
@synthesize oAuth;
@synthesize delegate = _delegate;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	queue = [[NSOperationQueue alloc] init];
	oAuth.delegate = self;
	activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	//self.navigationController.navigationItem.rightBarButtonItem = activityIndicatorView;

	activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView];
	self.navigationItem.rightBarButtonItem = activityItem;
	
	
	
	refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
																target:self 
																action:@selector(refreshAction:)];
	//self.navigationItem.rightBarButtonItem = refreshItem;
	
}

- (void)loadView {
	[super loadView];
	
	CGRect appFrame = [UIScreen mainScreen].applicationFrame;
	
	webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,appFrame.size.width,appFrame.size.height)];
	webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:webView];
	webView.dataDetectorTypes = UIDataDetectorTypeNone;
	webView.scalesPageToFit = YES;
	webView.delegate = self;
	
	
	_blockerView = [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 200, 120)] autorelease];
	_blockerView.backgroundColor = [UIColor colorWithWhite: 0.0 alpha: 0.8];
	_blockerView.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
	_blockerView.alpha = 0.0;
	_blockerView.clipsToBounds = YES;
	if ([_blockerView.layer respondsToSelector: @selector(setCornerRadius:)]) 
		[_blockerView.layer setCornerRadius: 10];
	
	UILabel *label = [[[UILabel alloc] initWithFrame: CGRectMake(0, 5, _blockerView.bounds.size.width, 15)] autorelease];
	label.text = NSLocalizedString(@"Please Wait…", nil);
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	label.textAlignment = UITextAlignmentCenter;
	label.font = [UIFont boldSystemFontOfSize: 15];
	[_blockerView addSubview: label];
	
	UIActivityIndicatorView				*spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite] autorelease];
	
	spinner.center = CGPointMake(_blockerView.bounds.size.width / 2, _blockerView.bounds.size.height / 2 + 10);
	[_blockerView addSubview: spinner];
	[self.view addSubview: _blockerView];
	[spinner startAnimating];
	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	[queue release];
	[activityIndicatorView release];
	[activityItem release];
	[refreshItem release];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[oAuth release];
	oAuth = nil;
	webView.delegate = nil;
	[webView release];
	webView = nil;
    [super dealloc];
}


- (void)getPin {
	NSInvocationOperation *operation = [[NSInvocationOperation alloc]
										initWithTarget:oAuth
										selector:@selector(synchronousRequestToken)
										object:nil];
	
	[queue addOperation:operation];
	[operation release];
}

- (void)refreshAction:(id)sender;
{
	[self getPin];
}

/*
#pragma mark Actions
- (void) denied {
	if ([_delegate respondsToSelector: @selector(OAuthControllerFailed:)]) 
		[_delegate OAuthControllerFailed: self];
	[self performSelector: @selector(dismissModalViewControllerAnimated:) withObject: (id) kCFBooleanTrue afterDelay: 1.0];
}

- (void) gotPin: (NSString *) pin {
	_engine.pin = pin;
	[_engine requestAccessToken];
	
	if ([_delegate respondsToSelector: @selector(OAuthController:authenticatedWithUsername:)]) 
		[_delegate OAuthController: self authenticatedWithUsername: _engine.username];
	[self performSelector: @selector(dismissModalViewControllerAnimated:) withObject: (id) kCFBooleanTrue afterDelay: 1.0];
}

- (void) cancel: (id) sender {
	if ([_delegate respondsToSelector: @selector(OAuthControllerCanceled:)]) 
		[_delegate OAuthControllerCanceled: self];
	[self performSelector: @selector(dismissModalViewControllerAnimated:) withObject: (id) kCFBooleanTrue afterDelay: 0.0];
}
*/

#pragma mark -
#pragma mark OAuthTwitterCallbacks protocol

// For all of these methods, we invoked oAuth in a background thread, so these are also called
// in background thread. So we first transfer the control back to main thread before doing
// anything else.

- (void) requestTokenDidSucceed:(OAuth *)_oAuth {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(requestTokenDidSucceed:)
							   withObject:_oAuth
							waitUntilDone:NO];
		return;
	}
    
	
	NSURL *myURL = [NSURL URLWithString:[NSString
										 stringWithFormat:@"%@?oauth_token=%@",
										 _oAuth.authorizeURL,
										 _oAuth.oauth_token]];
		
	
	[webView loadRequest:[NSURLRequest requestWithURL:myURL]];
	
}



- (void) requestTokenDidFail:(OAuth *)_oAuth {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(requestTokenDidFail:)
							   withObject:_oAuth
							waitUntilDone:NO];
		return;
	}
	NSLog(@"requestTokenDidFail");
}

- (void) authorizeTokenDidSucceed:(OAuth *)_oAuth {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(authorizeTokenDidSucceed:)
							   withObject:_oAuth
							waitUntilDone:NO];
		return;
	}
	NSLog(@"authorizeTokenDidSucceed");
	WeiboConnection *connection = [[_oAuth getWeiboConnectionWithDelegate:self 
																  action:@selector(verifyCredentialsResult:obj:)] retain];
	[connection verifyCredentials];
}

- (void) authorizeTokenDidFail:(OAuth *)_oAuth {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(authorizeTokenDidFail:)
							   withObject:_oAuth
							waitUntilDone:NO];
		return;
	}
	NSLog(@"authorizeTokenDidFail");
}

- (void) verifyCredentialsResult:(WeiboConnection*)sender 
							 obj:(NSObject*)obj {
	if (sender.hasError) {		
		NSLog(@"verifyCredentialsResult error!!!, errorMessage:%@, errordetail:%@"
			  , sender.errorMessage, sender.errorDetail);
        return;
    }
	
    if (obj == nil || ![obj isKindOfClass:[NSDictionary class]]) {
		NSLog(@"verifyCredentialsResult data format error.%@", @"");
        return;
    }
    
    
    NSDictionary *dic = (NSDictionary*)obj;
	User *user = [User userWithJsonDictionary:dic];
	NSLog(@"user: %@", user.screenName);
	
	WeiboAccount *account = [WeiboAccount accountWithUser:user oAuth:oAuth];
	[WeiboEngine addWeiboAccount:account selected:YES];
	
	[sender release];
	
}

#pragma mark -
#pragma mark Private Methods

- (NSString *) locateAuthPinInWebView: (UIWebView *) _webView {
	//NSString			*js = @"var d = document.getElementById('oauth-pin'); if (d == null) d = document.getElementById('oauth_pin'); if (d) d = d.innerHTML; if (d == null) {var r = new RegExp('\\\\s[0-9]+\\\\s'); d = r.exec(document.body.innerHTML); if (d.length > 0) d = d[0];} d.replace(/^\\s*/, '').replace(/\\s*$/, ''); d;";
	NSString			*pin;// = [webView stringByEvaluatingJavaScriptFromString: js];
	
	//if (pin.length > 0) return pin;
	
	NSString			*html = [_webView stringByEvaluatingJavaScriptFromString: @"document.body.innerText"];
	
	if (html.length == 0) 
		return nil;
	
	pin = [html stringByMatching:@"[0-9]{6,10}"];
	
	/*
	 const char			*rawHTML = (const char *) [html UTF8String];
	 int					length = strlen(rawHTML), chunkLength = 0;
	 
	 for (int i = 0; i < length; i++) {
	 if (rawHTML[i] < '0' || rawHTML[i] > '9') {
	 if (chunkLength == 6) {
	 char				*buffer = (char *) malloc(chunkLength + 1);
	 
	 memmove(buffer, &rawHTML[i - chunkLength], chunkLength);
	 buffer[chunkLength] = 0;
	 
	 pin = [NSString stringWithUTF8String: buffer];
	 free(buffer);
	 return pin;
	 }
	 chunkLength = 0;
	 } else
	 chunkLength++;
	 }
	 */
	
	return pin;
}


#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
	[ApplicationHelper increaseNetworkActivityIndicator];
	[activityIndicatorView startAnimating];
	self.navigationItem.rightBarButtonItem = activityItem;
	
	[UIView beginAnimations: nil context: nil];
	_blockerView.alpha = 1.0;
	[UIView commitAnimations];
}

- (void)pageLoaded {
	[ApplicationHelper decreaseNetworkActivityIndicator];
	[activityIndicatorView stopAnimating];
	self.navigationItem.rightBarButtonItem = refreshItem;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[self pageLoaded];
}

- (void)webViewDidFinishLoad:(UIWebView *)_webView {
	NSString					*authPin = [self locateAuthPinInWebView: _webView];
	
	if (authPin.length) {
		//[self gotPin: authPin];
		
		NSInvocationOperation *operation = [[NSInvocationOperation alloc]
											initWithTarget:oAuth
											selector:@selector(synchronousAuthorizeTokenWithVerifier:)
											object:authPin];
		[queue addOperation:operation];
		[operation release];
		
		[self pageLoaded];
		return;
	}
	
	[UIView beginAnimations: nil context: nil];
	_blockerView.alpha = 0.0;
	[UIView commitAnimations];
	
	if ([_webView isLoading]) {
		_webView.alpha = 0.0;
	} else {
		_webView.alpha = 1.0;
	}
	
	
	[self pageLoaded];

	
}


- (BOOL) webView: (UIWebView *) _webView 
shouldStartLoadWithRequest: (NSURLRequest *) request 
  navigationType: (UIWebViewNavigationType) navigationType {
	if (navigationType != UIWebViewNavigationTypeOther) 
		_webView.alpha = 0.1;
	return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void) didRotateFromInterfaceOrientation: (UIInterfaceOrientation) fromInterfaceOrientation {
	CGRect frame = ApplicationFrame(self.interfaceOrientation);
	frame.origin.y = 44;
	frame.size.height -= 44;
	//webView.frame = frame;
	_blockerView.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
}

@end
