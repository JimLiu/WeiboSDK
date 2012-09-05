//
//  WeiboConnection.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-20.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZhiWeiboAppDelegate.h"
#import "WeiboEngine.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "OAuth.h"
#import "RequestFile.h"
#import "URLHelper.h"
#import "CJSONDeserializer.h"

extern NSString *WEIBO_FORM_BOUNDARY;

@interface WeiboConnection : NSObject {
	id                  delegate;
    NSString*           requestURL;
	ASIHTTPRequest *request;
	id context;
    SEL action;
    int                 statusCode;
    BOOL                needAuth;	
    OAuth *oAuth;
    
    BOOL        hasError;
    NSString*   errorMessage;
    NSString*   errorDetail;

}

@property (nonatomic, assign) int statusCode;
@property (nonatomic, copy) NSString* requestURL;
@property (nonatomic, assign) id                  delegate;
@property (nonatomic, assign) id context;
@property (nonatomic, retain) OAuth *oAuth;
@property(nonatomic, assign) BOOL hasError;
@property(nonatomic, copy) NSString* errorMessage;
@property(nonatomic, copy) NSString* errorDetail;


- (id)initWithTarget:(id)aDelegate action:(SEL)anAction;
- (id)initWithTarget:(id)aDelegate action:(SEL)anAction
               oAuth:(OAuth *)_oAuth;
- (void)cancel;

- (void) asyncGet:(NSString *)relativeUrl
          baseUrl:(NSString *)baseUrl
           params:(NSDictionary *)params;

- (void) asyncGet:(NSString *)url
           params:(NSDictionary *)params;

- (void) asyncPost:(NSString *)url
            params:(NSMutableDictionary *)params
         withFiles:(NSArray *)files;

- (void) asyncPost:(NSString *)relativeUrl
           baseUrl:(NSString *)baseUrl
            params:(NSMutableDictionary *)params
         withFiles:(NSArray *)files;
- (void)cancel;


@end
