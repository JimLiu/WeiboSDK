//
//  WeiboRequest.h
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-8-30.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboConfig.h"

@class WeiboRequest;
@class ASIHTTPRequest;

@protocol WeiboRequestDelegate <NSObject>

@optional
- (void)request:(WeiboRequest *)request didFailWithError:(NSError *)error;
- (void)request:(WeiboRequest *)request didLoad:(id)result;

@end

@interface WeiboRequest : NSObject {
    ASIHTTPRequest *_request;
    
    id<WeiboRequestDelegate> _delegate;
    
    NSError*              _error;
    BOOL                  _sessionDidExpire;
    NSString *_accessToken;
}

- (id)initWithDelegate:(id<WeiboRequestDelegate>)delegate;

- (id)initWithAccessToken:(NSString *)accessToken delegate:(id<WeiboRequestDelegate>)delegate;

@property(nonatomic,assign) id<WeiboRequestDelegate> delegate;
@property(nonatomic,retain) NSError* error;
@property(nonatomic,readonly) BOOL sessionDidExpire;
@property (nonatomic, copy) NSString *accessToken;


- (void)cancel;

- (void)getFromUrl:(NSString *)url
            params:(NSMutableDictionary *)params;
- (void)postToUrl:(NSString *)url
           params:(NSMutableDictionary *)params;
- (void)getFromPath:(NSString *)apiPath
             params:(NSMutableDictionary *)params;
- (void)postToPath:(NSString *)apiPath
            params:(NSMutableDictionary *)params;
@end
