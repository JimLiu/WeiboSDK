//
//  WeiboSignIn.h
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-8-29.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WeiboConfig.h"
#import "WeiboAuthentication.h"

@protocol WeiboSignInDelegate

- (void)finishedWithAuth:(WeiboAuthentication *)auth error:(NSError *)error;

@end


enum {
    kWeiboOAuth2ErrorWindowClosed          = -1000,
    kWeiboOAuth2ErrorAuthorizationFailed   = -1001,
    kWeiboOAuth2ErrorTokenExpired          = -1002,
    kWeiboOAuth2ErrorTokenUnavailable      = -1003,
    kWeiboOAuth2ErrorUnauthorizableRequest = -1004,
    kWeiboOAuth2ErrorAccessTokenRequestFailed = -1005,
    kWeiboOAuth2ErrorAccessDenied = -1006,
};

@interface WeiboSignIn : NSObject {
    WeiboAuthentication *_authentication;
    id<WeiboSignInDelegate> _delegate;
}

@property (nonatomic, retain) WeiboAuthentication *authentication;
@property (nonatomic, assign) id<WeiboSignInDelegate> delegate;

- (void)signInOnViewController:(UIViewController *)viewController;

@end
