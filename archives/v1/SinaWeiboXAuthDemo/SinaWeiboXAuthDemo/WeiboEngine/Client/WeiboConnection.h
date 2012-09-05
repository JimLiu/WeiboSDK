//
//  WeiboConnection.h
//  Zhiweibo2
//
//  Created by junmin liu on 11-2-21.
//  Copyright 2011 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuth.h"
#import "ASIHTTPRequest.h"
#import "ApplicationHelper.h"
#import "CJSONDeserializer.h"
#import "URLHelper.h"
#import "ASIFormDataRequest.h"
#import "RequestFile.h"

@interface WeiboConnection : NSObject {
	ASIHTTPRequest *request;
	int statusCode;
	BOOL needAuth;	
	id delegate;
	id context;
    SEL action;
	OAuth *oAuth;


	BOOL        hasError;
    NSString*   errorMessage;
    NSString*   errorDetail;
	
}


- (id)initWithDelegate:(id)aDelegate action:(SEL)anAction;
- (id)initWithDelegate:(id)aDelegate action:(SEL)anAction
				 oAuth:(OAuth *)_oAuth;

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) id context;
@property (nonatomic, retain) OAuth *oAuth;
@property (nonatomic, assign) int statusCode;
@property(nonatomic, assign) BOOL hasError;
@property(nonatomic, copy) NSString* errorMessage;
@property(nonatomic, copy) NSString* errorDetail;

- (NSString *)baseUrl;

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



- (void)verifyCredentials;


@end
