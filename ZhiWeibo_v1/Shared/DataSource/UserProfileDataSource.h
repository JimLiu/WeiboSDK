//
//  UserProfileDataSource.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-11.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboClient.h"
#import "User.h"
#import "UserProfileHeaderView.h"

@protocol UserProfileDataSourceDelegate

- (void)userLoaded:(User*)_user;

- (void)showFollowers;

- (void)showFriends;

- (void)showStatus;

@end


typedef enum {
	UserProfileLoading,
	UserProfileLoadFailed,
	UserProfileLoadSuccessful,
} UserProfileLoadStatus;

@interface UserProfileDataSource : NSObject<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate> {
	WeiboClient *loadUserClient;
	WeiboClient *loadFriendshipClient;
	WeiboClient *followClient;
	UITableView *tableView;
	
	UserProfileLoadStatus loadStatus;
	BOOL needsCheckFriendship;
	NSString *errorMessage;
	
	UserProfileHeaderView *userProfileHeaderView;
	UIFont *detailCellFont;
	UIFont *cellFont;

	id<UserProfileDataSourceDelegate> dataSourceDelegate;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) User *user;
@property (nonatomic, assign) id<UserProfileDataSourceDelegate> dataSourceDelegate;

- (id)initWithTableView:(UITableView *)_userTableView;


- (void)loadUserByUserId:(int)userId;
- (void)loadUserByScreenName:(NSString *)screenName;
- (void)loadUser:(User *)_user;

@end
