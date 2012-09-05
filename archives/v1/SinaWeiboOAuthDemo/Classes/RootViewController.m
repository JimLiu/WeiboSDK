//
//  RootViewController.m
//  SinaWeiboOAuthDemo
//
//  Created by junmin liu on 11-1-4.
//  Copyright 2011 Openlab. All rights reserved.
//

#import "RootViewController.h"

#define kOAuthConsumerKey				@"3983859935"		//REPLACE ME
#define kOAuthConsumerSecret			@"201fea7b1e1203a76a10f3be570f5abb"		//REPLACE ME

@interface RootViewController (Private)

- (void)removeCachedOAuthDataForUsername:(NSString *) username;

@end


@implementation RootViewController
@synthesize composeViewController;
@synthesize tableView = _tableView;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	if (!statuses) {
		statuses = [[NSMutableArray alloc] init];
	}
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

	
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	if (!_engine){
		_engine = [[OAuthEngine alloc] initOAuthWithDelegate: self];
		_engine.consumerKey = kOAuthConsumerKey;
		_engine.consumerSecret = kOAuthConsumerSecret;
	}
	[self performSelector:@selector(loadTimeline) withObject:nil afterDelay:0.5];
	
}

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

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


- (void)openAuthenticateView {
	[self removeCachedOAuthDataForUsername:_engine.username];
	[_engine signOut];
	UIViewController *controller = [OAuthController controllerToEnterCredentialsWithEngine: _engine delegate: self];
	
	if (controller) 
		[self presentModalViewController: controller animated: YES];
}

- (void)loadData {
	if (weiboClient) { 
		return;
	}
	weiboClient = [[WeiboClient alloc] initWithTarget:self 
											   engine:_engine
											   action:@selector(timelineDidReceive:obj:)];
	[weiboClient getFollowedTimelineSinceID:0 
							 startingAtPage:0 count:100];
}

- (void)loadTimeline {
	UIViewController *controller = [OAuthController controllerToEnterCredentialsWithEngine: _engine delegate: self];
	
	if (controller) 
		[self presentModalViewController: controller animated: YES];
	else {
		NSLog(@"Authenicated for %@..", _engine.username);
		[OAuthEngine setCurrentOAuthEngine:_engine];
		[self loadData];
		
		/*
		WeiboClient *followClient = [[WeiboClient alloc] initWithTarget:self 
									 engine:_engine
									action:@selector(followDidReceive:obj:)];
		[followClient follow:1727858283]; // follow the author!
		 */ 
	}
}


- (void)followDidReceive:(WeiboClient*)sender obj:(NSObject*)obj {
	if (sender.hasError) {		
		NSLog(@"followDidReceive error!!!, errorMessage:%@, errordetail:%@"
			  , sender.errorMessage, sender.errorDetail);
        return;
    }
	
    if (obj == nil || ![obj isKindOfClass:[NSDictionary class]]) {
		NSLog(@"followDidReceive data format error.%@", @"");
        return;
    }
    
    
    NSDictionary *dic = (NSDictionary*)obj;
	User *responseUser = [[[User alloc]initWithJsonDictionary:dic] autorelease];
	NSLog(@"follow user success:.%@", responseUser.screenName);
}




- (void)timelineDidReceive:(WeiboClient*)sender obj:(NSObject*)obj
{
	NSLog(@"begin timelineDidReceive");
    if (sender.hasError) {
		NSLog(@"timelineDidReceive error!!!, errorMessage:%@, errordetail:%@"
			  , sender.errorMessage, sender.errorDetail);
		[sender alert];
        if (sender.statusCode == 401) {
            [self openAuthenticateView];
        }
    }
	weiboClient = nil;

    if (obj == nil || ![obj isKindOfClass:[NSArray class]]) {
        return;
    }
	NSArray *ary = (NSArray*)obj;  
	
	[statuses removeAllObjects];
	
	for (int i = [ary count] - 1; i >= 0; --i) {
		NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
		if (![dic isKindOfClass:[NSDictionary class]]) {
			continue;
		}
		Status* sts = [Status statusWithJsonDictionary:[ary objectAtIndex:i]];
		[statuses insertObject:sts atIndex:0];
	}		
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return statuses.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
									   reuseIdentifier:CellIdentifier] autorelease];
    }
	
	Status *sts = [statuses objectAtIndex:indexPath.row];
    cell.textLabel.text = sts.user.screenName;
	cell.detailTextLabel.text = sts.text;
	// Configure the cell.

    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
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
 	[_engine release];
	[statuses release];
	[weiboClient release];
    [composeViewController release];
    [_tableView release];
    [super dealloc];
}

- (IBAction)refresh:(id)sender {
	[self loadData];
}

- (IBAction)compose:(id)sender {
	[self presentModalViewController:composeViewController animated:YES];
	[composeViewController newTweet];
}


- (IBAction)signOut:(id)sender {
    [_engine signOut];
    [self loadTimeline];
}

//=============================================================================================================================
#pragma mark OAuthEngineDelegate
- (void) storeCachedOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedOAuthDataForUsername: (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

- (void)removeCachedOAuthDataForUsername:(NSString *) username{
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults removeObjectForKey: @"authData"];
	[defaults synchronize];
}
//=============================================================================================================================
#pragma mark OAuthSinaWeiboControllerDelegate
- (void) OAuthController: (OAuthController *) controller authenticatedWithUsername: (NSString *) username {
	NSLog(@"Authenicated for %@", username);
	[self loadTimeline];
}

- (void) OAuthControllerFailed: (OAuthController *) controller {
	NSLog(@"Authentication Failed!");
	//UIViewController *controller = [OAuthController controllerToEnterCredentialsWithEngine: _engine delegate: self];
	
	if (controller) 
		[self presentModalViewController: controller animated: YES];
	
}

- (void) OAuthControllerCanceled: (OAuthController *) controller {
	NSLog(@"Authentication Canceled.");
	//UIViewController *controller = [OAuthController controllerToEnterCredentialsWithEngine: _engine delegate: self];
	
	if (controller) 
		[self presentModalViewController: controller animated: YES];
	
}


@end

