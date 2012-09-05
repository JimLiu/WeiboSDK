//
//  UserProfileViewController.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-11.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "UserProfileViewController.h"


@implementation UserProfileViewController
@synthesize user;
@synthesize userTabBarController;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dataSource = [[UserProfileDataSource alloc]initWithTableView:self.tableView];
		dataSource.dataSourceDelegate = self;
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		dataSource = [[UserProfileDataSource alloc]initWithTableView:self.tableView];
		dataSource.dataSourceDelegate = self;
	}
	return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	dataSource.tableView = self.tableView;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)setUser:(User *)_user {
	if (user != _user) {
		[user release];
		user = [_user retain];
	}
}

- (void)userLoaded:(User *)_user {
	self.user = _user;
	[userTabBarController setUser:_user];
}

- (void)loadUserByScreenName:(NSString *)screenName {
	self.parentViewController.title = screenName;
	[dataSource loadUserByScreenName:screenName];
}

- (void)loadUser:(User *)_user {
	self.user = _user;
	self.parentViewController.title = _user.screenName;
	[dataSource loadUser:_user];
}

- (void)showFriends {
	self.tabBarController.selectedIndex = 1;
}

- (void)showFollowers {
	self.tabBarController.selectedIndex = 2;
}

- (void)showStatus {
	self.tabBarController.selectedIndex = 3;
}

- (void)dealloc {
	[dataSource release];
    [super dealloc];
}


@end
