//
//  SearchDataSource.m
//  ZhiWeibo
//
//  Created by Zhang Jason on 1/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchDataSource.h"
#import "UserCell.h"
#import "Status.h"
#import "StatusCell.h"


@implementation SearchDataSource

@synthesize searchDataSourceDelegate;
@synthesize searchDisplayController;


- (id)initWithController:(UISearchDisplayController *)_searchDisplayController {
	self = [super init];
	if (self) {
		searchDisplayController = [_searchDisplayController retain];
		searchDisplayController.searchResultsDelegate = self;
		searchDisplayController.searchResultsDataSource = self;
		weiboClient = nil;
		userResults = [[NSMutableArray alloc]init];
		statusResults = [[NSMutableArray alloc] init];
		loadCell = [[LoadMoreCell alloc]initWithStyle:UITableViewStylePlain reuseIdentifier:@"LoadCell"];
		[loadCell.spinner startAnimating];
		downloadCount = 20;	
		userIsRestored = YES;
		statusIsRestored = YES;
	}
	return self;
}

- (void)setSearchDisplayController:(UISearchDisplayController *)_contorller {
	if (_contorller != searchDisplayController) {
		[searchDisplayController release];
		searchDisplayController = [_contorller retain];
		searchDisplayController.searchResultsDelegate = self;
		searchDisplayController.searchResultsDataSource = self;
	}	
}

- (void)stopLoading {
	weiboClient.delegate = nil;
	[weiboClient release];
	[loadCell.spinner stopAnimating];
	weiboClient = nil;
}

- (void)dealloc {
	[self stopLoading];
	[userKey release];
	[statusKey release];
	[userResults release];
	[statusResults release];
	[searchDisplayController release];
	[loadCell release];
	[super dealloc];
}

- (void)setSearchType:(SearchType)type {
	searchType = type;
	[self stopLoading];
	[searchDisplayController.searchResultsTableView reloadData];
}

- (void)searchUserByName:(NSString*)name {
	if (weiboClient) {
		[self stopLoading];
	}
	[userResults removeAllObjects];
	weiboClient = [[WeiboClient alloc] initWithTarget:self 
											   action:@selector(usersDidReceive:obj:)];
	[weiboClient getUserTimelineByName:name page:0 count:downloadCount];
	[loadCell.spinner startAnimating];
	userIsRestored = NO;
	[userKey release];
	userKey = [[NSString alloc] initWithString:name];
	[searchDisplayController.searchResultsTableView reloadData];
	//NSLog(@"%@",tableView);
}

- (void)moreUser {
	if (weiboClient) {
		[self stopLoading];
	}
	weiboClient = [[WeiboClient alloc] initWithTarget:self 
											   action:@selector(usersDidReceive:obj:)];
	[weiboClient getUserTimelineByName:userKey page:(userResults.count / downloadCount) + 1 count:downloadCount];
	[loadCell.spinner startAnimating];
	userIsRestored = NO;
	[searchDisplayController.searchResultsTableView reloadData];
}

- (void)usersDidReceive:(WeiboClient*)sender obj:(NSObject*)obj
{
    if (sender.hasError) {
		NSLog(@"usersDidReceive error!!!, errorMessage:%@, errordetail:%@"
			  , sender.errorMessage, sender.errorDetail);
        if (sender.statusCode == 401) {
            ZhiWeiboAppDelegate *appDelegate = [ZhiWeiboAppDelegate getAppDelegate];
            [appDelegate openAuthenticateView];
        }
        [sender alert];
    }
	
    if (obj == nil || ![obj isKindOfClass:[NSArray class]]) {
		[self stopLoading];
        return;
    }
	
	NSArray *ary = (NSArray*)obj;    
	if (!ary || ![ary isKindOfClass:[NSArray class]]) {
		[self stopLoading];
		return;
	}

	BOOL isNew = YES;
	for (int i = 0; i < [ary count]; i++) {
		NSDictionary *dic1 = (NSDictionary*)[ary objectAtIndex:i];
		if (![dic1 isKindOfClass:[NSDictionary class]]) {
			continue;
		}
		User* user = [User userWithJsonDictionary:[ary objectAtIndex:i]];
		if (!isNew || i == 0) {
			for (User *_user in userResults) {
				if (_user.userId == user.userId) {
					isNew = NO;
					break;
				}
			}
		}
		if(isNew) {
			[userResults addObject:user];
		}
	}
	
	if ([ary count] == 0) {
		userIsRestored = YES;
	}
	
	[searchDisplayController.searchResultsTableView reloadData];
	[self stopLoading];
}

- (void)searchStatusByName:(NSString*)name {
	if (weiboClient) {
		[self stopLoading];
	}
	[statusResults removeAllObjects];
	weiboClient = [[WeiboClient alloc] initWithTarget:self 
											   action:@selector(statusDidReceive:obj:)];
	[weiboClient getStatusTimelineByName:name startTime:0 endTime:0 page:0 count:downloadCount];
	[loadCell.spinner startAnimating];
	statusIsRestored = NO;
	[statusKey release];
	statusKey = [name retain];
	[searchDisplayController.searchResultsTableView reloadData];
}

- (void)moreStatus {
	if (weiboClient) {
		[self stopLoading];
	}
	weiboClient = [[WeiboClient alloc] initWithTarget:self 
											   action:@selector(statusDidReceive:obj:)];
	//unsigned long long a = [[statusResults objectAtIndex:statusResults.count - 1] createdAt];
	[weiboClient getStatusTimelineByName:statusKey startTime:0 endTime:[[statusResults objectAtIndex:statusResults.count - 1] createdAt] page:page count:downloadCount];
	[loadCell.spinner startAnimating];
	[searchDisplayController.searchResultsTableView reloadData];
}

