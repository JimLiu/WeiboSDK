//
//  UserProfileDataSource.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-11.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "UserProfileDataSource.h"
#import "NSDictionaryAdditions.h"

@interface UserProfileDataSource (Private)

- (void)cancelLoadUser;

@end

@implementation UserProfileDataSource
@synthesize user;
@synthesize dataSourceDelegate;
@synthesize tableView;

- (id)initWithTableView:(UITableView *)_userTableView {
	if (self = [super init]) {
		tableView = [_userTableView retain];
		loadUserClient = nil;
		loadFriendshipClient = nil;
		tableView.delegate = self;
		tableView.dataSource = self;
		loadStatus = UserProfileLoading;
		
		userProfileHeaderView = [[UserProfileHeaderView alloc] initWithFrame:CGRectMake(0, 0, _userTableView.frame.size.width, 72)];
		
		detailCellFont = [[UIFont systemFontOfSize:17] retain];
		cellFont = [[UIFont systemFontOfSize:15]retain];
	}
	return self;
	
}


- (void)setTableView:(UITableView *)_tableView {
	if (tableView != _tableView) {
		[tableView release];
		tableView = [_tableView retain];
		tableView.dataSource = self;
		tableView.delegate = self;
		[tableView reloadData];
	}
}


- (void)cancelLoadUser {
	loadUserClient.delegate = nil;
	[loadUserClient release];
	loadUserClient = nil;
}

- (void)cancelLoadFriendshipClient {
	loadFriendshipClient.delegate = nil;
	[loadFriendshipClient release];
	loadFriendshipClient = nil;
}

- (void)cancelFollowClient {
	followClient.delegate = nil;
	[followClient release];
	followClient = nil;
}


- (void)dealloc {
	[tableView release];
	tableView = nil;
	[self cancelLoadUser];
	[self cancelLoadFriendshipClient];
	[self cancelFollowClient];
	[userProfileHeaderView release];
	[user release];
	user = nil;
	[detailCellFont release];
	[cellFont release];

	[super dealloc];
}

- (void)setUser:(User *)newUser {
	if (user != newUser) {
		[user release];
		user = [newUser retain];
		userProfileHeaderView.user = user;
	}
}

- (void)loadFriendship {
	[self cancelLoadFriendshipClient];
	loadFriendshipClient = [[WeiboClient alloc] initWithTarget:self 
														action:@selector(friendshipDidReceive:obj:)];
	
	[loadFriendshipClient getFriendship:user.userId];
}

- (void)loadUser:(User *)_user {
	if (user != _user) {
		[self cancelLoadUser];
		self.user = _user;
		loadStatus = UserProfileLoadSuccessful;
		needsCheckFriendship = YES;
		[self loadFriendship];
		[tableView reloadData];
	}
}


- (void)loadUserByUserId:(int)userId {
	[self cancelLoadUser];
	[self cancelLoadFriendshipClient];
	User *localUser = [User userWithId:userId];
	if (localUser) {
		if (dataSourceDelegate) {
			[dataSourceDelegate userLoaded:localUser];
		}
		loadStatus = UserProfileLoadSuccessful;
		needsCheckFriendship = YES;
		self.user = localUser;
		[self loadFriendship];
		[tableView reloadData];
	}
	else {
		loadStatus = UserProfileLoading;
		needsCheckFriendship = NO;
		self.user = nil;
		loadUserClient = [[WeiboClient alloc] initWithTarget:self 
													  action:@selector(userDidReceive:obj:)];
		
		[loadUserClient getUser:userId];
		[tableView reloadData];
	}
}

- (void)loadUserByScreenName:(NSString *)screenName {
	[self cancelLoadUser];
	[self cancelLoadFriendshipClient];
	User *localUser = [User userWithScreenName:screenName];
	if (localUser) {
		if (dataSourceDelegate) {
			[dataSourceDelegate userLoaded:localUser];
		}
		loadStatus = UserProfileLoadSuccessful;
		needsCheckFriendship = YES;
		self.user = localUser;
		[self loadFriendship];
		[tableView reloadData];
	}
	else {
		loadStatus = UserProfileLoading;
		needsCheckFriendship = NO;
		self.user = nil;
		loadUserClient = [[WeiboClient alloc] initWithTarget:self 
													  action:@selector(userDidReceive:obj:)];
		
		[loadUserClient getUserByScreenName:screenName];
		[tableView reloadData];
	}
}

