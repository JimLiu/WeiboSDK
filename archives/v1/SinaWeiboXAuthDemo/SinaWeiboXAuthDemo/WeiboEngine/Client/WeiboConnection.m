//
//  WeiboConnection.m
//  Zhiweibo2
//
//  Created by junmin liu on 11-2-21.
//  Copyright 2011 Openlab. All rights reserved.
//

#import "WeiboConnection.h"
#import "WeiboEngine.h"

@implementation WeiboConnection
@synthesize delegate;
@synthesize oAuth;
@synthesize context;
@synthesize statusCode;
@synthesize hasError;
@synthesize errorMessage;
@synthesize errorDetail;

- (id)initWithDelegate:(id)aDelegate action:(SEL)anAction
				 oAuth:(OAuth *)_oAuth
{
    self = [super init];
	if (self) {
		delegate = aDelegate;
		action = anAction;
		statusCode = 0;
		needAuth = YES;
		oAuth = [_oAuth retain];
	}
	return self;
}

- (id)initWithDelegate:(id)aDelegate action:(SEL)anAction {
    self = [super init];
	if (self) {
		delegate = aDelegate;
		action = anAction;
		statusCode = 0;
		needAuth = YES;
		oAuth = [[WeiboEngine engine].oAuth retain];
	}
	return self;
	
}

- (void)dealloc {
	[request clearDelegatesAndCancel];
	[request release];
	request = nil;
	[errorMessage release];
    [errorDetail release];
	delegate = nil;
	[oAuth release];
	[super dealloc];
}




- (NSString *)baseUrl {
	return nil;
}

- (void)syncGet:(NSString *)relativeUrl 
     queryParameters:(NSMutableDictionary *)params 
processResponseDataAction:(SEL)processAction {
    NSString *baseUrl = [self baseUrl];
    NSString *url = baseUrl ? [NSString stringWithFormat:@"%@%@", baseUrl, relativeUrl] : relativeUrl;
	[self cancel];
 	[ApplicationHelper increaseNetworkActivityIndicator];
	request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[URLHelper getURL:url queryParameters:params]]];
	request.requestMethod = @"GET";
    if (needAuth) {
        NSString *oauth_header = [[WeiboEngine engine].oAuth oAuthHeaderForMethod:@"GET" andUrl:url andParams:params];
        [request addRequestHeader:@"Authorization" value:oauth_header];
    }
	[request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSData *responseData = [request responseData];
        NSLog(@"responst text: %@", [request responseString]);
        NSObject *obj = [[CJSONDeserializer deserializer] deserialize:responseData
                                                                error:nil];
        [self performSelector:processAction withObject:obj withObject:nil]; 
    }
    else {
        NSLog(@"error message: %@", [error description]);
        // error;
    }
    
    [ApplicationHelper decreaseNetworkActivityIndicator];
    
}


- (void) asyncGet:(NSString *)url
	  params:(NSDictionary *)params {

	NSString *baseUrl = [self baseUrl];
	return [self asyncGet:url baseUrl:baseUrl params:params];
	
}

- (void) asyncGet:(NSString *)relativeUrl
	 baseUrl:(NSString *)baseUrl
	  params:(NSMutableDictionary *)params {
	
	
	NSString *url = baseUrl ? [NSString stringWithFormat:@"%@%@", baseUrl, relativeUrl] : relativeUrl;

	[self cancel];
	request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[URLHelper getURL:url queryParameters:params]]];
	request.requestMethod = @"GET";
	if (needAuth) {
		NSString *oauth_header = [oAuth oAuthHeaderForMethod:@"GET" andUrl:url andParams:params];
        //NSLog(@"oauth_header: %@", oauth_header);
		[request addRequestHeader:@"Authorization" value:oauth_header];
	}
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(requestFinished:)];
	[request setDidFailSelector:@selector(requestFailed:)];
	[request startAsynchronous];
	[ApplicationHelper increaseNetworkActivityIndicator];
}


- (void) asyncPost:(NSString *)url
           params:(NSMutableDictionary *)params 
         withFiles:(NSArray *)files {
    
	NSString *baseUrl = [self baseUrl];
	return [self asyncPost:url baseUrl:baseUrl params:params withFiles:files];
}

