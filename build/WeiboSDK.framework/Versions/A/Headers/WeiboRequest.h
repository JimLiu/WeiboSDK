//
//  WeiboRequest.h
//  WeiboSDK
//
//  Created by Liu Jim on 8/4/13.
//  Copyright (c) 2013 openlab. All rights reserved.
//
// 参考代码：SDWebImageDownloader

#import <Foundation/Foundation.h>
#import "WeiboRequestOperation.h"
#import "WeiboConfig.h"

@interface WeiboRequest : NSObject

@property (assign, nonatomic) NSInteger maxConcurrentRequests;
@property (nonatomic, copy) NSString *accessToken;

+ (WeiboRequest *)shared;

- (WeiboRequestOperation*)requestWithURLRequest:(NSURLRequest *)request
                                      completed:(WeiboRequestCompletedBlock)completedBlock;

- (WeiboRequestOperation*)getFromUrl:(NSString *)url
                              params:(NSDictionary *)params
                           completed:(WeiboRequestCompletedBlock)completedBlock;
- (WeiboRequestOperation*)postToUrl:(NSString *)url
                             params:(NSDictionary *)params
                          completed:(WeiboRequestCompletedBlock)completedBlock;

- (WeiboRequestOperation*)getFromPath:(NSString *)apiPath
                               params:(NSDictionary *)params
                            completed:(WeiboRequestCompletedBlock)completedBlock;
- (WeiboRequestOperation*)postToPath:(NSString *)apiPath
                              params:(NSDictionary *)params
                           completed:(WeiboRequestCompletedBlock)completedBlock;

@end
