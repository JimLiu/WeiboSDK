//
//  NSDictionaryAdditions.h
//  WeiboPad
//
//  Created by junmin liu on 10-10-6.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (Additions)

- (BOOL)boolValueForKey:(NSString *)key;
- (BOOL)boolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue;
- (int)intValueForKey:(NSString *)key;
- (int)intValueForKey:(NSString *)key defaultValue:(int)defaultValue;
- (time_t)timeValueForKey:(NSString *)key;
- (time_t)timeValueForKey:(NSString *)key defaultValue:(time_t)defaultValue;
- (long long)longLongValueValueForKey:(NSString *)key;
- (long long)longLongValueValueForKey:(NSString *)key defaultValue:(long long)defaultValue;
- (NSString *)stringValueForKey:(NSString *)key;
- (NSString *)stringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue;
- (NSDictionary *)dictionaryValueForKey:(NSString *)key;
- (NSArray *)arrayValueForKey:(NSString *)key;
- (double)doubleValueValueForKey:(NSString *)key;
- (double)doubleValueValueForKey:(NSString *)key defaultValue:(double)defaultValue;

@end