- (void) asyncPost:(NSString *)relativeUrl
          baseUrl:(NSString *)baseUrl
           params:(NSMutableDictionary *)params 
         withFiles:(NSArray *)files {
	
	
	NSString *url = baseUrl ? [NSString stringWithFormat:@"%@%@", baseUrl, relativeUrl] : relativeUrl;
    
	[self cancel];
	request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[URLHelper getURL:url queryParameters:nil]]];
	request.requestMethod = @"POST";
    for (NSString *key in [params allKeys]) {
        [(ASIFormDataRequest *)request setPostValue:[params objectForKey:key] forKey:key];
    }
    if (files) {
        for (RequestFile *file in files) {
            if (file && file.data) {
                [(ASIFormDataRequest *)request setData:file.data 
                    withFileName:file.filename 
                  andContentType:file.contentType 
                          forKey:file.key];
            }
        }
    }

	if (needAuth) {
		NSString *oauth_header = [oAuth oAuthHeaderForMethod:@"POST" andUrl:url andParams:params];
        NSLog(@"oauth_header: %@", oauth_header);
		[request addRequestHeader:@"Authorization" value:oauth_header];
	}
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(requestFinished:)];
	[request setDidFailSelector:@selector(requestFailed:)];
	[request startAsynchronous];
	[ApplicationHelper increaseNetworkActivityIndicator];
}


- (void)cancel
{
    if (request) {
		[request clearDelegatesAndCancel];
		[request release];
		request = nil;
		[ApplicationHelper decreaseNetworkActivityIndicator];
    }
	
}


- (void)authError
{
	hasError = YES;
    self.errorMessage = @"身份验证失败";
    self.errorDetail  = @"帐号或密码输入错误，请您确认是否输入正确.";    
	if (delegate) {
		[delegate performSelector:action withObject:self withObject:nil];
	}
	//[[ZhiWeiboAppDelegate getAppDelegate] openAuthenticateView];
}

- (void)processError:(NSDictionary *)dic {
}

- (void)requestFinished:(ASIHTTPRequest *)_request
{
	/*
	[request clearDelegatesAndCancel];
	[request release];
	request = nil;	
	 */
	
	[ApplicationHelper decreaseNetworkActivityIndicator];
	
	//NSString *responseString = [request responseString];
	NSLog(@"response string: %@", [_request responseString]);
	
	statusCode = [_request responseStatusCode];
	switch (statusCode) {
        case 401: // Not Authorized: either you need to provide authentication credentials, or the credentials provided aren't valid.
			hasError = true;
            [self authError];
            //goto out;
			return;
        case 403: // Forbidden: we understand your request, but are refusing to fulfill it.  An accompanying error message should explain why.
        case 40302:
			hasError = true;
            [self authError];
            break;            
        case 304: // Not Modified: there was no new data to return.
			if (delegate) {
				[delegate performSelector:action withObject:self withObject:nil];
			}
			return;
            
        case 400: // Bad Request: your request is invalid, and we'll return an error message that tells you why. This is the status code returned if you've exceeded the rate limit
        case 200: // OK: everything went awesome.
            break;
			
        case 404: // Not Found: either you're requesting an invalid URI or the resource in question doesn't exist (ex: no such user). 
        case 500: // Internal Server Error: we did something wrong.  Please post to the group about it and the Weibo team will investigate.
        case 502: // Bad Gateway: returned if Weibo is down or being upgraded.
        case 503: // Service Unavailable: the Weibo servers are up, but are overloaded with requests.  Try again later.
        default:
        {
            hasError = true;
            self.errorMessage = @"Server responded with an error";
            self.errorDetail  = [NSHTTPURLResponse localizedStringForStatusCode:statusCode];
			if (delegate) {
				[delegate performSelector:action withObject:self withObject:nil];
			}
			return;
        }
    }
	
	NSData *responseData = [_request responseData];
	
	NSObject *obj = [[CJSONDeserializer deserializer] deserialize:responseData
															error:nil];
	
	if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary* dic = (NSDictionary*)obj;
		[self processError:dic];
	}
	
	if (delegate) {
		[delegate performSelector:action withObject:self withObject:obj];
	}
	
}

- (void)requestFailed:(ASIHTTPRequest *)_request
{
	[ApplicationHelper decreaseNetworkActivityIndicator];
	
	NSError *error = [_request error];
    NSLog(@"_request error!!!, Reason:%@, errordetail:%@"
          , [error localizedFailureReason], [error localizedDescription]);

	statusCode = [_request responseStatusCode];
	hasError = true;
	
	/*
	[request clearDelegatesAndCancel];
	[request release];
	request = nil;	
	 */
	
    if (error.code ==  NSURLErrorUserCancelledAuthentication) {
        statusCode = 401;
        [self authError];
    }
    else {
        self.errorMessage = @"网络连接失败";
        self.errorDetail  = [error localizedDescription];
        [delegate performSelector:action withObject:self withObject:nil];
    }
	
}

#pragma mark -
#pragma mark public methods

- (void)verifyCredentials {
}

@end
