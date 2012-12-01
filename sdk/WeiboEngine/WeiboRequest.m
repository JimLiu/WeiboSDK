//
//  WeiboRequest.m
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-8-30.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "WeiboRequest.h"
#import "JSONKit.h"
#import "WeiboAccounts.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

NSString *WeiboAPIErrorDomain = @"com.zhiweibo.api";
NSString *kUserAgent = @"ZhiWeibo";
static const int kGeneralErrorCode = 10000;

@interface WeiboRequest ()
@property (nonatomic,readwrite) BOOL sessionDidExpire;
@end

@implementation WeiboRequest
@synthesize delegate = _delegate;
@synthesize error = _error;
@synthesize accessToken = _accessToken;

- (id)init {
    self = [super init];
    if (self) {
        WeiboAccount *account = [[WeiboAccounts shared]currentAccount];
        if (account) {
            self.accessToken = account.accessToken;
        }
    }
    return self;
}

- (id)initWithDelegate:(id<WeiboRequestDelegate>)delegate {
    self = [self init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (id)initWithAccessToken:(NSString *)accessToken delegate:(id<WeiboRequestDelegate>)delegate {
    self = [super init];
    if (self) {
        self.accessToken = accessToken;
        self.delegate = delegate;
    }
    return self;
}

- (void)dealloc {
	[_request clearDelegatesAndCancel];
	_request = nil;
	_delegate = nil;
    [_accessToken release];
	[super dealloc];
}

+ (NSString*)serializeURL:(NSString *)baseUrl
                   params:(NSDictionary *)params {
    
    NSURL* parsedURL = [NSURL URLWithString:baseUrl];
    NSString* queryPrefix = parsedURL.query ? @"&" : @"?";
    
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [params keyEnumerator]) {
        if (([[params objectForKey:key] isKindOfClass:[UIImage class]])
            ||([[params objectForKey:key] isKindOfClass:[NSData class]])) {
            continue;
        }
        
        NSString* escaped_value = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                      NULL, /* allocator */
                                                                                      (CFStringRef)[params objectForKey:key],
                                                                                      NULL, /* charactersToLeaveUnescaped */
                                                                                      (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                      kCFStringEncodingUTF8);
        
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
        [escaped_value release];
    }
    NSString* query = [pairs componentsJoinedByString:@"&"];
    
    return [NSString stringWithFormat:@"%@%@%@", baseUrl, queryPrefix, query];
}

- (id)formError:(NSInteger)code userInfo:(NSDictionary *) errorData {
    return [NSError errorWithDomain:WeiboAPIErrorDomain code:code userInfo:errorData];
    
}

- (id)parseJsonResponse:(NSData *)data error:(NSError **)error {
	NSError *parseError = nil;
    
    JSONDecoder *parser = [JSONDecoder decoder];
    id result = [parser mutableObjectWithData:data error:&parseError];
    
	if (parseError)
    {
        if (error != nil)
        {
            *error = [self formError:kGeneralErrorCode
                            userInfo:parseError.userInfo];
        }
	}
    
	if ([result isKindOfClass:[NSDictionary class]])
	{
		if ([result objectForKey:@"error_code"] != nil && [[result objectForKey:@"error_code"] intValue] != 200)
		{
			if (error != nil)
			{
				*error = [self formError:[[result objectForKey:@"error_code"] intValue] userInfo:result];
			}
		}
	}
	
	return result;    
}

- (void)failWithError:(NSError *)error {
    if (   [error code] == 21301
        || [error code] == 21314
        || [error code] == 21315
        || [error code] == 21316
        || [error code] == 21317
        || [error code] == 21332) {
        self.sessionDidExpire = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"authError"
                                                            object:error];
    }
    if ([_delegate respondsToSelector:@selector(request:didFailWithError:)]) {
        [_delegate request:self didFailWithError:error];
    }
}

- (void)loadSuccess:(id)result {
    if ([_delegate respondsToSelector:@selector(request:didLoad:)]) {
        [_delegate request:self didLoad:result];
    }
}

- (void)handleResponseData:(NSData *)data {
    NSError* error = nil;
    
    id result = [self parseJsonResponse:data error:&error];
    self.error = error;
    
    if ([_delegate respondsToSelector:@selector(request:didLoad:)] ||
        [_delegate respondsToSelector:@selector(request:didFailWithError:)]) {
            
            if (error) {
                [self performSelectorOnMainThread:@selector(failWithError:) withObject:error waitUntilDone:YES];
            }
            else {
                [self performSelectorOnMainThread:@selector(loadSuccess:) withObject:result waitUntilDone:YES];
            }
            
        }

}

- (void)processParams:(NSMutableDictionary *)params {
    if (!params) {
        params = [NSMutableDictionary dictionary];
    }
    if (self.accessToken) {
        [params setObject:self.accessToken forKey:@"access_token"];
    }
}

- (void)getFromPath:(NSString *)apiPath
             params:(NSMutableDictionary *)params {
    NSString * fullURL = [kWeiboAPIBaseUrl stringByAppendingString:apiPath];
    return [self getFromUrl:fullURL params:params];
}

- (void)getFromUrl:(NSString *)url
            params:(NSMutableDictionary *)params {
    [self processParams:params];
    
    NSString* urlString = [[self class] serializeURL:url params:params];
    [_request clearDelegatesAndCancel];
    _request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    [_request setDelegate:self];
    [_request setValidatesSecureCertificate:NO];
    [_request addRequestHeader:@"User-Agent" value:kUserAgent];
    
    [_request startAsynchronous];
}

- (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
}

- (void)postToPath:(NSString *)apiPath
            params:(NSMutableDictionary *)params {
    NSString * fullURL = [kWeiboAPIBaseUrl stringByAppendingString:apiPath];
    return [self postToUrl:fullURL params:params];
}

- (void)postToUrl:(NSString *)url
           params:(NSMutableDictionary *)params {
    [self processParams:params];
    
    [_request clearDelegatesAndCancel];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setValidatesSecureCertificate:NO];
    [request addRequestHeader:@"User-Agent" value:kUserAgent];
    
    for (NSString* key in [params keyEnumerator]) {
        id val = [params objectForKey:key];
        if ([val isKindOfClass:[NSData class]]) {
            NSString *contentType = [self contentTypeForImageData:val];
            if (contentType) {
                [request addData:val withFileName:[contentType stringByReplacingOccurrencesOfString:@"/" withString:@" from zhiweibo."] andContentType:contentType forKey:key];
            }
            else {
                [request addData:val forKey:key];
            }            
        }
        else if ([val isKindOfClass:[UIImage class]]) {
            NSData* imageData = UIImagePNGRepresentation((UIImage*)val);
            [request addData:imageData withFileName:@"image from zhiweibo.png" andContentType:@"image/png" forKey:key];
        }
        else {
            [request addPostValue:val forKey:key];
        }
    }
    
    [request startAsynchronous];
    
    _request = request;
}

- (void)cancel
{
    if (_request) {
		[_request clearDelegatesAndCancel];
		_request = nil;
    }
	
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [self performSelectorInBackground:@selector(handleResponseData:) withObject:[request responseData]];
    _request = nil;    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
    NSLog(@"_request error!!!, Reason:%@, errordetail:%@"
          , [error localizedFailureReason], [error localizedDescription]);
    
    [self failWithError:error];
	
    _request = nil;

}

@end
