//
//  FriendsDataSource.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-12.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "FriendsDataSource.h"


@implementation FriendsDataSource

- (void)loadRecentUsers {
	
	if (weiboClient || userId <= 0) { 
		return;
	}
	insertPosition = 0;
	weiboClient = [[WeiboClient alloc] initWithTarget:self 
											   action:@selector(usersDidReceive:obj:)];
	[weiboClient getFriends:userId cursor:0 count:downloadCount];
	[loadCell.spinner startAnimating];
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
	[weiboClient getFriends:userId cursor:cursor count:downloadCount];
	[loadCell.spinner startAnimating];
}


@end
