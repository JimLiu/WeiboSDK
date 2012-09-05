//
//  MentionsTimelineController.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-20.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "MentionsTimelineController.h"
#import	"TweetViewController.h"
#import "WebViewController.h"
#import "UserTabBarController.h"
#import "TrendsTimelineController.h"
#import "PhotoViewController.h"
#import "RepostTimelineController.h"

@implementation MentionsTimelineController


#pragma mark -
#pragma mark Initialization


- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
		webViewController = [[WebViewController alloc] init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		webViewController = [[WebViewController alloc] init];
		//PullRefreshTableView *pullRefreshTableView = (PullRefreshTableView *)self.tableView;
		//dataSource = [[MentionsTimelineDataSource_Phone alloc]initWithTableView:pullRefreshTableView];
		//dataSource.statusDataSourceDelegate = self;		
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
	self.dataSource.tableView = pullRefreshTableView;
	//[self loadTimeline];
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
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



- (void)loadTimeline {
	[self.dataSource loadTimeline];
}

- (void)autoRefresh {
	[self.dataSource loadRecentStatuses];
}

- (void)saveData {
	[self.dataSource saveStatusesToLocal];
}

- (MentionsTimelineDataSource_Phone *)dataSource {
	if (dataSource) {
		return dataSource;
	}
	PullRefreshTableView *pullRefreshTableView = (PullRefreshTableView *)self.tableView;
	dataSource = [[MentionsTimelineDataSource_Phone alloc]initWithTableView:pullRefreshTableView];
	dataSource.statusDataSourceDelegate = self;
	return dataSource;
}

- (void)reset {
	[dataSource release];
	dataSource = nil;
	[self navigationController].tabBarItem.badgeValue = nil;
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
	TweetViewController *tweetView = [[[TweetViewController alloc] init] autorelease];
	tweetView.status = status;
	[self.navigationController pushViewController:tweetView animated:TRUE];
}

- (NSNumber*)getStatusIdFromString:(NSString*)_string index:(int)index {
	NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
	[f setNumberStyle:NSNumberFormatterDecimalStyle];
	NSNumber *sid = [f numberFromString:[_string substringFromIndex:index]];
	[f release];
	return sid;
}

- (void)processTweetNode:(TweetNode *)node {
	if ([node isKindOfClass:[TweetLinkNode class]]) {
		TweetLinkNode *linkNode = (TweetLinkNode*)node;
		NSString *command = linkNode.url;
		if ([command isMatchedByRegex:@"https?://[a-zA-Z0-9\\-.]+(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?"]) {
			[self.navigationController pushViewController:webViewController animated:YES];
			NSURL *url = [NSURL URLWithString:command];
			[webViewController loadUrl:url];
		}
		else if ([command hasPrefix:@"@"]) {
			UserTabBarController *userTabBarController = [[[UserTabBarController alloc] initWithoutNib] autorelease];
			[userTabBarController loadUserByScreenName:[command substringFromIndex:1]];
			[self.navigationController pushViewController:userTabBarController animated:YES];
		}
		else if ([command isMatchedByRegex:@"#[^#]+#"]) {
			NSString *trend = [command substringWithRange:NSMakeRange(1, command.length - 2)];
			TrendsTimelineController *c = [[[TrendsTimelineController alloc] initWithTrendsName:trend] autorelease];
			c.title = trend;
			[self.navigationController pushViewController:c animated:YES];
		}
		else if ([command hasPrefix:@"comment:"]) {
			Status *status = [StatusCache get:[self getStatusIdFromString:linkNode.url index:8]];
			TweetCommentsController *commentsController = [[[TweetCommentsController alloc] init] autorelease];
			commentsController.status = status;
			commentsController.title = @"评论列表";
			[self.navigationController pushViewController:commentsController animated:TRUE];
		}
		else if ([command hasPrefix:@"retweet:"]) {
			Status *status = [StatusCache get:[self getStatusIdFromString:linkNode.url index:8]];
			RepostTimelineController *repostTimelineController = [[[RepostTimelineController alloc] initWithNibName:@"TimelineController" bundle:nil] autorelease];
			[repostTimelineController setStatus:status.retweetedStatus];
			repostTimelineController.title = @"原文转发列表";
			[self.navigationController pushViewController:repostTimelineController animated:TRUE];
		}
		else if ([command hasPrefix:@"repostcomment:"]) {
			Status *status = [StatusCache get:[self getStatusIdFromString:linkNode.url index:14]];
			TweetCommentsController *commentsController = [[[TweetCommentsController alloc] init] autorelease];
			commentsController.status = status.retweetedStatus;
			commentsController.title = @"原文评论列表";
			[self.navigationController pushViewController:commentsController animated:TRUE];
		}
		else if ([command hasPrefix:@"repostretweet:"]) {
			Status *status = [StatusCache get:[self getStatusIdFromString:linkNode.url index:14]];
			RepostTimelineController *repostTimelineController = [[[RepostTimelineController alloc] initWithNibName:@"TimelineController" bundle:nil] autorelease];
			[repostTimelineController setStatus:status.retweetedStatus];
			repostTimelineController.title = @"原文转发列表";
			[self.navigationController pushViewController:repostTimelineController animated:TRUE];
		}
	}
	else if([node isKindOfClass:[TweetImageLinkNode class]]) {
		TweetImageLinkNode *linkNode = (TweetImageLinkNode*)node;
		if ([linkNode.url hasPrefix:@"photo:"]) {
			PhotoViewController *photoViewController = [[PhotoViewController alloc] init];
			photoViewController.hidesBottomBarWhenPushed = YES;
			Status *status = [StatusCache get:[self getStatusIdFromString:linkNode.url index:6]];
			Photo *p = [Photo photoWithStatus:status];
			[self.navigationController pushViewController:photoViewController animated:YES];
			[photoViewController showImage:p];
		}
	}
}

- (IBAction)refreshButtonTouch:(id)sender {
	[self autoRefresh];
}

- (IBAction)composeButtonTouch:(id)sender {
	//[self.navigationController presentModalViewController:composeView animated:YES];
	//[composeView composeNewTweet];
	[[ZhiWeiboAppDelegate getAppDelegate]composeNewTweet];
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
	[webViewController release];
	[dataSource release];
    [super dealloc];
}


@end

