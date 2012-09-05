//
//  StatusDataSource.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-21.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "StatusDataSource.h"


@interface  StatusDataSource (Private)


@end

@implementation StatusDataSource
@synthesize statusDataSourceDelegate;

- (id)initWithTableView:(PullRefreshTableView *)_tableView {
	if (self = [super initWithTableView:_tableView]) {
		weiboClient = nil;
		getCommentsCountClient = nil;
		statusIds = [[NSMutableArray alloc]init];
		unreadStatusIds = [[NSMutableArray alloc]init];
		syncCommentCountsStatusIdsQueue = [[NSMutableArray alloc]init];
		loadCell = [[LoadMoreCell alloc]initWithStyle:UITableViewStylePlain reuseIdentifier:@"LoadCell"];
		
		[self loadStatusesFromLocal];
		
		downloadCount = 50;
		maxStorageStatusCount = 500;
	}
	return self;
}

- (void)setTableView:(PullRefreshTableView *)_tableView {
	[super setTableView:_tableView];
	[_tableView setContentOffset:lastOffset];
}

- (void)dealloc {
	[loadCell release];
	weiboClient.delegate = nil;
	[weiboClient release];
	getCommentsCountClient.delegate = nil;
	[getCommentsCountClient release];
	[statusIds release];
	[syncCommentCountsStatusIdsQueue release];
	[unreadStatusIds release];
	[userDefaultKeyForScrollTop release];
	[super dealloc];
}

- (void)loadCommentsCount {
	//syncCommentCountsStatusIdsQueue
	if (getCommentsCountClient) { 
		//[self doneLoadingTableViewData];
		return;
	}
	
	int count = syncCommentCountsStatusIdsQueue.count < 100 ? syncCommentCountsStatusIdsQueue.count : 100;
	NSArray *_statusIds = [syncCommentCountsStatusIdsQueue subarrayWithRange:NSMakeRange(0, count)];
	
	if (_statusIds.count > 0) {
		getCommentsCountClient = [[WeiboClient alloc] initWithTarget:self
															  action:@selector(commentsCountDidReceive:obj:)];
		[getCommentsCountClient getCommentCounts:_statusIds];		
	}
}

- (void)stopLoadCommentsCount {
	[getCommentsCountClient release];
	getCommentsCountClient = nil;
}


- (void)refreshTweetCell:(Status *)status {
	
}

- (void)commentsCountDidReceive:(WeiboClient*)sender obj:(NSObject*)obj {
	
	if (sender.hasError) {
		NSLog(@"commentsDidReceive error!!!, errorMessage:%@, errordetail:%@"
			  , sender.errorMessage, sender.errorDetail);
		[self stopLoadCommentsCount];
		return;
    }
	
    if (obj == nil || ![obj isKindOfClass:[NSArray class]]) {
		[self stopLoadCommentsCount];
        return;
    }
	NSArray *ary = (NSArray*)obj;   
	for (int i = [ary count] - 1; i >= 0; --i) {
		NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
		if (![dic isKindOfClass:[NSDictionary class]]) {
			continue;
		}
		long long statusId = [dic getLongLongValueValueForKey:@"id" defaultValue:-1];
		int comments = [dic getIntValueForKey:@"comments" defaultValue:-1];
		int rt = [dic getIntValueForKey:@"rt" defaultValue:-1];
		if (statusId > 0 && comments >= 0 && rt >= 0) {
			NSNumber *statusKey = [NSNumber numberWithLongLong:statusId];
			[syncCommentCountsStatusIdsQueue removeObject:statusKey]; //移除队列
			Status *sts = [StatusCache get:statusKey];
			if (!sts) {
				continue;
			}
			sts.commentsCount = comments;
			sts.retweetsCount = rt;	
			[StatusCache cache:sts];
			[self refreshTweetCell:sts];
		}
	}
	[self stopLoadCommentsCount];
	if ([ary count] > 0 && syncCommentCountsStatusIdsQueue.count > 0) { //防止死循环
		[self loadCommentsCount];
	}	
}

- (void)loadStatusesFromLocal {
	
}

- (void)saveStatusesToLocal {
	int i = 0;
	NSMutableArray *statuses = [NSMutableArray array];
	for (NSNumber *statusKey in statusIds) {
		if ([statusKey isKindOfClass:[NSNumber class]]) {
			Status *sts = [StatusCache get:statusKey];
			if (sts) {
				[statuses addObject:sts];
			}			
		}
		else {
			[statuses addObject:statusKey];
		}
		i++;
		if (i >= maxStorageStatusCount) {
			break;
		}
	}
	[self storageStatuses:statuses];
}

- (void)storageStatuses:(NSArray *)statuses {
}

- (void)loadRecentStatuses {
	
}

