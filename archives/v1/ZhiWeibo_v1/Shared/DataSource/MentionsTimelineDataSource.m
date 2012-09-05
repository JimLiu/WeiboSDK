//
//  MentionsTimelineDataSource.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-23.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "MentionsTimelineDataSource.h"


@implementation MentionsTimelineDataSource

- (void)loadStatusesFromLocal {
	NSString *filePath = [WeiboEngine getCurrentUserStoreagePath:@"mentionsTimeline.db"];
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
	NSString *filePath = [WeiboEngine getCurrentUserStoreagePath:@"mentionsTimeline.db"];
	[StatusCache storageStatuses:statuses filePath:filePath];
}

- (void)loadRecentStatuses {
    if (weiboClient) { 
		//[self doneLoadingTableViewData];
		return;
	}
	NetworkStatus connectionStatus = [[Reachability2 sharedReachability] internetConnectionStatus];
	downloadCount = (connectionStatus == ReachableViaWiFiNetwork) ? 200 : 100;

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
	[weiboClient getMentionsSinceID:since_id startingAtPage:0 count:downloadCount];
}

- (void)insertStatuses:(long long)maxStatusId 
		insertPosition:(int)insertPos {
	if (weiboClient) { 
		[self doneLoadingTableViewData];
		[weiboClient release];
		weiboClient = nil;
	}

	NetworkStatus connectionStatus = [[Reachability2 sharedReachability] internetConnectionStatus];
	downloadCount = (connectionStatus == ReachableViaWiFiNetwork) ? 200 : 100;

	insertPosition = insertPos;
	weiboClient = [[WeiboClient alloc] initWithTarget:self 
											   action:@selector(insertStatusesDidReceive:obj:)];
	[weiboClient getMentionsMaximumID:maxStatusId startingAtPage:0 count:downloadCount];	
	
}

- (void)loadMoreStatuses:(long long)maxStatusId {
	if (weiboClient) { 
		[self doneLoadingTableViewData];
		[weiboClient release];
		weiboClient = nil;
	}
	NetworkStatus connectionStatus = [[Reachability2 sharedReachability] internetConnectionStatus];
	downloadCount = (connectionStatus == ReachableViaWiFiNetwork) ? 200 : 100;

	insertPosition = statusIds.count;
	weiboClient = [[WeiboClient alloc] initWithTarget:self 
											   action:@selector(moreStatusesDidReceive:obj:)];
	[weiboClient getMentionsMaximumID:maxStatusId startingAtPage:0 count:downloadCount];	
}


@end
