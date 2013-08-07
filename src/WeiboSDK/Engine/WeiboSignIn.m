//
//  WeiboSignIn.m
//  WeiboSDK
//
//  Created by Liu Jim on 8/4/13.
//  Copyright (c) 2013 openlab. All rights reserved.
//

#import "WeiboSignIn.h"

NSString *const WeiboOAuth2ErrorDomain = @"com.openlab.weiboSDK.OAuth2";

@interface WeiboSignIn ()

@property (nonatomic, strong) WeiboAuthentication *authentication;
@property (nonatomic, copy) WeiboSignedInBlock signedInBlock;


@end

@implementation WeiboSignIn {
    WeiboLoginDialog *_loginDialog;
    WeiboRequestOperation *_requestOperation;
}


- (id)initWithWeiboAuthentication:(WeiboAuthentication *)authentication
                        withBlock:(WeiboSignedInBlock)signedInBlock {
    self = [super init];
    if (self) {
        self.authentication = authentication;
        self.signedInBlock = signedInBlock;
    }
    return self;
}

- (void)cancel {
    if (_requestOperation) {
        [_requestOperation cancel];
        _requestOperation = nil;
    }
    if (_loginDialog) {
        [_loginDialog dismissWithSuccess:NO animated:NO];
        _loginDialog = nil;
    }    
}

- (void)signIn {
    NSURL *url = [NSURL URLWithString:self.authentication.authorizeRequestUrl];
    _loginDialog = [[WeiboLoginDialog alloc] initWithURL:url delegate:self];
    [_loginDialog show];
}

- (void)dialogLogin:(NSString*)code {
    _loginDialog = nil; // 
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.authentication.appKey forKey:@"client_id"];
    [params setObject:self.authentication.appSecret forKey:@"client_secret"];
    [params setObject:self.authentication.redirectURI forKey:@"redirect_uri"];
    [params setObject:code forKey:@"code"];
    [params setObject:@"authorization_code" forKey:@"grant_type"];
    
    _requestOperation = [[WeiboRequest shared]
                         postToUrl:self.authentication.accessTokenURL params:params
                           completed:^(id result, NSData *data, NSError *error) {
       _requestOperation = nil;
       if (error) {
           self.signedInBlock(nil, error);
           return ;
       }
                               
       if ([result isKindOfClass:[NSDictionary class]])
       {
           NSDictionary *dict = (NSDictionary *)result;
           
           NSString *accessToken = [dict objectForKey:@"access_token"];
           NSString *userId = [dict objectForKey:@"uid"];
           int expiresIn = [[dict objectForKey:@"expires_in"] intValue];
           
           if (accessToken.length > 0 && userId.length > 0) {
               self.authentication.accessToken = accessToken;
               self.authentication.userId = userId;
               self.authentication.expirationDate = [NSDate dateWithTimeIntervalSinceNow:expiresIn];
               self.signedInBlock(self.authentication, nil);
               return;
           }
       }
       NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
       
       NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSString stringWithFormat:@"Failed to parse response data: \r\n%@",responseString],NSLocalizedDescriptionKey,
                                 nil];
       self.signedInBlock(nil, [NSError errorWithDomain:WeiboOAuth2ErrorDomain code:kWeiboOAuth2ErrorTokenUnavailable userInfo:userInfo]);
    }];
}

- (void)dialogNotLogin:(BOOL)cancelled {
    _loginDialog = nil; //

    NSLog(@"dialogNotLogin");
    NSString *msg = cancelled ? @"User cancelled the login dialog" : @"The login dialog did not response the right code.";
    self.signedInBlock(nil, [NSError errorWithDomain:WeiboOAuth2ErrorDomain code:kWeiboOAuth2ErrorDialogNotLogin userInfo:@{NSLocalizedDescriptionKey: msg}]);
}

@end
