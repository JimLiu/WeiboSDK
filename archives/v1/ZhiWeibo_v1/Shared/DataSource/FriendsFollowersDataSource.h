//
//  FriendsFollowersDataSource.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-12.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboClient.h"
#import "LoadMoreCell.h"
#import "UserCell.h"
#import "NSDictionaryAdditions.h"
#import "User.h"

@protocol FriendsFollowersDataSourceDelegate

- (void)userSelected:(User *)user;

@end

@interface FriendsFollowersDataSource : NSObject<UITableViewDelegate, UITableViewDataSource> {
	id<FriendsFollowersDataSourceDelegate> friendsFollowersDataSourceDelegate;
	UITableView *tableView;
	WeiboClient *weiboClient;
	NSMutableArray *users;
	LoadMoreCell *loadCell;
	BOOL isRestored;
	BOOL userLoaded;
	int insertPosition;
	int cursor;
	int downloadCount;
	int userId;	
}

@property (nonatomic, assign) int userId;
@property (nonatomic, assign) BOOL userLoaded;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, assign) id<FriendsFollowersDataSourceDelegate> friendsFollowersDataSourceDelegate;

- (id)initWithTableView:(UITableView *)_tableView ;

- (void)loadRecentUsers;

- (void)loadUsers:(int)userId;

- (void)loadMoreUsersAtPosition:(int)insertPos;

- (void)reset;


@end
