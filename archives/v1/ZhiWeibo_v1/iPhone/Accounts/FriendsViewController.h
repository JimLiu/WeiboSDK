//
//  FriendsViewController.h
//  gZhiWeibo
//
//  Created by junmin liu on 10-12-12.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsDataSource.h"
#import "User.h"

@interface FriendsViewController : UITableViewController<FriendsFollowersDataSourceDelegate> {
	FriendsDataSource *dataSource;
	User *user;
}

@property (nonatomic, retain) User *user;

@end
