//
//  CXMLElementAdditions.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-10-18.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "CXMLElementAdditions.h"


@implementation CXMLElement (Addtions)


- (int)getIntValueForAttributeName:(NSString *)attributeName
						  defaultValue:(int)defaultValue
{
	if ([self attributeForName:attributeName] != nil)
		return [[[self attributeForName:attributeName]stringValue] intValue];
	return defaultValue;
}


- (NSString *)getStringValueForAttributeName:(NSString *)attributeName
									defaultValue:(NSString *)defaultValue
{
	if ([self attributeForName:attributeName] != nil)
		return [[self attributeForName:attributeName]stringValue];
	return defaultValue;
}

- (int)getIntValueForSubElementName:(NSString *)elementName	defaultValue:(int)defaultValue {
	NSString *elementValu = [self getStringValueForSubElementName:elementName 
													 defaultValue:[NSString stringWithFormat:@"%d", defaultValue]];
	return [elementValu intValue];
}

- (NSString *)getStringValueForSubElementName:(NSString *)elementName defaultValue:(NSString *)defaultValue {
	if ([self elementsForName:elementName].count == 1) {
		CXMLElement *subNode = [[self elementsForName:elementName]objectAtIndex:0];
		return [subNode stringValue];
	}
	return defaultValue;
}

@end
