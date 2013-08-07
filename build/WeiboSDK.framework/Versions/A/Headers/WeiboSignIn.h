//
//  WeiboSignIn.h
//  WeiboSDK
//
//  Created by Liu Jim on 8/4/13.
//  Copyright (c) 2013 openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WeiboConfig.h"
#import "WeiboAuthentication.h"
#import "WeiboLoginDialog.h"
#import "WeiboRequest.h"


enum {
    kWeiboOAuth2ErrorWindowClosed          = -1000,
    kWeiboOAuth2ErrorAuthorizationFailed   = -1001,
    kWeiboOAuth2ErrorTokenExpired          = -1002,
    kWeiboOAuth2ErrorTokenUnavailable      = -1003,
    kWeiboOAuth2ErrorUnauthorizableRequest = -1004,
    kWeiboOAuth2ErrorAccessTokenRequestFailed = -1005,
    kWeiboOAuth2ErrorAccessDenied = -1006,
    kWeiboOAuth2ErrorDialogNotLogin = -1007,
};


typedef void(^WeiboSignedInBlock)(WeiboAuthentication *auth, NSError *error);

@interface WeiboSignIn : NSObject<WeiboLoginDialogDelegate>

- (id)initWithWeiboAuthentication:(WeiboAuthentication *)authentication
                        withBlock:(WeiboSignedInBlock)signedInBlock;


- (void)signIn;
- (void)cancel;

@end

