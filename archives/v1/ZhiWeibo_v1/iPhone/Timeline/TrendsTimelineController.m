    //
//  TrendsTimelineController.m
//  ZhiWeibo
//
//  Created by Zhang Jason on 12/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TrendsTimelineController.h"


@implementation TrendsTimelineController
@synthesize tweetView;

#pragma mark -
#pragma mark Initialization

/*
 - (id)initWithStyle:(UITableViewStyle)style {
 // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 if ((self = [super initWithStyle:style])) {
 }
 return self;
 }
 */

- (id)initWithTrendsName:(NSString *)trendsName {
	if (self = [super initWithNibName:@"TimelineController" bundle:nil]) {
		PullRefreshTableView *pullRefreshTableView = (PullRefreshTableView *)self.tableView;
		dataSource = [[TrendsTimelineDataSource_Phone alloc]initWithTableView:pullRefreshTableView];
		dataSource.statusDataSourceDelegate = self;	
		dataSource.trends_name = trendsName;
		self.hidesBottomBarWhenPushed = YES;
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		PullRefreshTableView *pullRefreshTableView = (PullRefreshTableView *)self.tableView;
		dataSource = [[TrendsTimelineDataSource_Phone alloc]initWithTableView:pullRefreshTableView];
		dataSource.statusDataSourceDelegate = self;
		self.hidesBottomBarWhenPushed = YES;
	}
	return self;
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	PullRefreshTableView *pullRefreshTableView = (PullRefreshTableView *)self.tableView;
	dataSource.tableView = pullRefreshTableView;
	//[self loadTimeline];
}



- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self loadTimeline];
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

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}



- (void)autoRefresh {
	[dataSource loadRecentStatuses];
}
/*
 - (IBAction)refreshButtonTouch:(id)sender {
 [self autoRefresh];
 }
 
 - (IBAction)composeButtonTouch:(id)sender {
 //[self.navigationController presentModalViewController:composeView animated:YES];
 //[composeView composeNewTweet];
 [[ZhiWeiboAppDelegate getAppDelegate]composeNewTweet];
 }
 */
- (void)loadTimeline {
	[dataSource loadTimeline];
}


- (void)saveData {
	//[dataSource saveStatusesToLocal];
}

- (void)unreadMessagesCountChanged:(int)unreadMessageCount {
	if (unreadMessageCount == 0) {
		[self navigationController].tabBarItem.badgeValue = nil;
	}
	else {
		[self navigationController].tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", unreadMessageCount];
	}
}

- (void)tweetSelected:(Status *)status {
	tweetView = [[[TweetViewController alloc] initWithNibName:@"TweetViewController" bundle:nil] autorelease];
	tweetView.status = status;
	[self.navigationController pushViewController:tweetView animated:TRUE];
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
	[dataSource release];
    [super dealloc];
}

@end
