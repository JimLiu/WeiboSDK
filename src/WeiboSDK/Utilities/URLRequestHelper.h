//
//  URLRequestHelper.h
//  WeiboSDK
//
//  Created by Liu Jim on 8/4/13.
//  Copyright (c) 2013 openlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLRequestHelper : NSObject

+ (NSMutableURLRequest *)postRequestWithUrl:(NSString *)url
                                     params:(NSDictionary *)params;

+ (NSMutableURLRequest *)getRequestWithUrl:(NSString *)url
                                    params:(NSDictionary *)params;

@end
