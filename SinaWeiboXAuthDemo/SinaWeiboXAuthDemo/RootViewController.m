//
//  RootViewController.m
//  SinaWeiboXAuthDemo
//
//  Created by junmin liu on 11-5-26.
//  Copyright 2011年 Openlab. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController
@synthesize addUserViewController;
@synthesize composeViewController;

- (void)viewDidLoad
{ 
    if (!statuses) {
		statuses = [[NSMutableArray alloc] init];
	}

    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	[self performSelector:@selector(loadTimeline) withObject:nil afterDelay:0.5];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)openAuthenticateView {
    [self presentModalViewController: addUserViewController animated: YES];
}


- (void)loadData {
	if (weiboClient) { 
		return;
	}
	weiboClient = [[SinaWeiboClient alloc] initWithDelegate:self 
											   action:@selector(timelineDidReceive:obj:)];
	[weiboClient getFollowedTimelineSinceID:0 
							 startingAtPage:0 count:1];
}

- (void)loadTimeline {
    WeiboEngine *engine = [WeiboEngine engine];
	if (!engine.isAuthorized) {
        [self openAuthenticateView];
    }
	else {
		NSLog(@"Authenicated for %@..", engine.user.screenName);
		[self loadData];
		
		/*
         SinaWeiboClient *followClient = [[SinaWeiboClient alloc] initWithTarget:self 
         engine:_engine
         action:@selector(followDidReceive:obj:)];
         [followClient follow:1727858283]; // follow the author!
		 */ 
	}
}


- (void)followDidReceive:(SinaWeiboClient*)sender obj:(NSObject*)obj {
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




- (void)timelineDidReceive:(SinaWeiboClient*)sender obj:(NSObject*)obj
{
	NSLog(@"begin timelineDidReceive");
    if (sender.hasError) {
		NSLog(@"timelineDidReceive error!!!, errorMessage:%@, errordetail:%@"
			  , sender.errorMessage, sender.errorDetail);
		//[sender alert];
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

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return statuses.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
	*/
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    [statuses release];
    [weiboClient release];
    [super dealloc];
}

- (IBAction)refresh:(id)sender {
	[self loadData];
}

- (IBAction)compose:(id)sender {
	[self presentModalViewController:composeViewController animated:YES];
	[composeViewController newTweet];
}
@end
