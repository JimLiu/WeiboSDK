//
//  WeiboRequestOperation.h
//  WeiboSDK
//
//  Created by Liu Jim on 8/4/13.
//  Copyright (c) 2013 openlab. All rights reserved.
//
// 参考代码：SDWebImageDownloaderOperation

#import <Foundation/Foundation.h>

typedef void(^WeiboRequestCompletedBlock)(id result, NSData *data, NSError *error);

@interface WeiboRequestOperation : NSOperation

@property (nonatomic, strong, readonly) NSURLRequest *request;
@property (nonatomic, readonly) BOOL sessionDidExpire;

- (id)initWithRequest:(NSURLRequest *)request
                queue:(dispatch_queue_t)queue
            completed:(WeiboRequestCompletedBlock)completedBlock
            cancelled:(void (^)())cancelBlock;

@end
