//
//  UserTabBarController.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-12.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "UserProfileViewController.h"

@class FriendsViewController;
@class FollowersViewController;
@class UserTimelineController;
@interface UserTabBarController : UITabBarController {
	UserProfileViewController *userProfileViewController;
	FriendsViewController *friendsViewController;
	FollowersViewController *followersViewController;
	UserTimelineController *userTimelineController;
	User *user;
}

@property (nonatomic, retain) User *user;
//@property (nonatomic, retain) IBOutlet UserProfileViewController *userProfileViewController;

- (void)loadUser:(User *)user;
- (void)loadUserByScreenName:(NSString *)screenName;

- (id)initWithoutNib;
- (void)navigationToTop:(id)sender;


@end