- (void)friendshipDidReceive:(WeiboClient*)sender obj:(NSObject*)obj {
	if (sender.hasError) {		
		NSLog(@"friendshipDidReceive error!!!, errorMessage:%@, errordetail:%@"
			  , sender.errorMessage, sender.errorDetail);
		[self cancelLoadFriendshipClient];
        return;
    }
	
    if (obj == nil || ![obj isKindOfClass:[NSDictionary class]]) {
		NSLog(@"friendshipDidReceive data format error.%@", @"");
		[self cancelLoadFriendshipClient];
        return;
    }
    
    
    NSDictionary *dic = (NSDictionary*)obj;
    NSDictionary *sourceDic = [dic objectForKey:@"source"];
	if (user && sourceDic && [sourceDic isKindOfClass:[NSDictionary class]]) {
		user.following = [sourceDic getBoolValueForKey:@"following" defaultValue:NO];
		user.followedBy = [sourceDic getBoolValueForKey:@"followed_by" defaultValue:NO];
		//[user updateDB];
		needsCheckFriendship = NO;
		[tableView reloadData];
	}
	[self cancelLoadFriendshipClient];
}

- (void)userDidReceive:(WeiboClient*)sender obj:(NSObject*)obj
{
    if (sender.hasError) {
		if (sender.statusCode == 400) {
			[errorMessage release];
			errorMessage = @"抱歉，用户信息未找到！";
		}
		else {
			[errorMessage release];
			errorMessage = [sender.errorDetail copy];
		}
		
		NSLog(@"userDidReceive error!!!, errorMessage:%@, errordetail:%@"
			  , sender.errorMessage, sender.errorDetail);
		[self cancelLoadUser];
		loadStatus = UserProfileLoadFailed;
		[tableView reloadData];
        return;
    }
	
    if (obj == nil || ![obj isKindOfClass:[NSDictionary class]]) {
		[errorMessage release];
		errorMessage = @"数据格式返回错误！";
		[self cancelLoadUser];
		loadStatus = UserProfileLoadFailed;
		[tableView reloadData];
		return;
    }
    
    
    NSDictionary *dic = (NSDictionary*)obj;
    User *_user = [[User alloc]initWithJsonDictionary:dic];
	//[_user updateDB];
	self.user = _user;
	[_user release];
	loadStatus = UserProfileLoadSuccessful;
	
	if (dataSourceDelegate) {
		[dataSourceDelegate userLoaded:user];
	}
	
	[tableView reloadData];
	[self cancelLoadUser];
	
}

- (void)followDidReceive:(WeiboClient*)sender obj:(NSObject*)obj {
	if (sender.hasError) {		
		NSLog(@"followDidReceive error!!!, errorMessage:%@, errordetail:%@"
			  , sender.errorMessage, sender.errorDetail);
		[self cancelFollowClient];
        return;
    }
	
    if (obj == nil || ![obj isKindOfClass:[NSDictionary class]]) {
		NSLog(@"followDidReceive data format error.%@", @"");
		[self cancelFollowClient];
        return;
    }
    
    
    NSDictionary *dic = (NSDictionary*)obj;
	User *responseUser = [[[User alloc]initWithJsonDictionary:dic] autorelease];
	if (responseUser && responseUser.userId > 0) {
		if (user && user.userId == responseUser.userId) {
			//user.following = responseUser.following;
			user.followersCount = responseUser.followersCount;
			user.friendsCount = responseUser.friendsCount;
			user.statusesCount = responseUser.statusesCount;
			// todo save
			[tableView reloadData];
		}
	}
	[self cancelFollowClient];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	if (loadStatus == UserProfileLoadSuccessful) {
		return 3;
	}
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	if (loadStatus == UserProfileLoadSuccessful) {
		switch (section) {
			case 0:
				return 1;
			case 1:
				return 3;
			case 2:
				return 3;
		}	
	}
    else if (loadStatus == UserProfileLoading) {
		return 1;
	}
	else if (loadStatus == UserProfileLoadFailed) {
		return 1;
	}
	
	
	return 0;
}

- (UITableViewCell*)loadingCell {
	static NSString *loadingCellIdentifier = @"LoadingCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:loadingCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loadingCellIdentifier] autorelease];
		UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[cell addSubview:spinner];
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
		CGRect frame = [tableView rectForRowAtIndexPath:indexPath];
		spinner.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
		[spinner startAnimating];
		[spinner release];
	}
	return cell;
}

- (UITableViewCell*)userProfileCell:(int)row {
	static NSString *CellIdentifier = @"userProfileCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
		cell.textLabel.font = cellFont;
		cell.detailTextLabel.font = detailCellFont;
		cell.detailTextLabel.numberOfLines = 0;
	}
	if (row == 0) {
		cell.textLabel.text = @"简介";
		cell.detailTextLabel.text = user.description;
	}
	else if (row == 1) {
		cell.textLabel.text = @"位置";
		cell.detailTextLabel.text = user.location;
	}
	else if (row == 2) {
		cell.textLabel.text = @"网站";
		cell.detailTextLabel.text = user.url;
	}
	return cell;
}

- (UITableViewCell*)userFollowersCell:(int)row {
	static NSString *CellIdentifier = @"userFollowersCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
		cell.textLabel.font = cellFont;
		cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:17];
		cell.detailTextLabel.numberOfLines = 0;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	if (row == 0) {
		cell.textLabel.text = @"关注";
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", user.friendsCount];
	}
	else if (row == 1) {
		cell.textLabel.text = @"粉丝";
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", user.followersCount];
	}
	else if (row == 2) {
		cell.textLabel.text = @"微博";
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", user.statusesCount];
	}
	return cell;
}

