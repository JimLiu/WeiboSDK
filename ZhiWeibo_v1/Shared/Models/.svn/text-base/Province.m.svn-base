//
//  Province.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-10-22.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "Province.h"
#import "CXMLElementAdditions.h"


@implementation Province
@synthesize provinceId, name, provinceKey;
@synthesize cities;

- (id)initWithXml:(CXMLElement *)node {
	if (self = [super init]) {
		provinceId = [node getIntValueForAttributeName:@"id" defaultValue:-1];
		provinceKey = [[NSNumber numberWithInt:provinceId] retain];
		name = [[node getStringValueForAttributeName:@"name" defaultValue:@""]copy];
		cities = [[NSMutableDictionary alloc]init];
		for (CXMLElement *cityNode in [node elementsForName:@"city"]) {
			int cityId = [cityNode getIntValueForAttributeName:@"id" defaultValue:0];
			NSString *cityName = [cityNode getStringValueForAttributeName:@"name" defaultValue:@""];
			[cities setObject:cityName forKey:[NSNumber numberWithInt:cityId]];
		}
	}
	return self;
}
			 


- (void)dealloc {
	[name release];
	[provinceKey release];
	[cities release];
	[super dealloc];
}
@end
