    //
//  DirectMessageController.m
//  ZhiWeibo
//
//  Created by junmin liu on 11-1-2.
//  Copyright 2011 Openlab. All rights reserved.
//

#import "DirectMessageController.h"
#import "DirectMessageDataSource_Phone.h"


@implementation DirectMessageController
@synthesize conversationController;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		//PullRefreshTableView *pullRefreshTableView = (PullRefreshTableView *)self.tableView;
		//dataSource = [[DirectMessageDataSource_Phone alloc]initWithTableView:pullRefreshTableView];
		//dataSource.directMessageDataSourceDelegate = self;
	}
	return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	PullRefreshTableView *pullRefreshTableView = (PullRefreshTableView *)self.tableView;
	self.dataSource.tableView = pullRefreshTableView;
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

- (void)viewWillAppear:(BOOL)animated {
	[self.dataSource.tableView reloadData];
}

- (void)dealloc {
	[dataSource release];
    [super dealloc];
}

- (void)autoRefresh {
	[self.dataSource loadRecentDirectMessages];
}

- (IBAction)refreshButtonTouch:(id)sender {
	[self autoRefresh];
}

- (IBAction)composeButtonTouch:(id)sender {
	//[self.navigationController presentModalViewController:composeView animated:YES];
	//[composeView composeNewTweet];
	[[ZhiWeiboAppDelegate getAppDelegate] newDM];
}

- (void)loadTimeline {
	[self.dataSource loadRecentDirectMessages];
}


- (void)saveData {
	[self.dataSource saveConversationsToLocal];
}

- (DirectMessageDataSource_Phone *)dataSource {
	if (dataSource) {
		return dataSource;
	}
	else {
		[dataSource release];
		PullRefreshTableView *pullRefreshTableView = (PullRefreshTableView *)self.tableView;
		dataSource = [[DirectMessageDataSource_Phone alloc]initWithTableView:pullRefreshTableView];
		dataSource.directMessageDataSourceDelegate = self;
		return dataSource;
	}
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

- (void)conversationSelected:(Conversation *)conversation {
	[self.navigationController pushViewController:conversationController animated:YES];
	conversationController.conversation = conversation;
	
}

-(void)sendDirectMessage:(DirectMessageDraft*)_draft {
	[dataSource sendDirectMessage:_draft];
}

-(void)reloadConversation {
	[conversationController reloadDataSource];
}

@end
