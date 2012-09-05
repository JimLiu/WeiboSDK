//
//  PullRefreshTableViewDataSource.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-21.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "PullRefreshTableViewDataSource.h"


@interface PullRefreshTableViewDataSource (private)

- (void)dataSourceDidFinishLoadingNewData;

@end


@implementation PullRefreshTableViewDataSource
@synthesize reloading=_reloading;
@synthesize tableView;

- (id)initWithTableView:(PullRefreshTableView *)_tableView {
	if ((self = [super init])) {		
		tableView = [_tableView retain];
		tableView.delegate = self;
		tableView.dataSource = self;
		tableView.separatorColor = [UIColor redColor];
		tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	}
	return self;
}

- (void)setTableView:(PullRefreshTableView *)_tableView {
	if (tableView != _tableView) {
		[tableView release];
		tableView = [_tableView retain];
		tableView.dataSource = self;
		tableView.delegate = self;
		[tableView reloadData];
	}
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	[tableView release];
	[super dealloc];
}

#pragma mark Table view methods

- (void)reloadTableViewDataSource{
	
}


- (void)doneLoadingTableViewData {
	//  model should call this when its done loading
	[self dataSourceDidFinishLoadingNewData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	if (scrollView.isDragging) {
		if (tableView.refreshHeaderView.state == PullRefreshPulling 
			&& scrollView.contentOffset.y > -65.0f 
			&& scrollView.contentOffset.y < 0.0f 
			&& !_reloading) {
			[tableView.refreshHeaderView setState:PullRefreshNormal];
		} else if (tableView.refreshHeaderView.state == PullRefreshNormal 
				   && scrollView.contentOffset.y < -65.0f 
				   && !_reloading) {
			[tableView.refreshHeaderView setState:PullRefreshPulling];
		}
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	
	if (scrollView.contentOffset.y <= - 65.0f && !_reloading) {
		_reloading = YES;
		[self reloadTableViewDataSource];
		[tableView.refreshHeaderView setState:PullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
	}
}

- (void)dataSourceDidFinishLoadingNewData{
	
	_reloading = NO;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[tableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[tableView.refreshHeaderView setState:PullRefreshNormal];
	[tableView.refreshHeaderView setCurrentDate];  //  should check if data reload was successful 
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

@end
