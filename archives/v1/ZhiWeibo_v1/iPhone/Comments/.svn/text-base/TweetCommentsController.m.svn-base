//
//  TweetCommentsController.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-28.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "TweetCommentsController.h"
#import "CommentViewController.h"

@implementation TweetCommentsController
@synthesize tableView;
@synthesize status;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

- (id)init {
	if(self = [super init]) {
		self.hidesBottomBarWhenPushed = YES;
		dataSource = [[TweetCommentsDataSource alloc]initWithTableView:tableView];
		dataSource.tweetCommentsDataSourceDelegate = self;
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		self.hidesBottomBarWhenPushed = YES;
		dataSource = [[TweetCommentsDataSource alloc]initWithTableView:tableView];
		dataSource.tweetCommentsDataSourceDelegate = self;
	}
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	dataSource.tableView = tableView;
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemReply
																							target: self action: @selector(reply:)] autorelease];

}

- (void)reply:(id)sender {
	[[ZhiWeiboAppDelegate getAppDelegate]replyTweet:status comment:nil];
}

- (void)viewWillAppear:(BOOL)animated {
	if (dataSource.statusId != status.statusId) {
		dataSource.statusId = status.statusId;
		[dataSource loadComments];
	}
	else {
		//[dataSource performSelector:@selector(loadRecentComments) withObject:nil afterDelay:1];
	}

}

- (void)viewWillDisappear:(BOOL)animated {
	//[dataSource reset];
	//[tableView reloadData];
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


- (void)dealloc {
	[dataSource release];
	[status release];
    [super dealloc];
}

- (void)commentSelected:(Comment *)comment_ {
	CommentViewController *cvc = [[[CommentViewController alloc] init] autorelease];
	cvc.comment = comment_;
	[self.navigationController pushViewController:cvc animated:YES];
}

@end
