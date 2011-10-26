//
//  FriendCache.m
//  ZhiWeibo
//
//  Created by Zhang Jason on 1/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FriendCache.h"
#import "WeiboEngine.h"
#import "User.h"
#import "WeiboClient.h"
#import "WeiboEngine.h"

#define downCount 200

static NSMutableDictionary *screenNameToUserKeyDic = nil;
static WeiboClient *weiboClient = nil;

@implementation FriendCache

+ (void)cache:(MiniUser*)_user {
	if (!screenNameToUserKeyDic) {
		[self loadFromLocal];
	}
	if (!_user) {
		return;
	}
	[screenNameToUserKeyDic setObject:_user forKey:_user.screenName];
}

+ (MiniUser *)get:(NSString*)name {
	
	if (!screenNameToUserKeyDic) {
		[self loadFromLocal];
	}
	return [screenNameToUserKeyDic objectForKey:name];
	 
}

+ (User *)getUserByScreenName:(NSString *)_screenName {
	if (!screenNameToUserKeyDic) {
		[self loadFromLocal];
	}
	return  [[[User alloc] initWithMiniUser:[screenNameToUserKeyDic objectForKey:_screenName]] autorelease];
}

+ (User *)getUserBYId:(long long)_id {
	if (!screenNameToUserKeyDic) {
		[self loadFromLocal];
	}
	NSArray *ary = [screenNameToUserKeyDic allValues];
	for (MiniUser *user in ary) {
		if (user.userId == _id) {
			return [[[User alloc] initWithMiniUser:user] autorelease];
		}
	}
	return nil;
}

+ (void)remove:(NSNumber*)_userKey {
	if (!screenNameToUserKeyDic) {
		return;
	}
	[screenNameToUserKeyDic removeObjectForKey:_userKey];
}

+ (void)removeAll {
	if (!screenNameToUserKeyDic) {
		return;
	}
	[screenNameToUserKeyDic removeAllObjects];
}

+ (NSMutableArray *)searchUserByScreenName:(NSString *)_searchKey {
	if (_searchKey == nil || [_searchKey isEqualToString:@""]) {
		return nil;
	}
	if (!screenNameToUserKeyDic) {
		[self loadFromLocal];
	}
	NSMutableArray *results = [[[NSMutableArray alloc] init] autorelease];
	NSArray *screenNames = [screenNameToUserKeyDic allKeys];
	for (NSString *name in screenNames) {
		MiniUser *user = [screenNameToUserKeyDic objectForKey:name];
		if ([[name lowercaseString] rangeOfString:[_searchKey lowercaseString]].location != NSNotFound) {
			[results addObject:[[[User alloc] initWithMiniUser:user] autorelease]];
		}
		else if([[[user pinyinOfScreenName]lowercaseString] rangeOfString:[_searchKey lowercaseString]].location != NSNotFound) {
			[results addObject:[[[User alloc] initWithMiniUser:user] autorelease]];
		}

	}
	return results;
}

+ (NSMutableArray *)getAllUser {
	NSMutableArray *results = [[[NSMutableArray alloc] init] autorelease];
	NSArray *mUsers = [screenNameToUserKeyDic allValues];
	for (MiniUser *mUser in mUsers) {
		[results addObject:[[[User alloc] initWithMiniUser:mUser] autorelease]];
	}
	return results;
}

+ (void)loadFromLocal {
	NSString *filePath = [WeiboEngine getCurrentUserStoreagePath:@"friendusersdic.db"];
	NSMutableDictionary *t = [[NSKeyedUnarchiver unarchiveObjectWithFile:filePath] retain];
	if ([t isKindOfClass:[NSMutableDictionary class]]) {
		[screenNameToUserKeyDic release];
		screenNameToUserKeyDic = [t retain];
	}
	else {
		screenNameToUserKeyDic = [[NSMutableDictionary alloc] init];
		weiboClient = [[WeiboClient alloc] initWithTarget:self 
												   action:@selector(usersDidReceive:obj:)];
		[weiboClient getFriends:[[WeiboEngine getCurrentUser] userId] cursor:-1 count:downCount];
	}

}

+ (void)storeToLocal {
	NSString *filePath = [WeiboEngine getCurrentUserStoreagePath:@"friendusersdic.db"];
	[NSKeyedArchiver archiveRootObject:screenNameToUserKeyDic toFile:filePath];
}

+ (void)usersDidReceive:(WeiboClient*)sender obj:(NSObject*)obj
{
    if (sender.hasError) {
		NSLog(@"usersDidReceive error!!!, errorMessage:%@, errordetail:%@"
			  , sender.errorMessage, sender.errorDetail);
        if (sender.statusCode == 401) {
            ZhiWeiboAppDelegate *appDelegate = [ZhiWeiboAppDelegate getAppDelegate];
            [appDelegate openAuthenticateView];
        }
        [sender alert];
    }
	
    if (obj == nil || ![obj isKindOfClass:[NSDictionary class]]) {
		weiboClient.delegate = nil;
		[weiboClient release];
		weiboClient = nil;
        return;
    }

	NSDictionary *dic = (NSDictionary*)obj;
	
	NSArray *ary = (NSArray*)[dic objectForKey:@"users"];    
	if (!ary || ![ary isKindOfClass:[NSArray class]]) {
		weiboClient.delegate = nil;
		[weiboClient release];
		weiboClient = nil;
		return;
	}
	for (int i = 0; i < [ary count]; i++) {
		NSDictionary *dic1 = (NSDictionary*)[ary objectAtIndex:i];
		if (![dic1 isKindOfClass:[NSDictionary class]]) {
			continue;
		}
		User* user = [User userWithJsonDictionary:[ary objectAtIndex:i]];
		[screenNameToUserKeyDic setObject:user forKey:user.screenName];

	}
	weiboClient.delegate = nil;
	[weiboClient release];
	weiboClient = nil;
	[self storeToLocal];
	
	int cursor = [[dic objectForKey:@"next_cursor"] intValue];
	if (ary.count != 0 && cursor > 0) {
		weiboClient = [[WeiboClient alloc] initWithTarget:self 
												   action:@selector(usersDidReceive:obj:)];
		[weiboClient getFriends:[[WeiboEngine getCurrentUser] userId] cursor:cursor count:downCount];
	}
}

@end
