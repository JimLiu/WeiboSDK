//
//  FollowersDataSource.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-12.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "FollowersDataSource.h"


@implementation FollowersDataSource

- (void)loadRecentUsers {
	
	if (weiboClient || userId <= 0) { 
		return;
	}
	insertPosition = 0;
	weiboClient = [[WeiboClient alloc] initWithTarget:self 
											   action:@selector(usersDidReceive:obj:)];
	[weiboClient getFollowers:userId cursor:0 count:downloadCount];
	
}



- (void)loadMoreUsersAtPosition:(int)insertPos {
	if (weiboClient) { 
		[weiboClient release];
		weiboClient = nil;
	}		 
	insertPosition = insertPos;
	[loadCell.spinner startAnimating];
	weiboClient = [[WeiboClient alloc] initWithTarget:self 
											   action:@selector(usersDidReceive:obj:)];
	[weiboClient getFollowers:userId cursor:cursor count:downloadCount];
	
}


@end
