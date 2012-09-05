//
//  WeiboEngine.m
//  SinaWeiboXAuthDemo
//
//  Created by junmin liu on 11-5-26.
//  Copyright 2011年 Openlab. All rights reserved.
//

#import "WeiboEngine.h"

static WeiboEngine *gEngine;

@implementation WeiboEngine
@synthesize oAuth = _oAuth;
@synthesize user = _user;


+ (WeiboEngine *)engine {
    if (!gEngine) {
        gEngine = [[WeiboEngine alloc]init];
    }
    return gEngine;
}

- (BOOL)isAuthorized {
    return _oAuth.oauth_token_authorized;
}

@end
