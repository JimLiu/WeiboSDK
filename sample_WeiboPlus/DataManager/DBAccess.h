//
//  DBAccess.h
//  WeiboPlus
//
//  Created by junmin liu on 12-9-22.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NULDBDB.h"
#import "TimelineQuery.h"
#import "Status.h"
#import "User.h"

@interface DBAccess : NSObject {
    NULDBDB *_db;
}

+ (DBAccess *)shared;

- (void)saveStatus:(Status *)status;
- (void)removeStatus:(long long)statusId;
- (BOOL)containStatus:(long long)statusId;
- (Status *)getStatus:(long long)statusId;

- (void)saveUser:(User *)user;
- (void)removeUser:(long long)userId;
- (BOOL)containUser:(long long)userId;
- (User *)getUser:(long long)userId;

- (void)saveStatusIds:(NSMutableArray *)statusIds forTimeline:(StatusTimeline)timeline;
- (NSMutableArray *)getTimelineStatusIds:(StatusTimeline)timeline;

@end
