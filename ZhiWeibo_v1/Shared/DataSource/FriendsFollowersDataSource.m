//
//  FriendsFollowersDataSource.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-12.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "FriendsFollowersDataSource.h"

@interface FriendsFollowersDataSource (Private)

- (void)loadRecentUsers;

@end

@implementation FriendsFollowersDataSource
@synthesize userId;
@synthesize userLoaded;
@synthesize tableView;
@synthesize friendsFollowersDataSourceDelegate;

- (id)initWithTableView:(UITableView *)_usersTableView {
	if (self = [super init]) {
		tableView = [_usersTableView retain];
		weiboClient = nil;
		insertPosition = 0;
		users = [[NSMutableArray alloc]init];
		tableView.delegate = self;
		tableView.dataSource = self;
		loadCell = [[LoadMoreCell alloc]initWithStyle:UITableViewStylePlain reuseIdentifier:@"LoadCell"];
		[loadCell.spinner startAnimating];
		downloadCount = 50;		
		cursor = -1;
	}
	return self;
}

- (void)dealloc {
	weiboClient.delegate = nil;
	[weiboClient release];
	weiboClient = nil;
	[tableView release];
	tableView = nil;
	[loadCell release];
	[users removeAllObjects];
	[users release];
	[super dealloc];
}


- (void)setUserId:(int)_userId {
	if (userId != _userId) {
		userId = _userId;
		[self reset];
	}
}

- (void)loadUsers:(int)_userId {
	[loadCell.spinner startAnimating];
	[self reset];
	userId = _userId;
	[self loadRecentUsers];
}

- (void)loadRecentUsers {
}

- (void)loadMoreUsersAtPosition:(int)insertPos {
}

- (void)reset {
	cursor = 0;
	[weiboClient release];
	weiboClient = nil;
	isRestored = NO;
	userLoaded = NO;
	[users removeAllObjects];
	[tableView reloadData];
}

- (void)stopLoading {
	weiboClient.delegate = nil;
	[weiboClient cancel];
	[weiboClient release];
	weiboClient = nil;
	[loadCell.spinner stopAnimating];
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
	
    if (obj == nil || ![obj isKindOfClass:[NSDictionary class]]) {
		[self stopLoading];
        return;
    }
	userLoaded = YES;
	if (insertPosition > 0 && users.count == 0) {
		[self stopLoading];
		return;
	}
	
	NSDictionary *dic = (NSDictionary*)obj;
	cursor = [dic getIntValueForKey:@"next_cursor" defaultValue:0];
	
	NSArray *ary = (NSArray*)[dic objectForKey:@"users"];    
	if (!ary || ![ary isKindOfClass:[NSArray class]]) {
		[self stopLoading];
		return;
	}
	BOOL needScroll = users.count > 0 && insertPosition == 0;
    int unread = 0;
	for (int i = 0; i < [ary count]; i++) {
		NSDictionary *dic1 = (NSDictionary*)[ary objectAtIndex:i];
		if (![dic1 isKindOfClass:[NSDictionary class]]) {
			continue;
		}
		User* user = [User userWithJsonDictionary:[ary objectAtIndex:i]];
		[users addObject:user];
		++unread;
	}
	
	
	if ([ary count] == 0 || cursor == 0) {
		isRestored = YES;
	}
	
	int count = unread;
	if ([tableView numberOfRowsInSection:0] == 0 && isRestored == NO)
		count += 1;
	
	CGPoint offset = tableView.contentOffset;
	if (count > 0) {
		int numInsert = count;
		int scrollHeight = 0;
		for (int i = 0; i < numInsert; ++i) {
			NSIndexPath *indexPath = [NSIndexPath indexPathForRow:insertPosition + i inSection:0];
			if (insertPosition == 0) {
				scrollHeight += [self tableView:tableView heightForRowAtIndexPath:indexPath];
			}
		}        
		offset.y += scrollHeight;
	}
	[tableView reloadData];
	if (needScroll) {
		tableView.contentOffset = offset;
	}
	[tableView flashScrollIndicators];
	[self stopLoading];
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return isRestored == YES ? [users count] : [users count] + 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < users.count) {
		User *user = (User *)[users objectAtIndex:indexPath.row];
		static NSString *CellIdentifier = @"UserCell";
		UserCell *cell = (UserCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UserCell alloc] initWithStyle:UITableViewCellStyleDefault 
									reuseIdentifier:CellIdentifier] autorelease];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		cell.user = user;
		return cell;
	}
    
    return loadCell;
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < users.count) {
		return 60;
	}
	return 48;
}


#pragma mark -
#pragma mark Table view delegate


- (void)tableView:(UITableView *)_tableView 
	didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < users.count) {
		User *user = [users objectAtIndex:indexPath.row];
		[friendsFollowersDataSourceDelegate userSelected:user];
	}
	else {    
		[loadCell.spinner startAnimating];
		if (users.count == 0) {
			[self loadRecentUsers];
		}
		else {
			[self loadMoreUsersAtPosition:users.count];
		}		
		[_tableView deselectRowAtIndexPath:indexPath animated:NO];
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	//NSLog(@"scrollViewDidScroll with content offset: (%f, %f).", tableView.contentOffset.x, tableView.contentOffset.y);
	if (users.count == 0 
		|| isRestored == YES
		|| weiboClient != nil) { //没有数据，或者已经全部加载完毕，或者正在加载
		return;
	}
	NSArray *indexPathes = [tableView indexPathsForVisibleRows];
	if (indexPathes.count > 0) {
		int rowCounts = [tableView numberOfRowsInSection:0];
		NSIndexPath *lastIndexPath = [indexPathes objectAtIndex:indexPathes.count - 1];
		if (rowCounts - lastIndexPath.row < 3) {
			[loadCell.spinner startAnimating];
			User *lastUser = [users objectAtIndex:users.count - 1];
			if (lastUser && [lastUser isKindOfClass:[User class]]) {
				[self loadMoreUsersAtPosition:users.count];
			}
		}
	}
}



@end
