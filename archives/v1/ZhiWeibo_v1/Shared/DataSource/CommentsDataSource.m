//
//  CommentsDataSource.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-11.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "CommentsDataSource.h"



@implementation CommentsDataSource
@synthesize commentsDataSourceDelegate;


- (id)initWithTableView:(PullRefreshTableView *)_tableView {
	if (self = [super initWithTableView:_tableView]) {
		weiboClient = nil;
		comments = [[NSMutableArray alloc]init];
		unreadCommentIds = [[NSMutableArray alloc]init];
		loadCell = [[LoadMoreCell alloc]initWithStyle:UITableViewStylePlain reuseIdentifier:@"LoadCell"];
		
		[self loadCommentsFromLocal];
		
		downloadCount = 50;
		maxStorageCommentCount = 500;
	}
	return self;
}

- (void)dealloc {
	[loadCell release];
	weiboClient.delegate = nil;
	[weiboClient release];
	[comments release];
	[unreadCommentIds release];
	[userDefaultKeyForScrollTop release];
	[super dealloc];
}

- (void)loadCommentsFromLocal {
	
}

- (void)saveCommentsToLocal {
	int i = 0;
	NSMutableArray *storagedComments = [NSMutableArray array];
	for (NSObject *comment in comments) {
		[storagedComments addObject:comment];
		i++;
		if (i >= maxStorageCommentCount) {
			break;
		}
	}
	[self storageComments:storagedComments];
}

- (void)storageComments:(NSArray *)comments {
}

- (void)loadRecentComments {
	
}

- (void)reloadTableViewDataSource{
	[self loadRecentComments];
}

- (void)loadTimeline {
	[tableView.refreshHeaderView setState:PullRefreshLoading];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.2];
	tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
	[UIView commitAnimations];	
	[self loadRecentComments];
	//[self reloadData];
}


- (void)loadMoreComments:(long long)maxCommentId {
	
}

- (void)insertComments:(long long)maxCommentId 
		insertPosition:(int)insertPos {
	
}

- (void)stopLoading {
	[weiboClient release];
	weiboClient = nil;
	[self doneLoadingTableViewData];
	[loadCell.spinner stopAnimating];
}


