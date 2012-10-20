//
//  WeiboAuthorize.h
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-8-26.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiboAuthentication : NSObject {
    NSString    *_appKey;
    NSString    *_appSecret;
    NSString    *_redirectURI;
    
    NSString *_authorizeURL;
    NSString *_accessTokenURL;
    
    NSString *_accessToken;
    NSString *_userId;
    NSDate *_expirationDate;
}

- (id)initWithAuthorizeURL:(NSString *)authorizeURL accessTokenURL:(NSString *)accessTokenURL
                    AppKey:(NSString *)appKey appSecret:(NSString *)appSecret;

@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, copy) NSString *appSecret;
@property (nonatomic, copy) NSString *redirectURI;

@property (nonatomic, copy) NSString *authorizeURL;
@property (nonatomic, copy) NSString *accessTokenURL;

@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, retain) NSDate *expirationDate;

- (NSString *)authorizeRequestUrl;

@end
