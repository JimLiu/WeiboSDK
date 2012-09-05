//
//  UserNamesSearchViewController.m
//  ZhiWeibo
//
//  Created by Zhang Jason on 12/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UserNamesSearchViewController.h"
#import "WeiboEngine.h"
#import "UserCache.h"
#import "User.h"
#import "UserCell.h"
#import "FriendCache.h"


@implementation UserNamesSearchViewController
@synthesize userNamesSearchViewControllerDelegate;

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

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		sectionsArray = [[NSMutableArray alloc] init];
		collation = [[UILocalizedIndexedCollation currentCollation] retain];
		[self sort];
	}
	return self;
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
	[collation release];
	[sectionsArray release];
	[searchResult release];
    [super dealloc];
}

- (void)sort {
	NSInteger index, sectionTitlesCount = [[collation sectionTitles] count];
	NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
	for (index = 0; index < sectionTitlesCount; index++) {
		NSMutableArray *array = [[NSMutableArray alloc] init];
		[newSectionsArray addObject:array];
		[array release];
	}
	for (User *user in searchResult) {
		NSInteger sectionNumber = [collation sectionForObject:user collationStringSelector:@selector(pinyinOfScreenName)];
		NSMutableArray *sectionUsers = [newSectionsArray objectAtIndex:sectionNumber];
		[sectionUsers addObject:user];
	}
	for (index = 0; index < sectionTitlesCount; index++) {
		
		NSMutableArray *usersArrayForSection = [newSectionsArray objectAtIndex:index];
		NSArray *sortedTimeZonesArrayForSection = [collation sortedArrayFromArray:usersArrayForSection collationStringSelector:@selector(pinyinOfScreenName)];
		[newSectionsArray replaceObjectAtIndex:index withObject:sortedTimeZonesArrayForSection];
	}
	[sectionsArray release];
	sectionsArray = [newSectionsArray retain];
	[newSectionsArray release];
}

- (void)search {
	if ([searchBar.text isEqualToString:@""]) {
		return;
	}
	[searchResult release];
	NSString *key;
	if ([searchBar.text hasPrefix:@"@"]) {
		if ([searchBar.text isEqualToString:@"@"]) {
			searchResult = [[FriendCache getAllUser] retain];
			[self sort];
			return;
		}
		key = [searchBar.text substringFromIndex:1];
	}
	else {
		key = searchBar.text;
	}

	searchResult =  [[FriendCache searchUserByScreenName:key] retain];
	
	[self sort];
	/*
	NSMutableArray *result = [UserCache searchUserByScreenName:searchBar.text];
	if (result.count > 0) {
		if (!searchResult) {
			searchResult = [result retain];
		}
		else {
			[searchResult addObjectsFromArray:result];
		}
	}
	 */
}

- (void)viewWillAppear:(BOOL)animated {
	[displayController setActive:YES animated:YES];
	[searchBar becomeFirstResponder];
	searchBar.text = @"@";
	//[self search];
	//[displayController.searchResultsTableView reloadData];
	[super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	//searchBar.text = @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[collation sectionTitles] count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 1;
	}
	NSArray *usersInSection = [sectionsArray objectAtIndex:section - 1];
    return [usersInSection count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
		return nil;
	}
	if ([[sectionsArray objectAtIndex:section - 1] count] > 0) {
		return [[collation sectionTitles] objectAtIndex:section - 1];
	}
	return nil;
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [collation sectionIndexTitles];
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	return [collation sectionForSectionIndexTitleAtIndex:index] + 1;
}
/*
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
		static NSString *uCellIdentifier = @"mUserSearchCell";
		UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:uCellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:uCellIdentifier] autorelease];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		cell.textLabel.text = [NSString stringWithFormat:@"%@",searchBar.text];
		cell.textLabel.textColor = [UIColor blueColor];
		return cell;
	}
	else {
		static NSString *CellIdentifier = @"UserSearchCell";
		UserCell *cell = (UserCell*)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UserCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		cell.textLabel.textColor = [UIColor blackColor];
		User *user = [searchResult objectAtIndex:indexPath.row - 1];
		
		if(user){
			cell.user = user;
		}
		
		return cell;
	}
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row <= searchResult.count) {
		if (indexPath.row == 0) {
			NSString *screenName;
			if ([searchBar.text hasPrefix:@"@"]) {
				screenName = [searchBar.text substringFromIndex:1];
			}
			else {
				screenName = searchBar.text;
			}
			[userNamesSearchViewControllerDelegate addUserScreenName:[NSString stringWithFormat:@"@%@",screenName]];
			MiniUser *mUser = [[[MiniUser alloc] initWithScreenName:screenName] autorelease];
			[FriendCache cache:mUser];
			[FriendCache storeToLocal];
			[self dismissModalViewControllerAnimated:YES];
			return;
		}
		[userNamesSearchViewControllerDelegate addUserScreenName:[NSString stringWithFormat:@"@%@",[[searchResult objectAtIndex:indexPath.row -  1] screenName]]];
		[self dismissModalViewControllerAnimated:YES];
	}
}
*/

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
		static NSString *uCellIdentifier = @"mUserSearchCell";
		UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:uCellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:uCellIdentifier] autorelease];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		cell.textLabel.text = [NSString stringWithFormat:@"%@",searchBar.text];
		cell.textLabel.textColor = [UIColor blueColor];
		return cell;
	}
	else {
		static NSString *CellIdentifier = @"UserSearchCell";
		UserCell *cell = (UserCell*)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UserCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		cell.textLabel.textColor = [UIColor blackColor];
		NSMutableArray *usersInSection = [sectionsArray objectAtIndex:indexPath.section - 1];
		User *user = [usersInSection objectAtIndex:indexPath.row];
		
		if(user){
			cell.user = user;
		}
		
		return cell;
	}
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		NSString *screenName;
		if ([searchBar.text hasPrefix:@"@"]) {
			screenName = [searchBar.text substringFromIndex:1];
		}
		else {
			screenName = searchBar.text;
		}
		[userNamesSearchViewControllerDelegate addUserScreenName:[NSString stringWithFormat:@"@%@",screenName]];
		MiniUser *mUser = [[[MiniUser alloc] initWithScreenName:screenName] autorelease];
		[FriendCache cache:mUser];
		[FriendCache storeToLocal];
		[self dismissModalViewControllerAnimated:YES];
		return;
	}
	else {
		NSMutableArray *usersInSection = [sectionsArray objectAtIndex:indexPath.section - 1];
		[userNamesSearchViewControllerDelegate addUserScreenName:[NSString stringWithFormat:@"@%@",[[usersInSection objectAtIndex:indexPath.row] screenName]]];
		[self dismissModalViewControllerAnimated:YES];
	}
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	[self search];
	return YES;
}

- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
	[self dismissModalViewControllerAnimated:YES];
}

@end
