//
//  CommentsDataSource.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-11.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboClient.h"
#import "PullRefreshTableView.h"
#import "PullRefreshTableViewDataSource.h"
#import "NSDictionaryAdditions.h"
#import "LoadMoreCell.h"
#import "DummyGapStatus.h"
#import "DummyGapCell.h"
#import "Comment.h"
#import "TweetNode.h"
#import "TweetCell.h"
#import "Reachability2.h"

@protocol CommentsDataSourceDelegate

- (void)unreadMessagesCountChanged:(int)unreadMessageCount;

- (void)commentSelected:(Comment *)comment;

- (void)processTweetNode:(TweetNode *)node;

@end

@interface CommentsDataSource : PullRefreshTableViewDataSource<UITableViewDelegate, UITableViewDataSource,TweetCellDelegate> {
	WeiboClient *weiboClient;
	NSMutableArray *comments;
	NSMutableArray *unreadCommentIds;
	LoadMoreCell *loadCell;
	
	BOOL hasUnreadComment;
	BOOL isLoadCompleted;
	int downloadCount;
	int insertPosition;
	int maxStorageCommentCount;
	int unreadMessagesCount;
	
	NSString *userDefaultKeyForScrollTop;
	id<CommentsDataSourceDelegate> commentsDataSourceDelegate;
	
}

@property (nonatomic, assign) id<CommentsDataSourceDelegate> commentsDataSourceDelegate;

- (void)loadTimeline;

- (void)loadCommentsFromLocal;

- (void)saveCommentsToLocal;

- (void)storageComments:(NSArray *)statuses;

- (void)loadRecentComments;

- (void)insertComments:(long long)maxCommentId 
		insertPosition:(int)insertPos;

- (void)loadMoreComments:(long long)maxCommentId;

- (UITableViewCell *)getCommentTableViewCell:(UITableView *)_tableView 
									  comment:(Comment*)comment;

- (CGFloat)getCommentTableViewCellHeight:(UITableView *)_tableView 
								comment:(Comment*)comment;

@end
