//
//  UserTabBarController.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-12.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "UserTabBarController.h"
#import "FriendsViewController.h"
#import "FollowersViewController.h"
#import "UserTimelineController.h"

@implementation UserTabBarController
//@synthesize userProfileViewController;
@synthesize user;
/*
- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		self.hidesBottomBarWhenPushed = YES;
	}
	return self;
}
*/
- (id)initWithoutNib {
	if(self = [super init]) {
		userProfileViewController = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
		userProfileViewController.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"资料" image:[UIImage imageNamed:@"person.png"] tag:0] autorelease];
		userProfileViewController.userTabBarController = self;
		friendsViewController = [[FriendsViewController alloc] initWithoutNib];
		friendsViewController.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"关注" image:[UIImage imageNamed:@"friends.png"]tag:0] autorelease];
		followersViewController = [[FollowersViewController alloc] initWithoutNib];
		followersViewController.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"粉丝" image:[UIImage imageNamed:@"followers.png"]tag:0] autorelease];
		userTimelineController = [[UserTimelineController alloc] initWithNibName:@"TimelineController" bundle:nil];
		userTimelineController.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"微博" image:[UIImage imageNamed:@"clock.png"]tag:0] autorelease];
		self.viewControllers = [NSArray arrayWithObjects:userProfileViewController,friendsViewController,followersViewController,userTimelineController,nil];
		self.hidesBottomBarWhenPushed = YES;
		
		//self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Top" style:UIBarButtonItemStylePlain target:self action:@selector(navigationToTop:)] autorelease];
	}
	return self;
}

- (void)viewDidLoad {
	userProfileViewController.userTabBarController = self;
}

- (void)dealloc {
	[userProfileViewController release];
	userProfileViewController = nil;
	[friendsViewController release];
	friendsViewController = nil;
	[followersViewController release];
	followersViewController = nil;
	[userTimelineController release];
	userTimelineController = nil;
	[user release];
	user = nil;
	[super dealloc];
}

- (void)setUser:(User *)_user {
	if (user != _user) {
		[user release];
		user = [_user retain];
		
		NSArray *views = self.viewControllers;
		for (int i = 0; i < [views count]; ++i) {
			UIViewController *c = [views objectAtIndex:i];
			if (c != userProfileViewController) {
				userProfileViewController.tabBarItem.enabled = user != nil;
			}
			if ([c respondsToSelector:@selector(setUser:)]) {
				[c performSelector:@selector(setUser:) withObject:user];
			}
		}
		 
	}
}
 

- (void)reset {
	self.selectedIndex = 0;
	self.user = nil;
	NSArray *views = self.viewControllers;
	for (int i = 0; i < [views count]; ++i) {
		UIViewController *c = [views objectAtIndex:i];
		if ([c respondsToSelector:@selector(reset)]) {
			[c performSelector:@selector(reset)];
		}
	}
}

- (void)loadUser:(User *)_user {
	[self reset];
	self.user = _user;
	[userProfileViewController loadUser:user];
}

- (void)loadUserByScreenName:(NSString *)screenName {
	[self reset];
	[userProfileViewController loadUserByScreenName:screenName];
}

- (void)navigationToTop:(id)sender {
	[self.navigationController  popToRootViewControllerAnimated:YES];
}

@end
