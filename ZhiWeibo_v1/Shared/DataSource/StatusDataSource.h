//
//  StatusDataSource.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-21.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboClient.h"
#import "PullRefreshTableView.h"
#import "PullRefreshTableViewDataSource.h"
#import "NSDictionaryAdditions.h"
#import "StatusCache.h"
#import "LoadMoreCell.h"
#import "DummyGapStatus.h"
#import "DummyGapCell.h"
#import "TweetNode.h"
#import "TweetCell.h"
#import "Reachability2.h"


@protocol StatusDataSourceDelegate

- (void)unreadMessagesCountChanged:(int)unreadMessageCount;

- (void)tweetSelected:(Status *)status;

- (void)processTweetNode:(TweetNode *)node;

@end


@interface StatusDataSource : PullRefreshTableViewDataSource<UITableViewDelegate, UITableViewDataSource,TweetCellDelegate> {
	WeiboClient *weiboClient;
	WeiboClient *getCommentsCountClient;
	NSMutableArray *statusIds;
	NSMutableArray *unreadStatusIds;
	NSMutableArray *syncCommentCountsStatusIdsQueue;
	LoadMoreCell *loadCell;
	
	BOOL hasUnreadStatus;
	BOOL isLoadCompleted;
	int downloadCount;
	int insertPosition;
	int maxStorageStatusCount;
	int unreadMessagesCount;
		
	NSString *userDefaultKeyForScrollTop;
	id<StatusDataSourceDelegate> statusDataSourceDelegate;
	CGPoint lastOffset;
}

@property (nonatomic, assign) id<StatusDataSourceDelegate> statusDataSourceDelegate;

- (void)loadCommentsCount;

- (void)loadTimeline;

- (void)loadStatusesFromLocal;

- (void)saveStatusesToLocal;

- (void)storageStatuses:(NSArray *)statuses;

- (void)loadRecentStatuses;

- (void)insertStatuses:(long long)maxStatusId 
		  insertPosition:(int)insertPos;

- (void)loadMoreStatuses:(long long)maxStatusId;

- (UITableViewCell *)getStatusTableViewCell:(UITableView *)_tableView status:(Status*)status;

- (CGFloat)getStatusTableViewCellHeight:(Status *)status;

- (void)stopLoading;

- (void)refreshTweetCell:(Status *)status;

@end