- (void)reloadTableViewDataSource{
	[self loadRecentStatuses];
}

- (void)loadTimeline {
	[tableView.refreshHeaderView setState:PullRefreshLoading];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.2];
	tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
	[UIView commitAnimations];	
	[self loadRecentStatuses];
	//[self reloadData];
}


- (void)loadMoreStatuses:(long long)maxStatusId {
	
}

- (void)insertStatuses:(long long)maxStatusId 
		  insertPosition:(int)insertPos {
	
}

- (void)stopLoading {
	[weiboClient release];
	weiboClient = nil;
	[self doneLoadingTableViewData];
	[loadCell.spinner stopAnimating];	
	[self loadCommentsCount];
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
	int unread = 0;
	long long lastSyncStatusId = 0;
	NSNumber* lastStatusKey = statusIds.count > 0 ? [statusIds objectAtIndex:0] : nil;
	NSArray *ary = (NSArray*)obj;    
	for (int i = [ary count] - 1; i >= 0; --i) {
		NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
		if (![dic isKindOfClass:[NSDictionary class]]) {
			continue;
		}
		long long statusId = [dic getLongLongValueValueForKey:@"id" defaultValue:-1];
		if (lastSyncStatusId == 0 || statusId < lastSyncStatusId) {
			lastSyncStatusId = statusId;
		}
		if (lastStatusKey 
			&& statusId <= [lastStatusKey longLongValue]) {
			// Ignore stale message
			continue;
		}
		Status* sts = [Status statusWithJsonDictionary:dic];
		[StatusCache cache:sts];
		[statusIds insertObject:sts.statusKey atIndex:0];
		if (needsScroll) {
			[unreadStatusIds addObject:sts.statusKey];
		}
		[syncCommentCountsStatusIdsQueue addObject:sts.statusKey];
		if (sts.retweetedStatus) {
			[syncCommentCountsStatusIdsQueue addObject:sts.retweetedStatus.statusKey];
		}
		hasUnreadStatus = YES;
		++unread;
		offset += [self getStatusTableViewCellHeight:sts];
	}
	
	
	if ([ary count] == downloadCount && lastStatusKey 
		&& (lastSyncStatusId > [lastStatusKey longLongValue])) { // 当前Load和上次存储的数据之间有空隙
		
		DummyGapStatus *dummyGapStatus = [[DummyGapStatus alloc] initWithStatusId:lastSyncStatusId];
		[statusIds insertObject:dummyGapStatus atIndex:insertPosition + unread];
		[dummyGapStatus release];
		offset += 44;
	}
	
	[tableView reloadData];
	if (needsScroll) {
		[tableView setContentOffset:CGPointMake(0, offset)];
	}
	[tableView flashScrollIndicators];
	[self stopLoading];
	unreadMessagesCount = unreadStatusIds.count;
	if (statusDataSourceDelegate) {
		[statusDataSourceDelegate unreadMessagesCountChanged:unreadMessagesCount];
	}
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
	NSNumber* firstStatusKey = nil;
	for (int i = [statusIds count] - 1; i >= 0; --i) {
		NSNumber *statusKey = [statusIds objectAtIndex:i];
		if (statusKey && [statusKey isKindOfClass:[NSNumber class]]) {
			firstStatusKey = statusKey;
			break;
		}
	}
	NSArray *ary = (NSArray*)obj;    
	for (int i = [ary count] - 1; i >= 0; --i) {
		NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
		if (![dic isKindOfClass:[NSDictionary class]]) {
			continue;
		}
		long long statusId = [dic getLongLongValueValueForKey:@"id" defaultValue:-1];
		if (statusId <= 0
				|| (firstStatusKey && statusId >= [firstStatusKey longLongValue])) {
			// Ignore stale message
			continue;
		}
		Status* sts = [Status statusWithJsonDictionary:dic];
		[StatusCache cache:sts];
		[statusIds insertObject:sts.statusKey atIndex:insertPos];
		[syncCommentCountsStatusIdsQueue addObject:sts.statusKey];
		if (sts.retweetedStatus) {
			[syncCommentCountsStatusIdsQueue addObject:sts.retweetedStatus.statusKey];
		}
		hasUnreadStatus = YES;
	}
	if ([ary count] < downloadCount) { //全部下载完了
		isLoadCompleted = YES;
	}	
	[tableView reloadData];
	[tableView flashScrollIndicators];
	[self stopLoading];
}


