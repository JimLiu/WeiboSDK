//
//  FriendCache.h
//  ZhiWeibo
//
//  Created by Zhang Jason on 1/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MiniUser.h"


@interface FriendCache : NSObject {

}

+ (void)cache:(MiniUser*)_user;

+ (MiniUser *)get:(NSString*)name;

+ (User *)getUserByScreenName:(NSString *)_screenName;

+ (User *)getUserBYId:(long long)_id;

+ (void)remove:(NSNumber*)_userKey;

+ (void)removeAll;

+ (NSMutableArray *)searchUserByScreenName:(NSString *)_searchKey;

+ (NSMutableArray *)getAllUser;

+ (void)loadFromLocal;

+ (void)storeToLocal;

@end
