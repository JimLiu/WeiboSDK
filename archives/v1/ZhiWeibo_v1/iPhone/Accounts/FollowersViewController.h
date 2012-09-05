//
//  FollowersViewController.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-12.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FollowersDataSource.h"
#import "User.h"

@interface FollowersViewController : UITableViewController<FriendsFollowersDataSourceDelegate> {
	FollowersDataSource *dataSource;
	User *user;

}

@property (nonatomic, retain) User *user;

@end
