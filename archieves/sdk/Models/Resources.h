//
//  Resources.h
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-8-31.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Province.h"

@interface Resources : NSObject

+ (NSString *)provincesJson;

+ (NSString *)getProvinceName:(NSString *)provinceId;
+ (NSString *)getCityNameWithProvinceId:(NSString *)provinceId
							 withCityId:(NSString *)cityId;

@end
