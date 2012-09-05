//
//  TrendTimelineDataSource.m
//  ZhiWeibo
//
//  Created by Zhang Jason on 12/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TrendsTimelineDataSource.h"


@implementation TrendsTimelineDataSource
@synthesize trends_name;

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
	[weiboClient getTrendsTimelineName:trends_name];
	isLoadCompleted = YES;
}


- (void)loadMoreStatuses:(long long)maxStatusId {
	/*
	if (weiboClient) { 
		[self doneLoadingTableViewData];
		[weiboClient release];
		weiboClient = nil;
	}
	insertPosition = statusIds.count;
	weiboClient = [[WeiboClient alloc] initWithTarget:self 
											   action:@selector(moreStatusesDidReceive:obj:)];
	[weiboClient getTrendsTimelineName:trends_name];
	 */
}

- (void)dealloc {
	[trends_name release];
	[super dealloc];
}

@end
