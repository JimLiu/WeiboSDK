//
//  TweetCommentsDataSource.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-28.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboClient.h"
#import "Status.h"
#import "NSDictionaryAdditions.h"
#import "LoadMoreCell.h"
#import "CommentCellViewDoc.h"
#import "TweetView.h"
#import "TweetCell.h"
#import "PullRefreshTableView.h"
#import "PullRefreshTableViewDataSource.h"
#import "Reachability2.h"

@protocol TweetCommentsDataSourceDelegate

- (void)commentSelected:(Comment *)comment;

@end

@interface TweetCommentsDataSource : PullRefreshTableViewDataSource<UITableViewDelegate, UITableViewDataSource> {
	WeiboClient *weiboClient;	
	NSMutableArray *comments;
	NSMutableDictionary *commentDocs;
	LoadMoreCell *loadCell;
	long long statusId;
	
	int currentPage;
	BOOL isRestored;
	int downloadCount;
	int insertPosition;
	
	id<TweetCommentsDataSourceDelegate> tweetCommentsDataSourceDelegate;
}

@property (nonatomic, assign) long long statusId;
@property (nonatomic, assign) id<TweetCommentsDataSourceDelegate> tweetCommentsDataSourceDelegate;

- (void)loadRecentComments;

- (void)loadComments;

- (void)reset;

@end
