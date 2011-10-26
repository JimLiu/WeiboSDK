//
//  UserCache.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-10-24.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "UserCache.h"

static NSMutableDictionary *usersDic = nil;
static NSMutableDictionary *screenNameToUserKeyDic = nil;

@implementation UserCache


+ (void)cache:(User*)_user {
	if (!usersDic) {
		usersDic = [[NSMutableDictionary alloc]init];
	}
	if (!screenNameToUserKeyDic) {
		screenNameToUserKeyDic = [[NSMutableDictionary alloc]init];
	}
	if (!_user) {
		return;
	}
	[usersDic setObject:_user forKey:_user.userKey];
	[screenNameToUserKeyDic setObject:_user.userKey forKey:_user.screenName];
}

+ (User *)get:(NSNumber*)_userKey {
	if (!usersDic) {
		return nil;
	}
	return [usersDic objectForKey:_userKey];
}

+ (User *)getUserByScreenName:(NSString *)_screenName {
	if (!screenNameToUserKeyDic) {
		return nil;
	}
	NSNumber *userKey = [screenNameToUserKeyDic objectForKey:_screenName];
	if (userKey) {
		return [UserCache get:userKey];
	}
	return nil;
}


+ (void)remove:(NSNumber*)_userKey {
	if (!usersDic) {
		return;
	}
	[usersDic removeObjectForKey:_userKey];
}

+ (void)removeAll {
	if (!usersDic) {
		return;
	}
	[usersDic removeAllObjects];	
}
/*
+ (NSMutableArray *)searchUserByScreenName:(NSString *)_searchKey {
	if (!screenNameToUserKeyDic || _searchKey == nil) {
		return nil;
	}
	NSMutableArray *results = [[[NSMutableArray alloc] init] autorelease];
	NSArray *screenNames = [screenNameToUserKeyDic allKeys];
	for (NSString *name in screenNames) {
		if ([name rangeOfString:_searchKey].location < 2147483647 || [_searchKey isEqualToString:@""]) {
			[results addObject:[usersDic objectForKey:[screenNameToUserKeyDic objectForKey:name]]];
		}
	}
	return results;
}
 */

@end
