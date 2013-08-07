//
//  HomeViewController.m
//  WeiboSDKExample
//
//  Created by junmin liu on 12-9-5.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _statuses = [[NSMutableArray array] retain];
        _failedToLoad = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *refreshButton = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)] autorelease];
    UIBarButtonItem *composeButton = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(compose:)]autorelease];
    UIBarButtonItem *accountsButton = [[[UIBarButtonItem alloc]initWithTitle:@"Accounts" style:UIBarButtonItemStyleBordered target:self action:@selector(displayAccountsController:)]autorelease];
    self.navigationItem.leftBarButtonItem = refreshButton;
    self.navigationItem.rightBarButtonItem = composeButton;
    
    
    NSArray* toolbarItems = [NSArray arrayWithObjects:
                             accountsButton,
                             nil];
    self.toolbarItems = toolbarItems;
    self.navigationController.toolbarHidden = NO;
    
    


}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)displayAccountsViewController {
    AccountsViewController *accountsViewController = [[[AccountsViewController alloc]initWithNibName:nil bundle:nil]autorelease];
    UINavigationController *accountsNavigationController = [[[UINavigationController alloc]initWithRootViewController:accountsViewController] autorelease];
    accountsNavigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:accountsNavigationController animated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    if ([[WeiboAccounts shared]currentAccount]) {
        self.title = [[WeiboAccounts shared]currentAccount].screenName;
        [self refresh:nil];
    }
    else {
        [self displayAccountsViewController];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)refresh:(id)sender {
    if (_query) {
        [_query cancel];
        [_query release];
    }
    [_statuses removeAllObjects];
    _failedToLoad = NO;
    
    _query = [[TimelineQuery alloc] init];
    _query.completionBlock = ^(WeiboRequest *request, NSMutableArray *statuses, NSError *error) {
        if (error) {
            //
            NSLog(@"TimelineQuery error: %@", error);
            _failedToLoad = YES;
            if (request.sessionDidExpire) { // session expired
                [self displayAccountsViewController];
            }
            
        }
        else {
            for (Status *status in statuses) {
                [_statuses addObject:status];
            }
            _failedToLoad = NO;
        }
        _query = nil;
        [self.tableView reloadData];
    };
    [_query queryTimeline:StatusTimelineFriends count:20];
    [self.tableView reloadData];
}

- (IBAction)compose:(id)sender {
    ComposeViewController *composeViewController = [[[ComposeViewController alloc]initWithNibName:@"ComposeViewController" bundle:nil]autorelease];
    composeViewController.statusText = @"Test #Zhiweibo#";
    [self presentViewController:composeViewController animated:YES completion:nil];
}

- (IBAction)displayAccountsController:(id)sender {
    [self displayAccountsViewController];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_query) { // loading...
        return 1;
    }
    if (_failedToLoad) {
        return 1;
    }
    return _statuses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
    }
    
    if (_query) { // loading...
        cell.textLabel.text = @"Loading...";
    }
    else if (_failedToLoad) {
        cell.textLabel.text = @"Failed to load...";
    }
    else {
        Status *status = [_statuses objectAtIndex:indexPath.row];
        cell.textLabel.text = status.text;
    }
    
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
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
