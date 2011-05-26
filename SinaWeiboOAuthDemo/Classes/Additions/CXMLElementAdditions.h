//
//  CXMLElementAdditions.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-10-18.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouchXML.h"

@interface CXMLElement (Addtions)

- (int)getIntValueForAttributeName:(NSString *)attributeName
					  defaultValue:(int)defaultValue;

- (NSString *)getStringValueForAttributeName:(NSString *)attributeName
								defaultValue:(NSString *)defaultValue;

- (int)getIntValueForSubElementName:(NSString *)elementName	defaultValue:(int)defaultValue;

- (NSString *)getStringValueForSubElementName:(NSString *)elementName defaultValue:(NSString *)defaultValue;

@end
