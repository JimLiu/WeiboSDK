//
//  WeiboQuery.h
//  WeiboSDK
//
//  Created by Liu Jim on 8/4/13.
//  Copyright (c) 2013 openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboRequest.h"

@interface WeiboQuery : NSObject<WeiboRequestDelegate>  {
    
    WeiboRequest *_request;
}

- (void)cancel;

- (void)getWithAPIPath:(NSString *)apiPath
                params:(NSMutableDictionary *)params;
- (void)postWithAPIPath:(NSString *)apiPath
                 params:(NSMutableDictionary *)params;

@end
