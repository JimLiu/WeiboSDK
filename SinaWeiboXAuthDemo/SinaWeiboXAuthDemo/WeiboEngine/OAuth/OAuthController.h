//
//  OAuthController.h
//  Zhiweibo2
//
//  Created by junmin liu on 11-2-15.
//  Copyright 2011 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuth.h"
#import "OAuthCallbacks.h"
#import "ApplicationHelper.h"
#import "RegexKitLite.h"

#import "WeiboEngine.h"
#import "WeiboConnection.h"
#import "User.h"
#import "GlobalCore.h"

@class OAuthController;

@protocol OAuthControllerDelegate <NSObject>
@optional
- (void) OAuthController: (OAuthController *) controller authenticatedWithUsername: (NSString *) username;
- (void) OAuthControllerFailed: (OAuthController *) controller;
- (void) OAuthControllerCanceled: (OAuthController *) controller;
@end

@interface OAuthController : UIViewController<OAuthCallbacks, UIWebViewDelegate> {
	UIWebView *webView;
	UIView	*_blockerView;
	UIActivityIndicatorView *activityIndicatorView;
	UIBarButtonItem *activityItem;
	UIBarButtonItem *refreshItem;
	
	NSOperationQueue *queue;

	OAuth *oAuth;
	id <OAuthControllerDelegate>			_delegate;
}

@property (nonatomic, retain) OAuth *oAuth;
@property (nonatomic, assign) id <OAuthControllerDelegate> delegate;

- (void)getPin;

@end
