//
//  OAuthController.m
//  WeiboPad
//
//  Created by junmin liu on 10-10-5.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "OAuthController.h"
#import "OAuthEngine.h"

@interface OAuthController ()
@property (nonatomic, readonly) UIToolbar *pinCopyPromptBar;
@property (nonatomic, readwrite) UIInterfaceOrientation orientation;

- (id) initWithEngine: (OAuthEngine *) engine andOrientation:(UIInterfaceOrientation)theOrientation;
//- (void) performInjection;
- (NSString *) locateAuthPinInWebView: (UIWebView *) webView;

- (void) showPinCopyPrompt;
- (void) gotPin: (NSString *) pin;
@end


@interface DummyClassForProvidingSetDataDetectorTypesMethod
- (void) setDataDetectorTypes: (int) types;
- (void) setDetectsPhoneNumbers: (BOOL) detects;
@end

@interface NSString (OAuth)
- (BOOL) oauth_isNumeric;
@end

@implementation NSString (OAuth)
- (BOOL) oauth_isNumeric {
	const char				*raw = (const char *) [self UTF8String];
	
	for (int i = 0; i < strlen(raw); i++) {
		if (raw[i] < '0' || raw[i] > '9') return NO;
	}
	return YES;
}
@end

@implementation OAuthController
@synthesize engine = _engine, delegate = _delegate, navigationBar = _navBar, orientation = _orientation;


- (void) dealloc {
	
	[[NSNotificationCenter defaultCenter] removeObserver: self];
	_webView.delegate = nil;
	[_webView loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: @""]]];
	[_webView release];
	
	self.view = nil;
	self.engine = nil;
	[super dealloc];
}

+ (OAuthController *) controllerToEnterCredentialsWithEngine: (OAuthEngine *) engine delegate: (id <OAuthControllerDelegate>) delegate forOrientation: (UIInterfaceOrientation)theOrientation {
	if (![self credentialEntryRequiredWithEngine: engine]) return nil;			//not needed
	
	OAuthController					*controller = [[[OAuthController alloc] initWithEngine: engine andOrientation: theOrientation] autorelease];
	
	controller.delegate = delegate;
	return controller;
}

+ (OAuthController *) controllerToEnterCredentialsWithEngine: (OAuthEngine *) engine delegate: (id <OAuthControllerDelegate>) delegate {
	return [OAuthController controllerToEnterCredentialsWithEngine: engine delegate: delegate forOrientation: UIInterfaceOrientationPortrait];
}


+ (BOOL) credentialEntryRequiredWithEngine: (OAuthEngine *) engine {
	return ![engine isAuthorized];
}


- (id) initWithEngine: (OAuthEngine *) engine andOrientation:(UIInterfaceOrientation)theOrientation {
	if (self = [super init]) {
		self.engine = engine;
		if (!engine.OAuthSetup) [_engine requestRequestToken];
		self.orientation = theOrientation;
		_firstLoad = YES;
		
		
		[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(pasteboardChanged:) name: UIPasteboardChangedNotification object: nil];
	}
	return self;
}

//=============================================================================================================================
#pragma mark Actions
- (void) denied {
	if ([_delegate respondsToSelector: @selector(OAuthControllerFailed:)]) 
        [_delegate OAuthControllerFailed: self];
    [self dismissModalViewControllerAnimated:YES];
}

- (void) gotPin: (NSString *) pin {
	_engine.pin = pin;
	[_engine requestAccessToken];
	
	if ([_delegate respondsToSelector: @selector(OAuthController:authenticatedWithUsername:)]) 
        [_delegate OAuthController: self authenticatedWithUsername: _engine.username];
    [self dismissModalViewControllerAnimated:YES];
}

- (void) cancel: (id) sender {
	if ([_delegate respondsToSelector: @selector(OAuthControllerCanceled:)]) 
        [_delegate OAuthControllerCanceled: self];
    [self dismissModalViewControllerAnimated:YES];
}

//=============================================================================================================================
#pragma mark View Controller Stuff
- (void) loadView {
	[super loadView];
	self.view = [[[UIView alloc] initWithFrame: ApplicationFrame(self.orientation)] autorelease];
	_navBar = [[[UINavigationBar alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 44)] autorelease];
	
	_navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	CGRect frame = ApplicationFrame(self.orientation);
	frame.origin.y = 44;
	frame.size.height -= 44;
	_webView = [[UIWebView alloc] initWithFrame: ApplicationFrame(self.orientation)];
	_webView.alpha = 0.0;
	_webView.delegate = self;
	//_webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	if ([_webView respondsToSelector: @selector(setDetectsPhoneNumbers:)]) [(id) _webView setDetectsPhoneNumbers: NO];
	if ([_webView respondsToSelector: @selector(setDataDetectorTypes:)]) [(id) _webView setDataDetectorTypes: 0];
	
	NSURLRequest			*request = _engine.authorizeURLRequest;
	[_webView loadRequest: request];
	
	[self.view addSubview: _webView];
	[self.view addSubview: _navBar];
	
	_blockerView = [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 200, 60)] autorelease];
	_blockerView.backgroundColor = [UIColor colorWithWhite: 0.0 alpha: 0.8];
	_blockerView.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
	_blockerView.alpha = 0.0;
	_blockerView.clipsToBounds = YES;
	if ([_blockerView.layer respondsToSelector: @selector(setCornerRadius:)]) [(id) _blockerView.layer setCornerRadius: 10];
	
	UILabel								*label = [[[UILabel alloc] initWithFrame: CGRectMake(0, 5, _blockerView.bounds.size.width, 15)] autorelease];
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
	
	UINavigationItem				*navItem = [[[UINavigationItem alloc] initWithTitle: NSLocalizedString(@"Sina Weibo Info", nil)] autorelease];
	navItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel target: self action: @selector(cancel:)] autorelease];
	
	[_navBar pushNavigationItem: navItem animated: NO];
	[self locateAuthPinInWebView: nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void) didRotateFromInterfaceOrientation: (UIInterfaceOrientation) fromInterfaceOrientation {
	self.orientation = self.interfaceOrientation;
	NSLog(@"orientation:%d", self.interfaceOrientation);
	CGRect frame = ApplicationFrame(self.orientation);
	frame.origin.y = 44;
	frame.size.height -= 44;
	_webView.frame = frame;
	_blockerView.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
}

