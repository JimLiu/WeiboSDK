//
//  NewDirectMessageViewController.m
//  ZhiWeibo
//
//  Created by Zhang Jason on 1/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewDirectMessageViewController.h"
#import "UserCell.h"
#import "UserCache.h"
#import "FriendCache.h"
#import "MiniUser.h"


@implementation NewDirectMessageViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
    if (self) {
        
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

- (void)viewWillAppear:(BOOL)animated {
	[displayController setActive:YES animated:YES];
	[searchBar becomeFirstResponder];
	searchBar.text = @"";
	[super viewWillAppear:animated];
}

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
	[searchResult release];
    [super dealloc];
}

- (void)search {
	if ([searchBar.text isEqualToString:@""]) {
		return;
	}
	[searchResult release];
	searchResult =  [[FriendCache searchUserByScreenName:searchBar.text] retain];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return  ![searchBar.text isEqualToString:@""]?searchResult.count + 1:searchResult.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"UserSearchCell";
    
    UserCell *cell = (UserCell*)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UserCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
    }
	if (indexPath.row == 0) {
		cell.textLabel.text = [NSString stringWithFormat:@"%@",searchBar.text];
	}
	else {
		User *user = [searchResult objectAtIndex:indexPath.row - 1];
		if(user){
			cell.user = user;
		}
	}
    return cell;
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		if (weiboClient != nil) {
			[self dismissModalViewControllerAnimated:NO];
		}
		else {
			User *user = [UserCache getUserByScreenName:searchBar.text];
			if (user) {
				[self dismissModalViewControllerAnimated:NO];
				[newDirectMessageViewControllerDelegate newDirectMessageTo:user.userId];
			}
			else {
				maskView.center = self.view.center;
				//NSLog(@"%@",NSStringFromCGRect(maskView.frame));
				[self.view addSubview:maskView];
				weiboClient = [[WeiboClient alloc] initWithTarget:self action:@selector(usersDidReceive:obj:)];
				[weiboClient getUserByScreenName:searchBar.text];
			}
		}

	}
	else if(indexPath.row <= searchResult.count){
		[self dismissModalViewControllerAnimated:NO];
		[newDirectMessageViewControllerDelegate newDirectMessageTo:[[searchResult objectAtIndex:indexPath.row - 1] userId]];
	}
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	[self search];
	return YES;
}

- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)stopLoading {
	[maskView removeFromSuperview];
	weiboClient.delegate = nil;
	[weiboClient release];
	weiboClient = nil;
}

- (void)usersDidReceive:(WeiboClient*)sender obj:(NSObject*)obj
{
	if (obj == nil) {
		[self stopLoading];
        return;
    }
    if (sender.hasError) {
		NSLog(@"usersDidReceive error!!!, errorMessage:%@, errordetail:%@"
			  , sender.errorMessage, sender.errorDetail);
        if (sender.statusCode == 401) {
            ZhiWeiboAppDelegate *appDelegate = [ZhiWeiboAppDelegate getAppDelegate];
            [appDelegate openAuthenticateView];
        }
        [sender alert];
		[self stopLoading];
		return;
    }
	
    
	NSDictionary *dic = (NSDictionary*)obj;
	User* user = [User userWithJsonDictionary:dic];
	[UserCache cache:user];
	[self stopLoading];
	[self dismissModalViewControllerAnimated:NO];
	[newDirectMessageViewControllerDelegate newDirectMessageTo:user.userId];
}

@end
