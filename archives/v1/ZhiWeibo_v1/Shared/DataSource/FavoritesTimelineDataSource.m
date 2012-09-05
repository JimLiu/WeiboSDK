//
//  FavoritesTimelineDataSource.m
//  ZhiWeibo
//
//  Created by Zhang Jason on 12/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FavoritesTimelineDataSource.h"


@implementation FavoritesTimelineDataSource

- (id)initWithTableView:(PullRefreshTableView *)_tableView {
	if([super initWithTableView:_tableView]){
		page = 2;
		downloadCount = 20;
	}
	return self;
}

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
	[weiboClient getFavoritesTimelinePage:1];
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
	[weiboClient getFavoritesTimelinePage:page++];
}
- (void)recentStatusesDidReceive:(WeiboClient*)sender obj:(NSObject*)obj
{
	BOOL needsScroll = statusIds.count > 0;
    if (sender.hasError) {
		NSLog(@"recentStatusesDidReceive error!!!, errorMessage:%@, errordetail:%@"
			  , sender.errorMessage, sender.errorDetail);
        [sender alert];
        if (sender.statusCode == 401) {
            [[ZhiWeiboAppDelegate getAppDelegate] openAuthenticateView];
        }
		[self stopLoading];
        return;
    }
	
    if (obj == nil || ![obj isKindOfClass:[NSArray class]]) {
		[self stopLoading];
        return;
    }

	CGFloat offset = tableView.contentOffset.y;
	NSArray *ary = (NSArray*)obj;
	int updatedCount = 0;
	for (int i = [ary count] - 1; i >= 0; --i) {
		NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
		if (![dic isKindOfClass:[NSDictionary class]]) {
			continue;
		}
		long long statusId = [dic getLongLongValueValueForKey:@"id" defaultValue:-1];
		BOOL needUpdate = YES;
		//for(int j = statusIds.count - 1;j >= updatedCount;j--){
		for(int j = 19;j >= updatedCount;j--){
			if(j >= statusIds.count || j < 0) continue;
			long long sId = [[statusIds objectAtIndex:j] longLongValue];
			if (statusId == sId) {
				needUpdate = NO;
				break;
			}
		}
		if (needUpdate == NO) {
			continue;
		}
		Status* sts = [Status statusWithJsonDictionary:dic];
		[StatusCache cache:sts];
		[statusIds insertObject:sts.statusKey atIndex:0];
		updatedCount++;
		if (needsScroll) {
			[unreadStatusIds addObject:sts.statusKey];
		}
		[syncCommentCountsStatusIdsQueue addObject:sts.statusKey];
		if (sts.retweetedStatus) {
			[syncCommentCountsStatusIdsQueue addObject:sts.retweetedStatus.statusKey];
		}
		hasUnreadStatus = YES;
		offset += [self getStatusTableViewCellHeight:sts];
	}
	/*
	if ([ary count] == downloadCount && lastStatusKey 
		&& (lastSyncStatusId > [lastStatusKey longLongValue])) { // 当前Load和上次存储的数据之间有空隙
		
		DummyGapStatus *dummyGapStatus = [[DummyGapStatus alloc] initWithStatusId:lastSyncStatusId];
		[statusIds insertObject:dummyGapStatus atIndex:insertPosition + unread];
		[dummyGapStatus release];
		offset += 44;
	}
	*/
	[tableView reloadData];
	if (needsScroll) {
		[tableView setContentOffset:CGPointMake(0, offset)];
	}
	[tableView flashScrollIndicators];
	[self stopLoading];
}


- (void)moreStatusesDidReceive:(WeiboClient*)sender obj:(NSObject*)obj
{
    if (sender.hasError) {
		NSLog(@"moreStatusesDidReceive error!!!, errorMessage:%@, errordetail:%@"
			  , sender.errorMessage, sender.errorDetail);
		[sender alert];
        if (sender.statusCode == 401) {
            [[ZhiWeiboAppDelegate getAppDelegate] openAuthenticateView];
        }
 		[self stopLoading];
        return;
    }
	
    if (obj == nil || ![obj isKindOfClass:[NSArray class]]) {
		[self stopLoading];
        return;
    }
	
	int insertPos = statusIds.count;
	int updatedCount = 0;
	NSArray *ary = (NSArray*)obj;    
	for (int i = [ary count] - 1; i >= 0; --i) {
		NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
		if (![dic isKindOfClass:[NSDictionary class]]) {
			continue;
		}
		long long statusId = [dic getLongLongValueValueForKey:@"id" defaultValue:-1];
		BOOL needUpdate = YES;
		for(int j = statusIds.count - 1 - updatedCount;j >= 0;j--){
			long long sId = [[statusIds objectAtIndex:j] longLongValue];
			if (statusId == sId) {
				needUpdate = NO;
				break;
			}
		}
		if (needUpdate == NO) {
			continue;
		}
		Status* sts = [Status statusWithJsonDictionary:dic];
		[StatusCache cache:sts];
		[statusIds insertObject:sts.statusKey atIndex:insertPos];
		[syncCommentCountsStatusIdsQueue addObject:sts.statusKey];
		if (sts.retweetedStatus) {
			[syncCommentCountsStatusIdsQueue addObject:sts.retweetedStatus.statusKey];
		}
		updatedCount++;
	}
	if ([ary count] < downloadCount) { //全部下载完了
		isLoadCompleted = YES;
	}
	else {
		if(updatedCount < downloadCount)
			[self loadMoreStatuses:0];
	}

	[tableView reloadData];
	[tableView flashScrollIndicators];
	[self stopLoading];
}

@end
