//
//  SearchViewController.m
//  ZhiWeibo
//
//  Created by Zhang Jason on 1/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"
#import "TweetViewController.h"
#import "UserTabBarController.h"
#import "TrendsTimelineController.h"


@implementation SearchViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
		self.title = @"搜索";
		hotUserViewController = [[HotUserViewController alloc] initWithStyle:UITableViewStyleGrouped];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(hotStatusSelected:)
													 name:@"HotStatusSelected" object:nil];
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	if (!searchDataSource && !searchViewDataSource) {
		searchViewDataSource = [[SearchViewDataSource alloc] initWithTableView:tableView];
		searchDataSource = [[SearchDataSource alloc] initWithController:displayerController];
		[searchDataSource setSearchType:SearchTypeUser];
	}
	searchViewDataSource.tableView = tableView;
	searchDataSource.searchDisplayController = displayerController;
	searchViewDataSource.searchViewDelegate = self;
	searchDataSource.searchDataSourceDelegate = self;
	[self.view addSubview:searchBar];
	searchBar.frame = CGRectMake(0, 0, 320, 44);
	searchBar.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
	[searchViewDataSource loadRecent];
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
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
	[searchDataSource release];
	[hotUserViewController release];
	[statusKey release];
	[userKey release];
    [super dealloc];
}

- (void)searchBar:(UISearchBar *)_searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
	if (selectedScope == 0) {
		if (searchBar.text) {
			[statusKey release];
			statusKey = [[NSString alloc] initWithString:searchBar.text];
		}
		if (userKey) {
			searchBar.text = userKey;
		}
		[searchDataSource setSearchType:SearchTypeUser];
	}
	else if(selectedScope == 1) {
		if (searchBar.text) {
			[userKey release];
			userKey = [[NSString alloc] initWithString:searchBar.text];
		}
		if (statusKey) {
			searchBar.text = statusKey;
		}
		[searchDataSource setSearchType:SearchTypeStatus];
	}
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar {
	if (_searchBar.selectedScopeButtonIndex == 0) {
		[searchDataSource searchUserByName:_searchBar.text];
	}
	else if(_searchBar.selectedScopeButtonIndex == 1) {
		[searchDataSource searchStatusByName:_searchBar.text];
	}
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	return YES;
}

- (void)userSelected:(User *)user {
	UserTabBarController *c = [[[UserTabBarController alloc] initWithoutNib] autorelease];
	[c loadUser:user];
	[self.navigationController pushViewController:c animated:YES];
}

- (void)statusSelected:(Status *)status {
	TweetViewController *tweetView = [[[TweetViewController alloc] init] autorelease];
	tweetView.status = status;
	[self.navigationController pushViewController:tweetView animated:YES];
}

- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
	searchBar.hidden = YES;
}

- (void)searchBarSelected {
	searchBar.hidden = NO;
	[displayerController setActive:YES animated:YES];
	[searchBar becomeFirstResponder];
}

- (void)suggestionsSelected {
	[self.navigationController pushViewController:hotUserViewController animated:YES];
}

- (void)trendSelected:(NSString*)trend {
	TrendsTimelineController *t = [[[TrendsTimelineController alloc] initWithTrendsName:trend] autorelease];
	t.title = trend;
	[self.navigationController pushViewController:t animated:YES];
}

- (void)hotStatusSelected:(NSNotification*)aNotification {
	if (self.view.superview) {
		Status *s = (Status*)[aNotification object];
		TweetViewController *t = [[[TweetViewController alloc] init] autorelease];
		t.status = s;
		[self.navigationController pushViewController:t animated:YES];
	}
}

@end
