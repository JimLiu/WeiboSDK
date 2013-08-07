//
//  DBAccess.m
//  WeiboPlus
//
//  Created by junmin liu on 12-9-22.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "DBAccess.h"

static DBAccess *sharedInstance = nil;

@implementation DBAccess

- (id)init {
    self = [super init];
    if (self) {        
        NSString *dbFile = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
        dbFile = [dbFile stringByAppendingPathComponent:@"weibo.db"];
        
        _db = [[NULDBDB alloc]initWithLocation:dbFile];
        
    }
    return self;
}

- (void)dealloc {
    [_db release];
    [super dealloc];
}

+ (DBAccess *)shared {
    if (!sharedInstance) {
        sharedInstance = [[DBAccess alloc]init];
    }
    return sharedInstance;
}

- (NSString *)statusKey:(long long)statusId {
    return [NSString stringWithFormat:@"status-%lld", statusId];
}

- (void)saveStatus:(Status *)status {
    [_db storeValue:status forKey:[self statusKey:status.statusId]];
}

- (void)removeStatus:(long long)statusId {
    [_db deleteStoredValueForKey:[self statusKey:statusId]];
}

- (BOOL)containStatus:(long long)statusId {
    return [_db storedValueExistsForKey:[self statusKey:statusId]];
}

- (Status *)getStatus:(long long)statusId {
    return (Status *)[_db storedValueForKey:[self statusKey:statusId]];
}


- (NSString *)userKey:(long long)userId {
    return [NSString stringWithFormat:@"user-%lld", userId];
}

- (void)saveUser:(User *)user {
    [_db storeValue:user forKey:[self userKey:user.userId]];
}

- (void)removeUser:(long long)userId {
    [_db deleteStoredValueForKey:[self userKey:userId]];
}
 
- (BOOL)containUser:(long long)userId {
    return [_db storedValueExistsForKey:[self userKey:userId]];
}

- (User *)getUser:(long long)userId {
    return (User *)[_db storedValueForKey:[self userKey:userId]];
}

- (NSString *)timelineStatusIdsKey:(StatusTimeline)timeline {
    return [NSString stringWithFormat:@"StatusIds-%d", timeline];
}


- (NSMutableArray *)getTimelineStatusIds:(StatusTimeline)timeline {
    return (NSMutableArray *)[_db storedValueForKey:[self timelineStatusIdsKey:timeline]];
}

- (void)saveStatusIds:(NSMutableArray *)statusIds forTimeline:(StatusTimeline)timeline {
    [_db storeValue:statusIds forKey:[self timelineStatusIdsKey:timeline]];
}



@end