//=============================================================================================================================
#pragma mark Notifications
- (void) pasteboardChanged: (NSNotification *) note {
	UIPasteboard					*pb = [UIPasteboard generalPasteboard];
	
	if ([note.userInfo objectForKey: UIPasteboardChangedTypesAddedKey] == nil) return;		//no meaningful change
	
	NSString						*copied = pb.string;
	
	if (copied.length != 6 || !copied.oauth_isNumeric) return;
	
	[self gotPin: copied];
}

//=============================================================================================================================
#pragma mark Webview Delegate stuff
- (void) webViewDidFinishLoad: (UIWebView *) webView {
	NSString					*authPin = [self locateAuthPinInWebView: webView];
	
	if (authPin.length) {
		[self gotPin: authPin];
		return;
	}
	/*
	_loading = NO;
	//[self performInjection];
	if (_firstLoad) {
		//[_webView performSelector: @selector(stringByEvaluatingJavaScriptFromString:) withObject: @"window.scrollBy(0,200)" afterDelay: 0];
		_firstLoad = NO;
	} else {
		NSString					*authPin = [self locateAuthPinInWebView: webView];
		
		if (authPin.length) {
			[self gotPin: authPin];
			return;
		}
		
		NSString					*formCount = [webView stringByEvaluatingJavaScriptFromString: @"document.forms.length"];
		
		if ([formCount isEqualToString: @"0"]) {
			[self showPinCopyPrompt];
		}
	}
	
	*/
	
	[UIView beginAnimations: nil context: nil];
	_blockerView.alpha = 0.0;
	[UIView commitAnimations];
	
	if ([_webView isLoading]) {
		_webView.alpha = 0.0;
	} else {
		_webView.alpha = 1.0;
	}
}

- (void) showPinCopyPrompt {
	if (self.pinCopyPromptBar.superview) return;		//already shown
	self.pinCopyPromptBar.center = CGPointMake(self.pinCopyPromptBar.bounds.size.width / 2, self.pinCopyPromptBar.bounds.size.height / 2);
	[self.view insertSubview: self.pinCopyPromptBar belowSubview: self.navigationBar];
	
	[UIView beginAnimations: nil context: nil];
	self.pinCopyPromptBar.center = CGPointMake(self.pinCopyPromptBar.bounds.size.width / 2, self.navigationBar.bounds.size.height + self.pinCopyPromptBar.bounds.size.height / 2);
	[UIView commitAnimations];
}

/*********************************************************************************************************
 I am fully aware that this code is chock full 'o flunk. That said:
 
 - first we check, using standard DOM-diving, for the pin, looking at both the old and new tags for it.
 - if not found, we try a regex for it. This did not work for me (though it did work in test web pages).
 - if STILL not found, we iterate the entire HTML and look for an all-numeric 'word', 7 characters in length
 
 Ugly. I apologize for its inelegance. Bleah.
 
 *********************************************************************************************************/

- (NSString *) locateAuthPinInWebView: (UIWebView *) webView {
    
    NSString *pin;
	
	NSString			*html = [webView stringByEvaluatingJavaScriptFromString: @"document.body.innerText"];
	NSLog(@"html:%@", [webView stringByEvaluatingJavaScriptFromString: @"document.body.innerHTML"]);
	
	if (html.length == 0) return nil;
	
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
	
	return nil;
}

- (UIToolbar *) pinCopyPromptBar {
	if (_pinCopyPromptBar == nil){
		CGRect					bounds = self.view.bounds;
		
		_pinCopyPromptBar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0, 44, bounds.size.width, 44)] autorelease];
		_pinCopyPromptBar.barStyle = UIBarStyleBlackTranslucent;
		_pinCopyPromptBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		
		_pinCopyPromptBar.items = [NSArray arrayWithObjects: 
								   [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil] autorelease],
								   [[[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"Select and Copy the PIN", @"Select and Copy the PIN") style: UIBarButtonItemStylePlain target: nil action: nil] autorelease], 
								   [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil] autorelease], 
								   nil];
	}
	
	return _pinCopyPromptBar;
}




- (void) webViewDidStartLoad: (UIWebView *) webView {
	//[_activityIndicator startAnimating];
	_loading = YES;
	[UIView beginAnimations: nil context: nil];
	_blockerView.alpha = 1.0;
	[UIView commitAnimations];
}


- (BOOL) webView: (UIWebView *) webView shouldStartLoadWithRequest: (NSURLRequest *) request navigationType: (UIWebViewNavigationType) navigationType {
	NSData				*data = [request HTTPBody];
	char				*raw = data ? (char *) [data bytes] : "";
	
	if (raw && strstr(raw, "cancel=")) {
		[self denied];
		return NO;
	}
	if (navigationType != UIWebViewNavigationTypeOther) _webView.alpha = 0.1;
	return YES;
}


@end
