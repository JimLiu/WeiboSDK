//
//  WeiboAuthorize.m
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-8-26.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "WeiboAuthentication.h"



@implementation WeiboAuthentication
@synthesize appKey = _appKey;
@synthesize appSecret = _appSecret;
@synthesize redirectURI = _redirectURI;

@synthesize authorizeURL = _authorizeURL;
@synthesize accessTokenURL = _accessTokenURL;

@synthesize accessToken = _accessToken;
@synthesize userId = _userId;
@synthesize expirationDate = _expirationDate;

- (id)initWithAuthorizeURL:(NSString *)authorizeURL accessTokenURL:(NSString *)accessTokenURL
                    AppKey:(NSString *)appKey appSecret:(NSString *)appSecret {
    self = [super init];
    if (self) {
        self.authorizeURL = authorizeURL;
        self.accessTokenURL = accessTokenURL;
        self.appKey = appKey;
        self.appSecret = appSecret;
        self.redirectURI = @"http://";
    }
    return self;
}

- (void)dealloc
{
    [_appKey release];
    [_appSecret release];
    [_redirectURI release];
    
    [_authorizeURL release];
    [_accessTokenURL release];
    
    [_accessToken release];
    [_userId release];
    [_expirationDate release];
    
    [super dealloc];
}

- (NSString *)authorizeRequestUrl {
    return [NSString stringWithFormat:@"%@?client_id=%@&response_type=code&redirect_uri=%@&display=mobile", self.authorizeURL,
            [self.appKey stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
            [self.redirectURI stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

@end
