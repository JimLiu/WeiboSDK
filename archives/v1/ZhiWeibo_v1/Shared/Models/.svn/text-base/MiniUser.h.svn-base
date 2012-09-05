//
//  MiniUser.h
//  ZhiWeibo
//
//  Created by Zhang Jason on 1/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "sqlite3.h"
#import "GlobalCore.h"
#import "ProvinceDataSource.h"
#import "DBConnection.h"
#import "Statement.h"

@interface MiniUser : NSObject<NSCoding> {
	long long    userId; //用户UID
	NSNumber		*userKey;
	NSString*   screenName; //微博昵称
	NSString*   profileImageUrl; //自定义图像
}

@property (nonatomic, assign) long long  userId;
@property (nonatomic, retain) NSNumber*		userKey;
@property (nonatomic, retain) NSString* screenName;
@property (nonatomic, retain) NSString* profileImageUrl;


- (MiniUser*)initWithJsonDictionary:(NSDictionary*)dic;
- (MiniUser*)initWithUser:(User*)user;
- (MiniUser*)initWithScreenName:(NSString*)name;

- (NSString*)pinyinOfScreenName;

@end
