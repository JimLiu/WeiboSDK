//
//  WeiboConnection.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-20.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "WeiboConnection.h"
#import "StringUtil.h"
#import "WeiboEngine.h"

@implementation WeiboConnection
@synthesize statusCode;
@synthesize requestURL;
@synthesize context;
@synthesize delegate;
@synthesize oAuth;
@synthesize hasError;
@synthesize errorMessage;
@synthesize errorDetail;


- (id)initWithTarget:(id)aDelegate action:(SEL)anAction
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

- (id)initWithTarget:(id)aDelegate action:(SEL)anAction {
    self = [super init];
	if (self) {
		delegate = aDelegate;
		action = anAction;
		statusCode = 0;
		needAuth = YES;
		oAuth = [[WeiboEngine currentAccount].oAuth retain];
	}
	return self;
	
}

- (void)dealloc
{
    [request clearDelegatesAndCancel];
	[request release];
	request = nil;
	delegate = nil;
	[oAuth release];
	[super dealloc];
}

- (NSString *)baseUrl {
	return @"http://api.t.sina.com.cn/";
}


- (void)syncGet:(NSString *)relativeUrl 
queryParameters:(NSMutableDictionary *)params 
processResponseDataAction:(SEL)processAction {
    NSString *baseUrl = [self baseUrl];
    NSString *url = baseUrl ? [NSString stringWithFormat:@"%@%@", baseUrl, relativeUrl] : relativeUrl;
	[self cancel];
	request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[URLHelper getURL:url queryParameters:params]]];
	request.requestMethod = @"GET";
    if (needAuth) {
        NSString *oauth_header = [oAuth oAuthHeaderForMethod:@"GET" andUrl:url andParams:params];
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
    request.validatesSecureCertificate = NO;
	if (needAuth) {
		NSString *oauth_header = [oAuth oAuthHeaderForMethod:@"GET" andUrl:url andParams:params];
        if (oauth_header) {
            NSLog(@"oauth_header: %@", oauth_header);
            [request addRequestHeader:@"Authorization" value:oauth_header];
        }
	}
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(requestFinished:)];
	[request setDidFailSelector:@selector(requestFailed:)];
	[request startAsynchronous];
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
    request.validatesSecureCertificate = NO;
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
}


- (void)cancel
{
    if (request) {
		[request clearDelegatesAndCancel];
		[request release];
		request = nil;
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
    NSString *msg = [dic objectForKey:@"error"];
    if (msg) {
        NSLog(@"Weibo responded with an error: %@", msg);
        int errorCode = 0;//[[dic objectForKey:@"error_code"] intValue];
        NSRange range = [msg rangeOfString:@":"];
        if (range.length == 1 && range.location != NSNotFound) {
            errorCode = [[msg substringToIndex:range.location] intValue];
        }
        hasError = true;
        switch (errorCode) {
            case 40033:
                self.errorMessage = @"用户不存在";
                self.errorDetail  = @"用户没有找到，请检查后重试。";
                break;
            case 40031:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"调用的微博不存在。";
                break;
            case 40036:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"调用的微博不是当前用户发布的微博。";
                break;
            case 40034:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"不能转发自己的微博。";
                break;
            case 40038:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"不合法的微博。";
                break;
            case 40037:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"不合法的评论。";
                break;
            case 40015:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"该条评论不是当前登录用户发布的评论。";
                break;
            case 40017:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"不能给不是你粉丝的人发私信。";
                break;
            case 40019:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"不合法的私信。";
                break;
            case 40021:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"不是属于你的私信。";
                break;
            case 40022:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"source参数(appkey)缺失。";
                break;
            case 40007:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"格式不支持，仅仅支持XML或JSON格式。";
                break;
            case 40009:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"图片错误，请确保使用multipart上传了图片。";
                break;
            case 40011:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"私信发布超过上限。";
                break;
            case 40012:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"内容为空。";
                break;
            case 40016:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"微博id为空。";
                break;
            case 40018:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"ids参数为空。";
                break;
            case 40020:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"评论ID为空。";
                break;
            case 40023:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"用户不存在。";
                break;
            case 40024:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"ids过多，请参考API文档。";
                break;
            case 40025:
                self.errorMessage = @"微博发布失败";
                self.errorDetail  = @"发送失败的微博已保存至草稿箱。不能同时发布两条相同的微博，请修改后重试。";
                break;
            case 40026:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"请传递正确的目标用户uid或者screen name。";
                break;
            case 40045:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"不支持的图片类型,支持的图片类型有JPG,GIF,PNG。";
                break;
            case 40008:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"图片大小错误，上传的图片大小上限为5M。";
                break;
            case 40001:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"参数错误，请参考API文档。";
                break;
            case 40002:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"不是对象所属者，没有操作权限。";
                break;
            case 40010:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"私信不存在。";
                break;
            case 40013:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"微博太长，请确认不超过140个字符。";
                break;
            case 40039:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"地理信息输入错误。";
                break;
            case 40040:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"IP限制，不能请求该资源。";
                break;
            case 40041:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"uid参数为空。";
                break;
            case 40042:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"token参数为空。";
                break;
            case 40043:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"domain参数错误。";
                break;
            case 40044:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"appkey参数缺失。";
                break;
            case 40029:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"verifier错误。";
                break;
            case 40027:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"标签参数为空。";
                break;
            case 40032:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"列表名太长，请确保输入的文本不超过10个字符。";
                break;
            case 40030:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"列表描述太长，请确保输入的文本不超过70个字符。";
                break;
            case 40035:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"列表不存在。";
                break;
            case 40053:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"权限不足，只有创建者有相关权限。";
                break;
            case 40054:
                self.errorMessage = @"系统错误";
                self.errorDetail  = @"参数错误，请参考API文档。";
                break;
            default: 
                self.errorMessage = @"Weibo Server Error";
                self.errorDetail  = msg;
                break;
        }
    }

}

- (void)requestFinished:(ASIHTTPRequest *)_request
{
		
	NSLog(@"response string: %@", [_request responseString]);
	NSData *responseData = [_request responseData];
	
	statusCode = [_request responseStatusCode];
    [request release];
    request = nil;
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
	
	NSError *error = [_request error];
    NSLog(@"error response string: %@", [_request responseString]);
    NSLog(@"_request error!!!, Reason:%@, errordetail:%@"
          , [error localizedFailureReason], [error localizedDescription]);
    
	statusCode = [_request responseStatusCode];
	hasError = true;
	[request release];
    request = nil;
	
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


@end
