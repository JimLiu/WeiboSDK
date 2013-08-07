//
//  TimelineStorage.m
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-9-11.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "TimelineStorage.h"

@implementation TimelineStorage

- (id)initWithStatusTimeline:(StatusTimeline)timeline {
    self = [super init];
    if (self) {
        _timeline = timeline;
        NSMutableArray *statusIds = [self getStatusIds];
        if (!statusIds) {
            statusIds = [NSMutableArray array];
        }
        _statusIds = [statusIds retain];
        _dbAccess = [DBAccess shared];
    }
    return self;
}

- (void)dealloc {
    [_statusIds release];
    [super dealloc];
}

- (NSMutableArray *)getStatusIds {
    return [_dbAccess getTimelineStatusIds:_timeline];
}

- (void)saveStatusIds:(NSMutableArray *)statusIds {
    [_dbAccess saveStatusIds:statusIds forTimeline:_timeline];
}

- (void)recentStatus:(NSMutableArray *)statuses
     isLoadCompleted:(BOOL)isLoadCompleted {
    
    NSMutableArray *addedStatuses = [NSMutableArray array];
    int unread = 0;
	long long lastSyncStatusId = 0;
    //int lastStatusCount = _statusIds.count;
	NSNumber* lastStatusKey = _statusIds.count > 0 ? [_statusIds objectAtIndex:0] : nil;
	for (Status* sts in statuses) {
		long long statusId = sts.statusId;
		if (lastSyncStatusId == 0 || statusId < lastSyncStatusId) {
			lastSyncStatusId = statusId;
		}
		if (lastStatusKey
			&& statusId <= [lastStatusKey longLongValue]) {
			// Ignore stale message
			continue;
		}
        [_dbAccess saveStatus:sts];
        [addedStatuses addObject:sts];
        [_statusIds insertObject:sts.statusKey atIndex:0];

        //todo: sync comment counts
        //todo: download images
		++unread;
	}
	
    if (unread < statuses.count) {
        isLoadCompleted = YES;
    }
	
    BOOL gap = NO;
	if (!isLoadCompleted && lastStatusKey
		&& (lastSyncStatusId > [lastStatusKey longLongValue])) { // If we have not downloaded completely
		
        [_statusIds insertObject:[NSNumber numberWithLongLong:-1] atIndex:unread];
        
		gap = YES;
	}
    
    [self saveStatusIds:_statusIds];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  addedStatuses, @"addedStatuses",
                                     [NSNumber numberWithBool:gap], @"gap", nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"recentStatusDidLoad"
                                                        object:addedStatuses
                                                      userInfo:userInfo];

}


- (void)insertStatuses:(NSMutableArray *)statuses
        insertPosition:(int)insertPosition
       isLoadCompleted:(BOOL)isLoadCompleted {
	NSNumber* preStatusKey = nil;
	NSNumber* nextStatusKey = nil;
	for (int i = insertPosition - 1; i >= 0; --i) {
		NSNumber *statusKey = [_statusIds objectAtIndex:i];
		if (statusKey && [statusKey longLongValue] > 0) {
			preStatusKey = statusKey;
			break;
		}
	}
	for (int i = insertPosition + 1; i < _statusIds.count; ++i) {
		NSNumber *statusKey = [_statusIds objectAtIndex:i];
		if (statusKey && [statusKey longLongValue] > 0) {
			nextStatusKey = statusKey;
			break;
		}
	}
	
    [_statusIds removeObjectAtIndex:insertPosition]; // remove  Gap number
	
	int unread = 0;
	long long statusId;
	long long lastSyncStatusId = 0;
    NSMutableArray *addedStatuses = [NSMutableArray array];
    
	for (Status* sts in statuses) {
		statusId = sts.statusId;
		if (lastSyncStatusId == 0 || statusId < lastSyncStatusId) {
			lastSyncStatusId = statusId;
		}
		if (statusId <= 0
			|| (preStatusKey && statusId >= [preStatusKey longLongValue])
			|| (nextStatusKey && statusId <= [nextStatusKey longLongValue])) {
			// Ignore stale message
			continue;
		}
        [_dbAccess saveStatus:sts];
        [_statusIds insertObject:sts.statusKey atIndex:insertPosition];
        [addedStatuses addObject:sts];
        // todo: sync comments
        // todo: download images
		unread++;
	}
    
    if (unread < statuses.count) {
        isLoadCompleted = YES;
    }
    
    BOOL gap = NO;
	if (!isLoadCompleted && nextStatusKey
        && (lastSyncStatusId > [nextStatusKey longLongValue])) { // There is a gap between these new statuses and thonse old statuses
		
		[_statusIds insertObject:[NSNumber numberWithLongLong:-1] atIndex:insertPosition + unread];
        gap = YES;
        
	}
    [self saveStatusIds:_statusIds];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     addedStatuses, @"addedStatuses",
                                     [NSNumber numberWithBool:gap], @"gap",
                                     [NSNumber numberWithInt:insertPosition], @"insertPosition",
                                     nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"statusesDidInsert"
                                                        object:addedStatuses
                                                      userInfo:userInfo];
    
}


- (void)moreStatuses:(NSMutableArray *)statuses
{
    NSMutableArray *addedStatuses = [NSMutableArray array];
	int insertPos = _statusIds.count;
	NSNumber* firstStatusKey = nil;
	for (int i = [_statusIds count] - 1; i >= 0; --i) {
		NSNumber *statusKey = [_statusIds objectAtIndex:i];
		if (statusKey && [statusKey isKindOfClass:[NSNumber class]]) {
			firstStatusKey = statusKey;
			break;
		}
	}
	for (Status* sts in statuses) {
		long long statusId = sts.statusId;
		if (statusId <= 0
            || (firstStatusKey && statusId >= [firstStatusKey longLongValue])) {
			// Ignore stale message
			continue;
		}
        [_dbAccess saveStatus:sts];
        [_statusIds insertObject:sts.statusKey atIndex:insertPos];
        [addedStatuses addObject:sts];
        // todo: sync comments
        // todo: download images
	}
    
    [self saveStatusIds:_statusIds];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     addedStatuses, @"addedStatuses",
                                     nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"moreStatusesDidLoad"
                                                        object:addedStatuses
                                                      userInfo:userInfo];
    
}

- (long long)lastStatusId {
    NSNumber* firstStatusKey = nil;
	for (int i = 0; i < [_statusIds count]; i++) {
		NSNumber *statusKey = [_statusIds objectAtIndex:i];
		if (statusKey && [statusKey longLongValue] > 0) {
			firstStatusKey = statusKey;
			break;
		}
	}
    if (firstStatusKey) {
        return [firstStatusKey longLongValue];
    }
    return -1;
}

@end