- (void)statusDidReceive:(WeiboClient*)sender obj:(NSObject*)obj
{
    if (sender.hasError) {
		NSLog(@"usersDidReceive error!!!, errorMessage:%@, errordetail:%@"
			  , sender.errorMessage, sender.errorDetail);
        if (sender.statusCode == 401) {
            ZhiWeiboAppDelegate *appDelegate = [ZhiWeiboAppDelegate getAppDelegate];
            [appDelegate openAuthenticateView];
        }
        [sender alert];
    }
	
    if (obj == nil || ![obj isKindOfClass:[NSArray class]]) {
		[self stopLoading];
        return;
    }
	
	NSArray *ary = (NSArray*)obj;    
	if (!ary || ![ary isKindOfClass:[NSArray class]]) {
		[self stopLoading];
		return;
	}
	
	BOOL hasNew = NO;
	BOOL isNew = NO;
	for (int i = 0; i < [ary count]; i++) {
		NSDictionary *dic1 = (NSDictionary*)[ary objectAtIndex:i];
		if (![dic1 isKindOfClass:[NSDictionary class]]) {
			continue;
		}
		Status* status = [Status statusWithJsonDictionary:[ary objectAtIndex:i]];
		if (isNew == NO && statusResults.count > 0) {
			if (status.createdAt < [[statusResults objectAtIndex:statusResults.count - 1] createdAt]) {
				isNew = YES;
				[statusResults addObject:status];
				hasNew = YES;
				page = 0;
			}
			else {
				for (int i = statusResults.count - 1; i >= 0; i--) {
					if (status.createdAt == [[statusResults objectAtIndex:i] createdAt]) {
						if (status.statusId != [[statusResults objectAtIndex:i] statusId]) {
							[statusResults addObject:status];
							hasNew = YES;
							page = 0;
						}
					}
					else {
						[statusResults addObject:status];
						hasNew = YES;
						page = 0;
						break;
					}

				}
			}
		}
		else {
			[statusResults addObject:status];
			hasNew = YES;
			page = 0;
		}

	}
	
	if (!hasNew) {
		page++;
	}
	
	if ([ary count] == 0) {
		statusIsRestored = YES;
	}
	
	[searchDisplayController.searchResultsTableView reloadData];
	[self stopLoading];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (searchType == SearchTypeUser) {
		return userIsRestored == YES ? [userResults count] : [userResults count] + 1;
	}
	else if (searchType == SearchTypeStatus) {
		return statusIsRestored == YES ? [statusResults count] : [statusResults count] + 1;
	}
	return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (searchType == SearchTypeUser) {
		if (indexPath.row < userResults.count) {
			User *user = (User *)[userResults objectAtIndex:indexPath.row];
			static NSString *UserCellIdentifier = @"UserCell";
			UserCell *cell = (UserCell *)[_tableView dequeueReusableCellWithIdentifier:UserCellIdentifier];
			if (cell == nil) {
				cell = [[[UserCell alloc] initWithStyle:UITableViewCellStyleDefault 
										reuseIdentifier:UserCellIdentifier] autorelease];
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
			cell.user = user;
			return cell;
		}
	}
	else if (searchType == SearchTypeStatus) {
		if (indexPath.row < statusResults.count) {
			static NSString *StatusCellIdentifier = @"StatusCell";
			Status *status = (Status *)[statusResults objectAtIndex:indexPath.row];
			StatusCell *cell = (StatusCell *)[_tableView dequeueReusableCellWithIdentifier:StatusCellIdentifier];
			if (cell == nil) {
				cell = [[[StatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:StatusCellIdentifier] autorelease];
			}
			
			cell.status = status;
			
			return cell;
		}
	}
    
    return loadCell;
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (searchType == SearchTypeUser) {
		if (indexPath.row < userResults.count) {
			return 60;
		}
	}
	else if(searchType == SearchTypeStatus) {
		if (indexPath.row < statusResults.count) {
			Status *status = (Status *)[statusResults objectAtIndex:indexPath.row];
			StatusLayout *layout = [StatusLayout layoutWithStatus:status width:searchDisplayController.searchResultsTableView.frame.size.width];
			CGFloat height = layout.height;
			if (height < 44) {
				height = 44;
			}
			return height;
		}
	}
	return 48;
}


#pragma mark -
#pragma mark Table view delegate


- (void)tableView:(UITableView *)_tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (searchType == SearchTypeUser) {
		if (indexPath.row == userResults.count) {
			if (![loadCell.spinner isAnimating]) {
				[self moreUser];
			}
		}
		else {
			if (indexPath.row < userResults.count) {
				User *user = [userResults objectAtIndex:indexPath.row];
				[searchDataSourceDelegate userSelected:user];
			}
		}

	}
	else if(searchType == SearchTypeStatus) {
		if (indexPath.row == statusResults.count) {
			if (![loadCell.spinner isAnimating]) {
				if (statusResults.count == 0) {
					[self searchStatusByName:searchDisplayController.searchBar.text];
				}
				else {
					[self moreStatus];
				}
			}
		}
		else {
			if (indexPath.row < statusResults.count) {
				Status *status = [statusResults objectAtIndex:indexPath.row];
				[searchDataSourceDelegate statusSelected:status];
			}
		}

	}
}

@end
