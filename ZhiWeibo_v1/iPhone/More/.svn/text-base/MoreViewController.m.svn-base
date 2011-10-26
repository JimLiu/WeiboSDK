//
//  MoreViewController.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-20.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "MoreViewController.h"
#import "UserTabBarController.h"
#import "FavoritesTimelineController.h"
#import "DraftsViewController.h"
#import "ZhiWeiboAppDelegate.h"
#import "SearchViewController.h"
#import "AppDelegate_iPhone.h"


@implementation MoreViewController

#pragma mark -
#pragma mark Initialization


- (id)initWithCoder:(NSCoder *)aDecoder {
	if(self = [super initWithCoder:aDecoder]){
		searchViewControler = [[SearchViewController alloc] init];
		[self autoRefresh];
	}
	return self;
}

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.tableView reloadData];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)autoRefresh {
	if (weiboClient) {
		return;
	}
	weiboClient = [[WeiboClient alloc] initWithTarget:self action:@selector(unreadDidReceived:obj:)];
	[weiboClient getUnread];
}

- (void)unreadDidReceived:(WeiboClient*)sender obj:(NSObject*)obj {
	if (obj == nil || ![obj isKindOfClass:[NSDictionary class]]) {
		[weiboClient release];
		weiboClient = nil;
		return;
	}
	
	NSDictionary *dic = (NSDictionary*)obj;
	if (dic) {
		unreadFollowersCount = [[dic objectForKey:@"followers"] intValue];
		if (unreadFollowersCount != 0) {
			[self navigationController].tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", unreadFollowersCount];
		}
		else {
			[self navigationController].tabBarItem.badgeValue = nil;
		}

	}
	[weiboClient release];
	weiboClient = nil;
	[self.tableView reloadData];
}

- (void)resetUnread {
	if (resetUnreadWeiboClient || unreadFollowersCount <= 0) {
		return;
	}
	[self navigationController].tabBarItem.badgeValue = nil;
	unreadFollowersCount = 0;
	resetUnreadWeiboClient = [[WeiboClient alloc] initWithTarget:self action:@selector(resetDidReceived:obj:)];
	[resetUnreadWeiboClient resetUnreadFollowers];
}

- (void)resetDidReceived:(WeiboClient*)sender obj:(NSObject*)obj {
	if (obj == nil || ![obj isKindOfClass:[NSDictionary class]]) {
		[resetUnreadWeiboClient release];
		resetUnreadWeiboClient = nil;
		return;
	}
	NSDictionary *dic = (NSDictionary*)obj;
	NSNumber *value = [dic objectForKey:@"result"];
	if ([value boolValue]) {
		[resetUnreadWeiboClient release];
		resetUnreadWeiboClient = nil;
		return;
	}
	[resetUnreadWeiboClient resetUnreadFollowers];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
		return 2;
	}
	else if (section == 1) {
		return 3;
	}
	else if (section == 2) {
		return 1;
	}

	return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	if(indexPath.section == 0) {
		if(indexPath.row == 0) {
			cell.textLabel.text = @"我的资料";
			if (!unreadFollowersView) {
				unreadFollowersView = [[UILabel alloc] initWithFrame:CGRectMake(170, 10, 100, 30)];
				unreadFollowersView.font = [UIFont systemFontOfSize:14];
				
			}
			if (unreadFollowersCount != 0) {
				unreadFollowersView.text = [NSString stringWithFormat:@"有%d个新的好友",unreadFollowersCount];
				[cell addSubview:unreadFollowersView];
			}
			else {
				[unreadFollowersView removeFromSuperview];
			}

		}
		else if(indexPath.row == 1)
			cell.textLabel.text = @"我的收藏";
	}
	else if(indexPath.section == 1) {
		if(indexPath.row == 0){
			cell.textLabel.text = @"草稿箱";
		}
		else if(indexPath.row == 1) {
			cell.textLabel.text = @"搜索";
		}
		else if(indexPath.row == 2) {
			cell.textLabel.text = @"意见反馈";
		}


	}
	else if(indexPath.section == 2) {
		if(indexPath.row == 0){
			cell.textLabel.text = @"注销";
		}
	}

    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.section == 0 ) {
		if(indexPath.row == 0){
			UserTabBarController *u = [[[UserTabBarController alloc] initWithoutNib] autorelease];
			User *cu = [WeiboEngine getCurrentUser];
			[u loadUser:cu];
			if (unreadFollowersCount>0) {
				u.selectedIndex = 2;
			}
			[self resetUnread];
			[self.navigationController pushViewController:u animated:YES];
		}
		else if(indexPath.row == 1){
			FavoritesTimelineController *f = [[[FavoritesTimelineController alloc] initWithNibName:@"TimelineController" bundle:nil] autorelease];
			f.title = @"收藏夹";
			[self.navigationController pushViewController:f animated:YES];
		}
	}
	else if(indexPath.section == 1) {
		if (indexPath.row == 0) {
			DraftsViewController *d = [[[DraftsViewController alloc] init] autorelease];
			d.title = @"草稿箱";
			[self.navigationController pushViewController:d animated:YES];
		}
		else if(indexPath.row == 1) {
			[self.navigationController pushViewController:searchViewControler animated:YES];
		}
		else if(indexPath.row == 2) {
			[[AppDelegate_iPhone getAppDelegate] advise];
		}


	}
	else if(indexPath.section == 2) {
		if (indexPath.row == 0) {
			[[ZhiWeiboAppDelegate getAppDelegate] signOut];
		}
	}

}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	weiboClient.delegate = nil;
	resetUnreadWeiboClient.delegate = nil;
	[weiboClient cancel];
	[resetUnreadWeiboClient cancel];
	[resetUnreadWeiboClient release];
	[weiboClient release];
	[unreadFollowersView release];
	[searchViewControler release];
    [super dealloc];
}


@end