- (void)recentCommentsDidReceive:(WeiboClient*)sender obj:(NSObject*)obj
{
	BOOL needsScroll = comments.count > 0;
    if (sender.hasError) {
		NSLog(@"recentCommentsDidReceive error!!!, errorMessage:%@, errordetail:%@"
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
	long long lastSyncCommentId = 0;
	NSNumber* lastCommentKey = comments.count > 0 ? [[comments objectAtIndex:0] commentKey] : nil;
	NSArray *ary = (NSArray*)obj;    
	for (int i = [ary count] - 1; i >= 0; --i) {
		NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
		if (![dic isKindOfClass:[NSDictionary class]]) {
			continue;
		}
		long long commentId = [dic getLongLongValueValueForKey:@"id" defaultValue:-1];
		if (lastSyncCommentId == 0 || commentId < lastSyncCommentId) {
			lastSyncCommentId = commentId;
		}
		if (lastCommentKey 
			&& commentId <= [lastCommentKey longLongValue]) {
			// Ignore stale message
			continue;
		}
		Comment* comment = [Comment commentWithJsonDictionary:dic];
		//[CommentCache cache:sts];
		[comments insertObject:comment atIndex:0];
		if (needsScroll) {
			[unreadCommentIds addObject:comment.commentKey];
		}
		hasUnreadComment = YES;
		++unread;
		offset += [self getCommentTableViewCellHeight:tableView comment:comment];
	}
	
	
	if ([ary count] == downloadCount && lastCommentKey 
		&& (lastSyncCommentId > [lastCommentKey longLongValue])) { // 当前Load和上次存储的数据之间有空隙
		
		DummyGapStatus *dummyGapComment = [[DummyGapStatus alloc] initWithStatusId:lastSyncCommentId];
		[comments insertObject:dummyGapComment atIndex:insertPosition + unread];
		[dummyGapComment release];
		offset += 44;
	}
	
	[tableView reloadData];
	if (needsScroll) {
		[tableView setContentOffset:CGPointMake(0, offset)];
	}
	[tableView flashScrollIndicators];
	[self stopLoading];
	unreadMessagesCount = unreadCommentIds.count;
	if (commentsDataSourceDelegate) {
		[commentsDataSourceDelegate unreadMessagesCountChanged:unreadMessagesCount];
	}
}


- (void)moreCommentsDidReceive:(WeiboClient*)sender obj:(NSObject*)obj
{
    if (sender.hasError) {
		NSLog(@"moreCommentsDidReceive error!!!, errorMessage:%@, errordetail:%@"
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
	
	int insertPos = comments.count;
	NSNumber* firstCommentKey = nil;
	for (int i = [comments count] - 1; i >= 0; --i) {
		Comment *comment = [comments objectAtIndex:i];
		if (comment && [comment isKindOfClass:[Comment class]]) {
			firstCommentKey = comment.commentKey;
			break;
		}
	}
	NSArray *ary = (NSArray*)obj;    
	for (int i = [ary count] - 1; i >= 0; --i) {
		NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
		if (![dic isKindOfClass:[NSDictionary class]]) {
			continue;
		}
		long long commentId = [dic getLongLongValueValueForKey:@"id" defaultValue:-1];
		if (commentId <= 0
			|| (firstCommentKey && commentId >= [firstCommentKey longLongValue])) {
			// Ignore stale message
			continue;
		}
		Comment* comment = [Comment commentWithJsonDictionary:dic];
		//[CommentCache cache:comment];
		[comments insertObject:comment atIndex:insertPos];
		hasUnreadComment = YES;
	}
	if ([ary count] < downloadCount) { //全部下载完了
		isLoadCompleted = YES;
	}	
	[tableView reloadData];
	[tableView flashScrollIndicators];
	[self stopLoading];
}


- (void)insertCommentsDidReceive:(WeiboClient*)sender obj:(NSObject*)obj
{
    if (sender.hasError) {
		NSLog(@"insertCommentsDidReceive error!!!, errorMessage:%@, errordetail:%@"
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
	NSNumber* preCommentKey = nil;
	NSNumber* nextCommentKey = nil;
	for (int i = insertPosition - 1; i >= 0; --i) {
		Comment *comment = [comments objectAtIndex:i];
		if (comment && [comment isKindOfClass:[Comment class]]) {
			preCommentKey = comment.commentKey;
			break;
		}
	}
	for (int i = insertPosition + 1; i < comments.count; ++i) {
		Comment *comment = [comments objectAtIndex:i];
		if (comment && [comment isKindOfClass:[Comment class]]) {
			nextCommentKey = comment.commentKey;
			break;
		}
	}
	
	[comments removeObjectAtIndex:insertPosition]; // remove DummyGapComment
	
	int unread = 0;
	long long commentId;
	long long lastSyncCommentId = 0;
	NSArray *ary = (NSArray*)obj;    
	for (int i = [ary count] - 1; i >= 0; --i) {
		NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
		if (![dic isKindOfClass:[NSDictionary class]]) {
			continue;
		}
		commentId = [dic getLongLongValueValueForKey:@"id" defaultValue:-1];
		if (lastSyncCommentId == 0 || commentId < lastSyncCommentId) {
			lastSyncCommentId = commentId;
		}
		if (commentId <= 0
			|| (preCommentKey && commentId >= [preCommentKey longLongValue])
			|| (nextCommentKey && commentId <= [nextCommentKey longLongValue])) {
			// Ignore stale message
			continue;
		}
		Comment* comment = [Comment commentWithJsonDictionary:dic];
		//[CommentCache cache:comment];
		[comments insertObject:comment atIndex:insertPosition];
		hasUnreadComment = YES;
		unread++;
		offset += [self getCommentTableViewCellHeight:tableView comment:comment];
	}
	
	if ([ary count] == downloadCount && nextCommentKey 
		&& (lastSyncCommentId > [nextCommentKey longLongValue])) { // 当前Load和上次存储的数据之间有空隙
		
		DummyGapStatus *dummyGapComment = [[DummyGapStatus alloc] initWithStatusId:lastSyncCommentId];
		[comments insertObject:dummyGapComment atIndex:insertPosition + unread];
		[dummyGapComment release];	
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
    return isLoadCompleted == YES ? [comments count] : [comments count] + 1;
}


- (UITableViewCell *)getCommentTableViewCell:(UITableView *)_tableView comment:(Comment*)comment {
	return nil;
}

- (CGFloat)getCommentTableViewCellHeight:(UITableView *)_tableView 
								comment:(Comment*)comment {
	return 60;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < comments.count) {
		id obj = [comments objectAtIndex:indexPath.row];
		if (obj) {
			if ([obj isKindOfClass:[Comment class]]) {
				Comment *comment = (Comment *)obj;
				[unreadCommentIds removeObject:comment.commentKey];
				return [self getCommentTableViewCell:_tableView comment:comment];
			}
			else if ([obj isKindOfClass:[DummyGapStatus class]]) {
				static NSString *CellIdentifier = @"DummyGapCell";
				DummyGapCell *cell = (DummyGapCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
				if (cell == nil) {
					cell = [[[DummyGapCell alloc] initWithStyle:UITableViewCellStyleDefault 
												reuseIdentifier:CellIdentifier] autorelease];
				}
				DummyGapStatus *dummyGapComment = (DummyGapStatus *)obj;
				[cell.spinner stopAnimating];
				cell.dummyGapStatus = dummyGapComment;
				return cell;
			}
			
		}
	}
    
    return loadCell;
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < comments.count) {
		id obj = [comments objectAtIndex:indexPath.row];
		if (obj) {
			if ([obj isKindOfClass:[Comment class]]) {
				Comment *comment = (Comment *)obj;
				return [self getCommentTableViewCellHeight:_tableView comment:comment];
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
	long long endCommentId = -1;
	NSIndexPath *indexPath = [indexPaths objectAtIndex:indexPaths.count - 1];
	if (indexPath.row < comments.count) {
		id obj = [comments objectAtIndex:indexPath.row];
		if (obj) {
			if ([obj isKindOfClass:[Comment class]]) {
				Comment *comment = (Comment *)obj;
				endCommentId = comment.commentId;
			}
			else if ([obj isKindOfClass:[DummyGapStatus class]]) {
				DummyGapStatus *dummyGapComment = (DummyGapStatus *)obj;
				endCommentId = dummyGapComment.statusId;
			}
		}
	}
	if (endCommentId > 0) {
		for (int i = unreadCommentIds.count - 1; i >= 0; i--) {
			long long sid = [[unreadCommentIds objectAtIndex:i] longLongValue];
			if (sid <= endCommentId) {
				[unreadCommentIds removeObjectAtIndex:i];
			}
		}
	}
	
	if (unreadMessagesCount != unreadCommentIds.count) {
		unreadMessagesCount = unreadCommentIds.count;
		if (commentsDataSourceDelegate) {
			[commentsDataSourceDelegate unreadMessagesCountChanged:unreadMessagesCount];
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
	[unreadCommentIds removeAllObjects];
	if (unreadMessagesCount != 0) {
		unreadMessagesCount = 0;
		if (commentsDataSourceDelegate) {
			[commentsDataSourceDelegate unreadMessagesCountChanged:unreadMessagesCount];
		}			
	}
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < comments.count) {
		id obj = [comments objectAtIndex:indexPath.row];
		if (obj) {
			if ([obj isKindOfClass:[Comment class]]) {
				Comment *comment = (Comment *)obj;
				if (comment) {
					if (commentsDataSourceDelegate) {
						[commentsDataSourceDelegate commentSelected:comment];
					}
				}
				
			}
			else if ([obj isKindOfClass:[DummyGapStatus class]]) {
				DummyGapStatus *dummyGapComment = (DummyGapStatus *)obj;
				DummyGapCell *cell = dummyGapComment.cell;
				if (cell) {
					[cell.spinner startAnimating];
				}
				[self insertComments:dummyGapComment.statusId - 1 insertPosition:indexPath.row];
			}
		}
	}
	else {
		[_tableView deselectRowAtIndexPath:indexPath animated:NO];
	}
	
	
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (comments.count == 0 
		|| isLoadCompleted == YES
		|| weiboClient != nil) { //没有数据，或者已经全部加载完毕，或者正在加载
		return;
	}
	NSArray *indexPathes = [tableView indexPathsForVisibleRows];
	if (indexPathes.count > 0) {
		int rowCounts = [tableView numberOfRowsInSection:0];
		NSIndexPath *lastIndexPath = [indexPathes objectAtIndex:indexPathes.count - 1];
		if (rowCounts - lastIndexPath.row < 2) {
			[loadCell.spinner startAnimating];
			
			NSNumber* lastCommentKey = nil;
			for (int i = [comments count] - 1; i >= 0; --i) {
				Comment *comment = [comments objectAtIndex:i];
				if (comment && [comment isKindOfClass:[Comment class]]) {
					lastCommentKey = comment.commentKey;
					break;
				}
			}
			if (lastCommentKey) {
				[self loadMoreComments:[lastCommentKey longLongValue] - 1];
			}
		}
	}
}


- (void)processTweetNode:(TweetNode *)node {
	[commentsDataSourceDelegate processTweetNode:node];
}



@end
