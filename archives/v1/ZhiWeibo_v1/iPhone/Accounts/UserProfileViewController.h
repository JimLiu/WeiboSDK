//
//  UserProfileViewController.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-11.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfileDataSource.h"
@class UserTabBarController;

@interface UserProfileViewController : UITableViewController<UserProfileDataSourceDelegate> {
	UserProfileDataSource *dataSource;
	User *user;
	UserTabBarController *userTabBarController;
}

@property (nonatomic, retain) User* user;
@property (nonatomic, assign) UserTabBarController *userTabBarController;

- (void)loadUser:(User *)user;
- (void)loadUserByScreenName:(NSString *)screenName;

@end
