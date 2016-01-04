//
//  WeiboAuthentication.m
//  WeiboSDK
//
//  Created by Liu Jim on 8/3/13.
//  Copyright (c) 2013 openlab. All rights reserved.
//

#import "WeiboAuthentication.h"

@implementation WeiboAuthentication


- (id)initWithAuthorizeURL:(NSString *)authorizeURL
            accessTokenURL:(NSString *)accessTokenURL
                    appKey:(NSString *)appKey
                 appSecret:(NSString *)appSecret
              redirectURI:(NSString *)redirectURI {
    self = [super init];
    if (self) {
        self.authorizeURL = authorizeURL;
        self.accessTokenURL = accessTokenURL;
        self.appKey = appKey;
        self.appSecret = appSecret;
        self.redirectURI = redirectURI;
    }
    return self;
}

- (NSString *)authorizeRequestUrl {
    return [NSString stringWithFormat:@"%@?client_id=%@&response_type=code&redirect_uri=%@&display=mobile", self.authorizeURL,
            [self.appKey stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
            [self.redirectURI stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

@end
