//
//  CommentsTimelineDataSource.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-11.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "CommentsTimelineDataSource.h"
#import "ImageCache.h"

@implementation CommentsTimelineDataSource

- (void)loadCommentsFromLocal {
	NSString *filePath = [WeiboEngine getCurrentUserStoreagePath:@"commentsTimeline.db"];
	NSMutableArray* storagedComments = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
	if (storagedComments) {
		[comments release];
		comments = [storagedComments retain];
	}
}

- (void)storageComments:(NSArray *)_comments {
	NSString *filePath = [WeiboEngine getCurrentUserStoreagePath:@"commentsTimeline.db"];
	[NSKeyedArchiver archiveRootObject:_comments toFile:filePath];
}

- (void)loadRecentComments {
    if (weiboClient) { 
		//[self doneLoadingTableViewData];
		return;
	}
	NetworkStatus connectionStatus = [[Reachability2 sharedReachability] internetConnectionStatus];
	downloadCount = (connectionStatus == ReachableViaWiFiNetwork) ? 100 : 50;

    long long since_id = 0;
	if (comments.count > 0) {
		Comment* comment = [comments objectAtIndex:0];
        if (comment && [comment isKindOfClass:[Comment class]]) {
            since_id = [comment.commentKey longLongValue];
        }
	}	
	insertPosition = 0;
	weiboClient = [[WeiboClient alloc] initWithTarget:self
											   action:@selector(recentCommentsDidReceive:obj:)];
	[weiboClient getCommentsTimelineSinceID:since_id startingAtPage:0 count:downloadCount];
}

- (void)insertComments:(long long)maxCommentId 
		insertPosition:(int)insertPos {
	if (weiboClient) { 
		[self doneLoadingTableViewData];
		[weiboClient release];
		weiboClient = nil;
	}
	insertPosition = insertPos;
	weiboClient = [[WeiboClient alloc] initWithTarget:self 
											   action:@selector(insertCommentsDidReceive:obj:)];
	[weiboClient getCommentsTimelineMaximumID:maxCommentId startingAtPage:0 count:downloadCount];	
	
}

- (void)loadMoreComments:(long long)maxCommentId {
	if (weiboClient) { 
		[self doneLoadingTableViewData];
		[weiboClient release];
		weiboClient = nil;
	}
	insertPosition = comments.count;
	weiboClient = [[WeiboClient alloc] initWithTarget:self 
											   action:@selector(moreCommentsDidReceive:obj:)];
	[weiboClient getCommentsTimelineMaximumID:maxCommentId startingAtPage:0 count:downloadCount];	
}



@end
