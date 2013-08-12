//
//  WeiboRequest.m
//  WeiboSDK
//
//  Created by Liu Jim on 8/4/13.
//  Copyright (c) 2013 openlab. All rights reserved.
//

#import "WeiboRequest.h"
#import "URLRequestHelper.h"
#import "WeiboAccounts.h"

@interface WeiboRequest ()

@property (nonatomic, strong) NSOperationQueue *requestQueue;
@property (nonatomic, weak) NSOperation *lastAddedOperation;

@property (nonatomic, strong) dispatch_queue_t workingQueue;
@property (nonatomic, strong) dispatch_queue_t barrierQueue;

@end


@implementation WeiboRequest


+ (WeiboRequest *)shared
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{instance = self.new;});
    return instance;
}

- (id)init
{
    if ((self = [super init]))
    {
        _requestQueue = NSOperationQueue.new;
        _requestQueue.maxConcurrentOperationCount = 4;
        _workingQueue = dispatch_queue_create("com.openlab.weiboSDK.weiboRequest", DISPATCH_QUEUE_SERIAL);
        _barrierQueue = dispatch_queue_create("com.openlab.weiboSDK.weiboRequestBarrierQueue", DISPATCH_QUEUE_CONCURRENT);
        if ([[WeiboAccounts shared] currentAccount]) { // Get current users's access token;
            self.accessToken = [[WeiboAccounts shared]currentAccount].accessToken;
        }
    }
    return self;
}

- (void)dealloc
{
    [self.requestQueue cancelAllOperations];
}

- (void)setMaxConcurrentDownloads:(NSInteger)maxConcurrentDownloads
{
    _requestQueue.maxConcurrentOperationCount = maxConcurrentDownloads;
}

- (NSInteger)maxConcurrentDownloads
{
    return _requestQueue.maxConcurrentOperationCount;
}

- (WeiboRequestOperation*)requestWithURLRequest:(NSURLRequest *)request
                                      completed:(WeiboRequestCompletedBlock)completedBlock
{
    __block WeiboRequestOperation *operation;
    __weak WeiboRequest *wself = self;
    dispatch_barrier_sync(self.barrierQueue, ^{
        operation = [WeiboRequestOperation.alloc
                        initWithRequest:request
                                    queue:wself.workingQueue
                                completed:^(id result, NSData *data, NSError *error)
                     {
                         if (!wself)
                             return;
                         if (completedBlock)
                             completedBlock(result, data, error);
                     }
                     cancelled:^
                     {
                         if (!wself)
                             return;
                     }];
        [wself.requestQueue addOperation:operation];
        //LIFO
        [wself.lastAddedOperation addDependency:operation];
        wself.lastAddedOperation = operation;
        
    });    
    return operation;
}

- (NSDictionary *)processParams:(NSDictionary *)params {
    NSMutableDictionary *dic = params ? [NSMutableDictionary dictionaryWithDictionary:params] : [NSMutableDictionary dictionary];
    if (![dic objectForKey:@"access_token"] && self.accessToken) {
        [dic setObject:self.accessToken forKey:@"access_token"];
    }
    return dic;
}

- (WeiboRequestOperation*)getFromUrl:(NSString *)url
                              params:(NSDictionary *)params
                           completed:(WeiboRequestCompletedBlock)completedBlock {
    NSDictionary *processedParams = [self processParams:params];
    NSURLRequest *request = [URLRequestHelper getRequestWithUrl:url params:processedParams];
    return [self requestWithURLRequest:request completed:completedBlock];
}

- (WeiboRequestOperation*)postToUrl:(NSString *)url
                             params:(NSDictionary *)params
                          completed:(WeiboRequestCompletedBlock)completedBlock {
    NSDictionary *processedParams = [self processParams:params];
    NSURLRequest *request = [URLRequestHelper postRequestWithUrl:url params:processedParams];
    return [self requestWithURLRequest:request completed:completedBlock];    
}

- (WeiboRequestOperation*)getFromPath:(NSString *)apiPath
                               params:(NSDictionary *)params
                            completed:(WeiboRequestCompletedBlock)completedBlock {
    NSString * fullURL = [kWeiboAPIBaseUrl stringByAppendingString:apiPath];
    return [self getFromUrl:fullURL params:params completed:completedBlock];    
}

- (WeiboRequestOperation*)postToPath:(NSString *)apiPath
                              params:(NSDictionary *)params
                           completed:(WeiboRequestCompletedBlock)completedBlock {
    NSString * fullURL = [apiPath hasSuffix:@"upload.json"] ? [kWeiboUploadAPIBaseUrl stringByAppendingString:apiPath] : [kWeiboAPIBaseUrl stringByAppendingString:apiPath];
    return [self postToUrl:fullURL params:params completed:completedBlock];
}

@end