- (void)insertStatusesDidReceive:(WeiboClient*)sender obj:(NSObject*)obj
{
    if (sender.hasError) {
		NSLog(@"insertStatusesDidReceive error!!!, errorMessage:%@, errordetail:%@"
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
	NSNumber* preStatusKey = nil;
	NSNumber* nextStatusKey = nil;
	for (int i = insertPosition - 1; i >= 0; --i) {
		NSNumber *statusKey = [statusIds objectAtIndex:i];
		if (statusKey && [statusKey isKindOfClass:[NSNumber class]]) {
			preStatusKey = statusKey;
			break;
		}
	}
	for (int i = insertPosition + 1; i < statusIds.count; ++i) {
		NSNumber *statusKey = [statusIds objectAtIndex:i];
		if (statusKey && [statusKey isKindOfClass:[NSNumber class]]) {
			nextStatusKey = statusKey;
			break;
		}
	}
	
	[statusIds removeObjectAtIndex:insertPosition]; // remove DummyGapStatus
	
	int unread = 0;
	long long statusId;
	long long lastSyncStatusId = 0;
	NSArray *ary = (NSArray*)obj;    
	for (int i = [ary count] - 1; i >= 0; --i) {
		NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
		if (![dic isKindOfClass:[NSDictionary class]]) {
			continue;
		}
		statusId = [dic getLongLongValueValueForKey:@"id" defaultValue:-1];
		if (lastSyncStatusId == 0 || statusId < lastSyncStatusId) {
			lastSyncStatusId = statusId;
		}
		if (statusId <= 0
			|| (preStatusKey && statusId >= [preStatusKey longLongValue])
			|| (nextStatusKey && statusId <= [nextStatusKey longLongValue])) {
			// Ignore stale message
			continue;
		}
		Status* sts = [Status statusWithJsonDictionary:dic];
		[StatusCache cache:sts];
		[statusIds insertObject:sts.statusKey atIndex:insertPosition];
		[syncCommentCountsStatusIdsQueue addObject:sts.statusKey];
		if (sts.retweetedStatus) {
			[syncCommentCountsStatusIdsQueue addObject:sts.retweetedStatus.statusKey];
		}
		hasUnreadStatus = YES;
		unread++;
		offset += [self getStatusTableViewCellHeight:sts];
	}
	
	if ([ary count] == downloadCount && nextStatusKey 
			&& (lastSyncStatusId > [nextStatusKey longLongValue])) { // 当前Load和上次存储的数据之间有空隙
		
		DummyGapStatus *dummyGapStatus = [[DummyGapStatus alloc] initWithStatusId:lastSyncStatusId];
		[statusIds insertObject:dummyGapStatus atIndex:insertPosition + unread];
		[dummyGapStatus release];	
		//offset += 44;
	}
	BOOL needsScroll = NO;
	NSArray* indexPaths = [tableView indexPathsForVisibleRows];
	if (indexPaths.count > 0) {
		NSIndexPath *indexPath = [indexPaths objectAtIndex:indexPaths.count - 1];
		if (indexPath.row >= insertPosition) {
			needsScroll = YES;
		}
	}
	
	[tableView reloadData];
	if (needsScroll == YES) {
		[tableView setContentOffset:CGPointMake(0, offset)];
	}	
	[tableView flashScrollIndicators];
	[self stopLoading];
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return isLoadCompleted == YES ? [statusIds count] : [statusIds count] + 1;
}


- (UITableViewCell *)getStatusTableViewCell:(UITableView *)_tableView status:(Status*)status {
	return nil;
}

- (CGFloat)getStatusTableViewCellHeight:(Status *)status {
	return 72;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < statusIds.count) {
		id obj = [statusIds objectAtIndex:indexPath.row];
		if (obj) {
			if ([obj isKindOfClass:[NSNumber class]]) {
				NSNumber *statusKey = (NSNumber *)obj;
				Status *sts = [StatusCache get:statusKey];
				[unreadStatusIds removeObject:statusKey];
				if ([syncCommentCountsStatusIdsQueue indexOfObject:statusKey] < 0) {
					[syncCommentCountsStatusIdsQueue addObject:statusKey];
				}
				if (sts.retweetedStatus 
					&& [syncCommentCountsStatusIdsQueue indexOfObject:sts.retweetedStatus.statusKey] < 0) {
					[syncCommentCountsStatusIdsQueue addObject:sts.retweetedStatus.statusKey];
				}
				return [self getStatusTableViewCell:_tableView status:sts];
			}
			else if ([obj isKindOfClass:[DummyGapStatus class]]) {
				static NSString *CellIdentifier = @"DummyGapCell";
				DummyGapCell *cell = (DummyGapCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
				if (cell == nil) {
					cell = [[[DummyGapCell alloc] initWithStyle:UITableViewCellStyleDefault 
												reuseIdentifier:CellIdentifier] autorelease];
				}
				DummyGapStatus *dummyGapStatus = (DummyGapStatus *)obj;
				[cell.spinner stopAnimating];
				cell.dummyGapStatus = dummyGapStatus;
				return cell;
			}
			
		}
	}
    
    return loadCell;
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < statusIds.count) {
		id obj = [statusIds objectAtIndex:indexPath.row];
		if (obj) {
			if ([obj isKindOfClass:[NSNumber class]]) {
				NSNumber *statusKey = (NSNumber *)obj;
				Status *sts = [StatusCache get:statusKey];
				return [self getStatusTableViewCellHeight:sts];
			}
			return 44;
		}
	}
	return 48;
}


#pragma mark -
#pragma mark Table view delegate

- (void)scrollEnd {
	NSArray* indexPaths = [tableView indexPathsForVisibleRows];
	if (indexPaths.count == 0) {
		return;
	}
	long long endStatusId = -1;
	NSIndexPath *indexPath = [indexPaths objectAtIndex:indexPaths.count - 1];
	if (indexPath.row < statusIds.count) {
		id obj = [statusIds objectAtIndex:indexPath.row];
		if (obj) {
			if ([obj isKindOfClass:[NSNumber class]]) {
				NSNumber *statusKey = (NSNumber *)obj;
				endStatusId = [statusKey longLongValue];
			}
			else if ([obj isKindOfClass:[DummyGapStatus class]]) {
				DummyGapStatus *dummyGapStatus = (DummyGapStatus *)obj;
				endStatusId = dummyGapStatus.statusId;
			}
		}
	}
	if (endStatusId > 0) {
		for (int i = unreadStatusIds.count - 1; i >= 0; i--) {
			long long sid = [[unreadStatusIds objectAtIndex:i] longLongValue];
			if (sid <= endStatusId) {
				[unreadStatusIds removeObjectAtIndex:i];
			}
		}
	}
	
	if (unreadMessagesCount != unreadStatusIds.count) {
		unreadMessagesCount = unreadStatusIds.count;
		if (statusDataSourceDelegate) {
			[statusDataSourceDelegate unreadMessagesCountChanged:unreadMessagesCount];
		}		
	}
	if (userDefaultKeyForScrollTop) { // 记录当前位置
		CGFloat scrollTop = tableView.contentOffset.y;
		[[NSUserDefaults standardUserDefaults]setFloat:scrollTop forKey:userDefaultKeyForScrollTop];
		[[NSUserDefaults standardUserDefaults] synchronize]; 
	}	
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	[super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
	[self scrollEnd];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	[self scrollEnd];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
	[unreadStatusIds removeAllObjects];
	if (unreadMessagesCount != 0) {
		unreadMessagesCount = 0;
		if (statusDataSourceDelegate) {
			[statusDataSourceDelegate unreadMessagesCountChanged:unreadMessagesCount];
		}		
	}
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < statusIds.count) {
		id obj = [statusIds objectAtIndex:indexPath.row];
		if (obj) {
			if ([obj isKindOfClass:[NSNumber class]]) {
				NSNumber *statusKey = (NSNumber *)obj;
				Status *sts = [StatusCache get:statusKey];
				if (sts) {
					if (statusDataSourceDelegate) {
						[statusDataSourceDelegate tweetSelected:sts];
					}
				}
				
			}
			else if ([obj isKindOfClass:[DummyGapStatus class]]) {
				DummyGapStatus *dummyGapStatus = (DummyGapStatus *)obj;
				DummyGapCell *cell = dummyGapStatus.cell;
				if (cell) {
					[cell.spinner startAnimating];
				}
				[self insertStatuses:dummyGapStatus.statusId - 1 insertPosition:indexPath.row];
			}
		}
	}
	else {
		[_tableView deselectRowAtIndexPath:indexPath animated:NO];
	}
	
	
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (statusIds.count == 0 
		|| isLoadCompleted == YES
		|| weiboClient != nil) { //没有数据，或者已经全部加载完毕，或者正在加载
		return;
	}
	lastOffset = scrollView.contentOffset;
	
	NSArray *indexPathes = [tableView indexPathsForVisibleRows];
	if (indexPathes.count > 0) {
		int rowCounts = [tableView numberOfRowsInSection:0];
		NSIndexPath *lastIndexPath = [indexPathes objectAtIndex:indexPathes.count - 1];
		if (rowCounts - lastIndexPath.row < 2) {
			[loadCell.spinner startAnimating];
			
			NSNumber* lastStatusKey = nil;
			for (int i = [statusIds count] - 1; i >= 0; --i) {
				NSNumber *statusKey = [statusIds objectAtIndex:i];
				if (statusKey && [statusKey isKindOfClass:[NSNumber class]]) {
					lastStatusKey = statusKey;
					break;
				}
			}
			if (lastStatusKey) {
				[self loadMoreStatuses:[lastStatusKey longLongValue] - 1];
			}
		}
	}
}

- (void)processTweetNode:(TweetNode *)node {
	[statusDataSourceDelegate processTweetNode:node];
}
						  

@end
