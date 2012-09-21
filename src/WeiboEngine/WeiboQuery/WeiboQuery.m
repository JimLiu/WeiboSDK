//
//  WeiboQuery.m
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-8-31.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "WeiboQuery.h"

static NSMutableArray *_queries;

@implementation WeiboQuery

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (NSMutableArray *)queries {
    if (!_queries) {
        _queries = [[NSMutableArray alloc]init];
    }
    return _queries;
}

+ (void)addQuery:(WeiboQuery *)query {
    NSMutableArray *queries = [[self class] queries];
    if (![queries containsObject:query]) {
        [queries addObject:query];
    }    
}

+ (void)removeQuery:(WeiboQuery *)query {
    [[[self class] queries] removeObject:query];
}

- (void)dealloc {
    [_request cancel];
    [_request release];
    _request = nil;
    [super dealloc];
}

- (void)clearRequest {
    [_request release];
    _request = nil;
    [[self class] removeQuery:self];
}

- (void)cancel {
    [_request cancel];
    [self clearRequest];
}

- (void)initRequest {
    if (_request) {
        [self cancel];
    }
    _request = [[WeiboRequest alloc]initWithDelegate:self];
    [[self class]addQuery:self];
}

- (void)getWithAPIPath:(NSString *)apiPath
                params:(NSMutableDictionary *)params {
    [self initRequest];
    [_request getFromPath:apiPath params:params];
}

- (void)postWithAPIPath:(NSString *)apiPath
                params:(NSMutableDictionary *)params {
    [self initRequest];
    [_request postToPath:apiPath params:params];
}

- (void)requestFailedWithError:(NSError *)error {
    
}

- (void)requestFinishedWithObject:(id)object {
    
}

- (void)request:(WeiboRequest *)request didFailWithError:(NSError *)error {
    [self performSelectorOnMainThread:@selector(requestFailedWithError:) withObject:error waitUntilDone:YES];
    [self clearRequest];
}

- (void)request:(WeiboRequest *)request didLoad:(id)result {
    [self performSelectorOnMainThread:@selector(requestFinishedWithObject:) withObject:result waitUntilDone:YES];
    [self clearRequest];
}


@end