- (UITableViewCell*)followUnfollowCell:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"followUnfollowCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.textLabel.textAlignment = UITextAlignmentCenter;
	}
	//CGRect frame = [tableView rectForRowAtIndexPath:indexPath];
	cell.textLabel.text = user.following ? @"取消关注" : @"关注";
	//[cell.contentView addSubview:self];
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (loadStatus == UserProfileLoadSuccessful 
		&& indexPath.section == 1) {
		CGFloat detailLabelWidth = 207;
		CGSize size;
		if (indexPath.row == 0) {
			size = [user.description sizeWithFont:detailCellFont  
								constrainedToSize:CGSizeMake(detailLabelWidth, 9999)];
		}
		else if (indexPath.row == 1) {
			size = [user.location sizeWithFont:detailCellFont  
							 constrainedToSize:CGSizeMake(detailLabelWidth, 9999)];
		}
		else if (indexPath.row == 2) {
			size = [user.url sizeWithFont:detailCellFont  
						constrainedToSize:CGSizeMake(detailLabelWidth, 9999)];
		}
		CGFloat height = size.height + 16;
		if (height < 44) {
			height = 44;
		}
		return height;
	}
	
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if (loadStatus == UserProfileLoadSuccessful) {
		if (indexPath.section == 0) {
			if (needsCheckFriendship) {
				return [self loadingCell];
			}
			else {
				User *me = [WeiboEngine getCurrentUser];
				if (!me) {
					UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
					cell.textLabel.textAlignment = UITextAlignmentCenter;
					cell.textLabel.text = [NSString stringWithFormat:@"请先登录"];
					return cell;
				}
				if (user.userId == me.userId) {
					UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
					cell.textLabel.textAlignment = UITextAlignmentCenter;
					cell.textLabel.text = [NSString stringWithFormat:@"自己"];
					return cell;
				}
				return [self followUnfollowCell:indexPath];
			}
		}
		else if (indexPath.section == 1) {
			return [self userProfileCell:indexPath.row];
		}
		else if(indexPath.section == 2) {
			return [self userFollowersCell:indexPath.row];
		}
	}
	else if (loadStatus == UserProfileLoading) {
		return [self loadingCell];
	}
	else if (loadStatus == UserProfileLoadFailed) {
		static NSString *loadFailedCellIdentifier = @"loadFailedCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:loadFailedCellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loadFailedCellIdentifier] autorelease];
		}
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		cell.textLabel.text = errorMessage;
		
		return cell;
	}
	
	
	static NSString *CellIdentifier = @"UserViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	cell.clipsToBounds = YES;
	return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (user && loadStatus == UserProfileLoadSuccessful && section == 0) {
        return userProfileHeaderView;
    }
    else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (user && loadStatus == UserProfileLoadSuccessful && section == 0) {
        return userProfileHeaderView.frame.size.height;
    }
    else {
        return 0;
    }
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (loadStatus == UserProfileLoadSuccessful) {
		if (indexPath.section == 0 && indexPath.row == 0 
			&& needsCheckFriendship == NO) { // follow, unfollow
			if (user.userId == [WeiboEngine getCurrentUser].userId) {
			}
			else {
				if (user.following) {
					UIActionSheet *unfollowActionSheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self
																			 cancelButtonTitle:@"取消" destructiveButtonTitle:@"取消关注"
																			 otherButtonTitles:nil] autorelease];
					unfollowActionSheet.tag = 99; //unfollowtag;
					unfollowActionSheet.delegate = self;
					//CGRect frame = [tableView rectForRowAtIndexPath:indexPath];
					//[unfollowActionSheet showFromRect:frame inView:tableView animated:YES];
					[unfollowActionSheet showInView:tableView.superview];
					return;
				}
				else {
					[self cancelFollowClient];
					followClient = [[WeiboClient alloc] initWithTarget:self 
																action:@selector(followDidReceive:obj:)];
					
					[followClient follow:user.userId];
					user.following = YES;
					[tableView reloadData];
					return;
				}
			}
		}
		if (indexPath.section == 2) {
			if (indexPath.row == 0) {
				[dataSourceDelegate showFriends];
			}
			else if (indexPath.row == 1) {
				[dataSourceDelegate showFollowers];
			}
			else if (indexPath.row == 2) {
				[dataSourceDelegate showStatus];
			}
		}
	}
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
	
}

- (void)actionSheet:(UIActionSheet*)actionSheet 
clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (actionSheet.tag == 99) {
		if (buttonIndex == 0) {
			[self cancelFollowClient];
			followClient = [[WeiboClient alloc] initWithTarget:self 
														action:@selector(followDidReceive:obj:)];
			
			[followClient unfollow:user.userId];
			user.following = NO;
		}
		[tableView reloadData];
	}
}



@end
