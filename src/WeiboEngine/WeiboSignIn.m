//
//  WeiboSignIn.m
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-8-29.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "WeiboSignIn.h"
#import "WeiboSignInViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"

NSString *WeiboOAuth2ErrorDomain = @"com.zhiweibo.OAuth2";

@interface WeiboSignIn()

- (void)accessTokenWithAuthorizeCode:(NSString *)code;

@end

@implementation WeiboSignIn
@synthesize authentication = _authentication;
@synthesize delegate = _delegate;

- (void)dealloc {
    [_authentication release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {        
        self.authentication = [[[WeiboAuthentication alloc]initWithAuthorizeURL:kWeiboAuthorizeURL accessTokenURL:kWeiboAccessTokenURL AppKey:kAppKey appSecret:kAppSecret] autorelease];
        
    }
    return self;
}

- (void)signInOnViewController:(UIViewController *)viewController {
    WeiboSignInViewController *signInWeiboController = [[WeiboSignInViewController alloc]initWithNibName:nil bundle:nil];
    signInWeiboController.delegate = self;
    signInWeiboController.authentication = self.authentication;
    UINavigationController *navController = [[[UINavigationController alloc]initWithRootViewController:signInWeiboController] autorelease];
    [signInWeiboController release];
    [viewController presentViewController:navController animated:YES completion:NULL];
}


- (void)didReceiveAuthorizeCode:(NSString *)code
{
    // if not canceled
    if (![code isEqualToString:@"21330"])
    {
        [self accessTokenWithAuthorizeCode:code];
    }
    else {        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"Access denied", NSLocalizedDescriptionKey,
                                  nil];
        NSError *error = [NSError errorWithDomain:WeiboOAuth2ErrorDomain
                                             code:kWeiboOAuth2ErrorAccessDenied
                                         userInfo:userInfo];
        if (_delegate) {
            [_delegate finishedWithAuth:self.authentication error:error];
        }
    }
}

- (void)accessTokenWithAuthorizeCode:(NSString *)code
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:self.authentication.accessTokenURL]];
    [request addPostValue:self.authentication.appKey forKey:@"client_id"];
    [request addPostValue:self.authentication.appSecret forKey:@"client_secret"];
    [request addPostValue:self.authentication.redirectURI forKey:@"redirect_uri"];
    [request addPostValue:code forKey:@"code"];
    [request addPostValue:@"authorization_code" forKey:@"grant_type"];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    JSONDecoder *decoder = [JSONDecoder decoder];
    id jsonObject = [decoder mutableObjectWithData:[request responseData]];
    if ([jsonObject isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary *)jsonObject;
        
        NSString *accessToken = [dict objectForKey:@"access_token"];
        NSString *userId = [dict objectForKey:@"uid"];
        int expiresIn = [[dict objectForKey:@"expires_in"] intValue];
        
        if (accessToken.length > 0 && userId.length > 0) {
            self.authentication.accessToken = accessToken;
            self.authentication.userId = userId;
            self.authentication.expirationDate = [NSDate dateWithTimeIntervalSinceNow:expiresIn];
            
            if (_delegate) {
                [_delegate finishedWithAuth:self.authentication error:nil];
            }
            return;
        }
    }
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSString stringWithFormat:@"Failed to parse response data: \r\n%@",[request responseString]],NSLocalizedDescriptionKey,
                              nil];
    NSError *error = [NSError errorWithDomain:WeiboOAuth2ErrorDomain
                                         code:kWeiboOAuth2ErrorTokenUnavailable
                                     userInfo:userInfo];
    if (_delegate) {
        [_delegate finishedWithAuth:self.authentication error:error];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSDictionary *userInfo = [request error].userInfo;
    NSError *error = [NSError errorWithDomain:WeiboOAuth2ErrorDomain
                                         code:kWeiboOAuth2ErrorAccessTokenRequestFailed
                                     userInfo:userInfo];
    if (_delegate) {
        [_delegate finishedWithAuth:self.authentication error:error];
    }
}

@end
