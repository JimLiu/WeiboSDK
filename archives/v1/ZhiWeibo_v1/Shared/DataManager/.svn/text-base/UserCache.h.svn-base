//
//  UserCache.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-10-24.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserCache : NSObject {

}


+ (void)cache:(User*)_user;

+ (User *)get:(NSNumber*)_userKey;

+ (User *)getUserByScreenName:(NSString *)_screenName;

+ (void)remove:(NSNumber*)_userKey;

+ (void)removeAll;

//+ (NSMutableArray *)searchUserByScreenName:(NSString *)_searchKey;

@end
