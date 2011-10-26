//
//  OAuthCallbacks.h
//  Zhiweibo2
//
//  Created by junmin liu on 11-2-14.
//  Copyright 2011 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OAuth;

@protocol OAuthCallbacks <NSObject>

- (void) requestTokenDidSucceed:(OAuth *)oAuth;
- (void) requestTokenDidFail:(OAuth *)oAuth;
- (void) authorizeTokenDidSucceed:(OAuth *)oAuth;
- (void) authorizeTokenDidFail:(OAuth *)oAuth;

@end
