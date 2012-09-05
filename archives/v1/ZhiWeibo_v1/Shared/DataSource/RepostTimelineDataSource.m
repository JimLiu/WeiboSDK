//
//  RepostTimelineDataSource.m
//  ZhiWeibo
//
//  Created by Zhang Jason on 1/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RepostTimelineDataSource.h"


@implementation RepostTimelineDataSource

@synthesize status;

- (void)loadRecentStatuses {
    if (weiboClient || !status) { 
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
	[weiboClient getRepostTimelineSinceID:since_id statusId:status.statusId startingAtPage:0 count:downloadCount];
}


- (void)loadMoreStatuses:(long long)maxStatusId {
	if (weiboClient || !status) { 
		[self doneLoadingTableViewData];
		[weiboClient release];
		weiboClient = nil;
	}
	insertPosition = statusIds.count;
	weiboClient = [[WeiboClient alloc] initWithTarget:self 
											   action:@selector(moreStatusesDidReceive:obj:)];
	[weiboClient getRepostTimelineStatusId:status.statusId maximumID:maxStatusId startingAtPage:0 count:downloadCount];	
}

@end
