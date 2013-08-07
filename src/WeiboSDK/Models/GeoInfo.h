//
//  GeoInfo.h
//  WeiboSDK
//
//  Created by Liu Jim on 8/3/13.
//  Copyright (c) 2013 openlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeoInfo : NSObject<NSCoding> {
    double _latitude;               //纬度
	double _longitude;              //经度
}

- (id)initWithJsonDictionary:(NSDictionary*)dic;


@property (nonatomic, assign) double latitude;  //纬度
@property (nonatomic, assign) double longitude; //经度


@end