//
//  Resources.h
//  WeiboSDK
//
//  Created by Liu Jim on 8/3/13.
//  Copyright (c) 2013 openlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Resources : NSObject

+ (NSString *)getProvinceName:(NSString *)provinceId;
+ (NSString *)getCityNameWithProvinceId:(NSString *)provinceId
							 withCityId:(NSString *)cityId;

@end


