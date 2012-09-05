//
//  UserTimelineDataSource.m
//  ZhiWeibo
//
//  Created by Zhang Jason on 12/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UserTimelineDataSource.h"

@implementation UserTimelineDataSource

@synthesize userId;


- (void)loadRecentStatuses {
    if (weiboClient) { 
		//[self doneLoadingTableViewData];
		return;
	}
	
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
	[weiboClient getUserTimelineSinceID:since_id userId:userId startingAtPage:0 count:downloadCount];
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
	[weiboClient getUserTimelineUserId:userId maximumID:maxStatusId startingAtPage:0 count:downloadCount];	
}

@end
