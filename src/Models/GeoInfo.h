//
//  Geo.h
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-9-5.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionaryAdditions.h"

@interface GeoInfo : NSObject<NSCoding> {
    double _latitude;               //纬度
	double _longitude;              //经度
}

- (id)initWithJsonDictionary:(NSDictionary*)dic;


@property (nonatomic, assign) double latitude;  //纬度
@property (nonatomic, assign) double longitude; //经度


@end
