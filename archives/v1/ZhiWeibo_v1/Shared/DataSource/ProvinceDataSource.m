//
//  ProvinceDataSource.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-10-22.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "ProvinceDataSource.h"

static NSMutableDictionary *gProvinces;

@implementation ProvinceDataSource


+ (NSMutableDictionary *)provinces {
	if (gProvinces) {
		return gProvinces;
	}
	
	if (!gProvinces) {
		gProvinces = [[NSMutableDictionary alloc] init];
	}
	NSString *path = [[[NSBundle mainBundle] resourcePath] 
					  stringByAppendingPathComponent:@"provinces.xml"];
	NSData *data = [NSData dataWithContentsOfFile: path];
	
	CXMLDocument *doc = [[CXMLDocument alloc] initWithData:data options:0 error:nil];
	
	for (CXMLElement *emotionNode in [[doc rootElement] elementsForName:@"province"]) {
		Province *province = [[Province alloc]initWithXml:emotionNode];
		[gProvinces setObject:province forKey:province.provinceKey];
		[province release];
	}
	
	[doc release];
	return gProvinces;
	
}

+ (NSString *)getProvinceName:(int)provinceId {
	NSMutableDictionary *provinces = [ProvinceDataSource provinces];
	Province *p = [provinces objectForKey:[NSNumber numberWithInt:provinceId]];
	if (p) {
		return p.name;
	}
	return @"";
}

+ (NSString *)getCityNameWithProvinceId:(int)provinceId 
							 withCityId:(int)cityId {
	NSMutableDictionary *provinces = [ProvinceDataSource provinces];
	Province *p = [provinces objectForKey:[NSNumber numberWithInt:provinceId]];
	NSString *cityName = nil;
	if (p) {
		cityName = [p.cities objectForKey:[NSNumber numberWithInt:cityId]];
	}
	if (!cityName) {
		cityName = @"";
	}
	return cityName;
}


@end
