//
//  OAuthController.h
//  WeiboPad
//
//  Created by junmin liu on 10-10-5.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalCore.h"

@class OAuthEngine, OAuthController;

@protocol OAuthControllerDelegate <NSObject>
@optional
- (void) OAuthController: (OAuthController *) controller authenticatedWithUsername: (NSString *) username;
- (void) OAuthControllerFailed: (OAuthController *) controller;
- (void) OAuthControllerCanceled: (OAuthController *) controller;
@end

@interface OAuthController : UIViewController <UIWebViewDelegate> {
	
	OAuthEngine						*_engine;
	UIWebView									*_webView;
	UINavigationBar								*_navBar;
	
	id <OAuthControllerDelegate>			_delegate;
	UIView										*_blockerView;
	
	UIInterfaceOrientation                      _orientation;
	BOOL										_loading, _firstLoad;
	UIToolbar									*_pinCopyPromptBar;
	
}

@property (nonatomic, readwrite, retain) OAuthEngine *engine;
@property (nonatomic, readwrite, assign) id <OAuthControllerDelegate> delegate;
@property (nonatomic, readonly) UINavigationBar *navigationBar;

+ (OAuthController *) controllerToEnterCredentialsWithEngine: (OAuthEngine *) engine 
													delegate: (id <OAuthControllerDelegate>) delegate;
+ (BOOL) credentialEntryRequiredWithEngine: (OAuthEngine *) engine;



@end
