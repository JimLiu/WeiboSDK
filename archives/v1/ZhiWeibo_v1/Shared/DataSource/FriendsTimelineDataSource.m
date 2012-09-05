//
//  FriendsTimelineDataSource.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-21.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "FriendsTimelineDataSource.h"
#import "ImageCache.h"

@implementation FriendsTimelineDataSource

- (void)loadStatusesFromLocal {
	NSString *filePath = [WeiboEngine getCurrentUserStoreagePath:@"friendsTimeline.db"];
	NSMutableArray *statuses = [StatusCache loadStatusWithFilePath:filePath];
	for (Status *sts in statuses) {
		if ([sts isKindOfClass:[Status class]]) {
			[StatusCache cache:sts];
			[statusIds addObject:sts.statusKey];
		}
		else {
			[statusIds addObject:sts];
		}
	}
}

- (void)storageStatuses:(NSArray *)statuses {
	NSString *filePath = [WeiboEngine getCurrentUserStoreagePath:@"friendsTimeline.db"];
	[StatusCache storageStatuses:statuses filePath:filePath];
}

- (void)loadRecentStatuses {
    if (weiboClient) { 
		//[self doneLoadingTableViewData];
		return;
	}
	
	NetworkStatus connectionStatus = [[Reachability2 sharedReachability] internetConnectionStatus];
	downloadCount = (connectionStatus == ReachableViaWiFiNetwork) ? 200 : 50;
	
	
    long long since_id = 0;
	if (statusIds.count > 0) {
		NSNumber* statusKey = [statusIds objectAtIndex:0];
        if (statusKey && [statusKey isKindOfClass:[NSNumber class]]) {
            since_id = [statusKey longLongValue];
        }
	}	
	insertPosition = 0;
	weiboClient = [[WeiboClient alloc] initWithTarget:self
											   action:@selector(recentStatusesDidReceive:obj:)];
	[weiboClient getFollowedTimelineSinceID:since_id startingAtPage:0 count:downloadCount];
}

- (void)insertStatuses:(long long)maxStatusId 
		insertPosition:(int)insertPos {
	if (weiboClient) { 
		[self doneLoadingTableViewData];
		[weiboClient release];
		weiboClient = nil;
	}
	insertPosition = insertPos;
	weiboClient = [[WeiboClient alloc] initWithTarget:self 
											   action:@selector(insertStatusesDidReceive:obj:)];
	[weiboClient getFollowedTimelineMaximumID:maxStatusId startingAtPage:0 count:downloadCount];	
	
}

- (void)loadMoreStatuses:(long long)maxStatusId {
	if (weiboClient) { 
		[self doneLoadingTableViewData];
		[weiboClient release];
		weiboClient = nil;
	}
	insertPosition = statusIds.count;
	weiboClient = [[WeiboClient alloc] initWithTarget:self 
											   action:@selector(moreStatusesDidReceive:obj:)];
	[weiboClient getFollowedTimelineMaximumID:maxStatusId startingAtPage:0 count:downloadCount];	
}

@end
