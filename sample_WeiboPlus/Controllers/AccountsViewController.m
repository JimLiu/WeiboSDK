//
//  AccountsViewController.m
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-8-20.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "AccountsViewController.h"
#import "WeiboAccountCell.h"

@interface AccountsViewController ()

@end

@implementation AccountsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIBarButtonItem *closeButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Button_Close", @"Button Close") style:UIBarButtonItemStyleBordered target:self action:@selector(close:)] autorelease];
        self.navigationItem.leftBarButtonItem = closeButton;
        
        UIBarButtonItem *addButton = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)] autorelease];
        self.navigationItem.rightBarButtonItem = addButton;
        
        self.title = NSLocalizedString(@"AccountsViewController_Title", "Accounts");

        _weiboSignIn = [[WeiboSignIn alloc] init];
        _weiboSignIn.delegate = self;
    }
    return self;
}

- (void)dealloc {
    [_weiboSignIn release];
    [super dealloc];
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)add:(id)sender {
    [_weiboSignIn signInOnViewController:self];
}

- (void)finishedWithAuth:(WeiboAuthentication *)auth error:(NSError *)error {
    if (error) {
        NSLog(@"failed to auth: %@", error);
    }
    else {
        NSLog(@"Success to auth: %@", auth.userId);
        [[WeiboAccounts shared]addAccountWithAuthentication:auth];
    }
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.editButtonItem setBackgroundImage:[UIImage imageNamed:@"btn_tool_bar_rect_default.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.editButtonItem setBackgroundImage:[UIImage imageNamed:@"btn_tool_bar_rect_pressed.png"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    NSArray* toolbarItems = [NSArray arrayWithObjects:
                             self.editButtonItem,
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

- (void)viewDidAppear:(BOOL)animated {

    if (!self.modalViewController) {
        if (![[WeiboAccounts shared]currentAccount] && [[WeiboAccounts shared]accounts].count == 0) {
            [self add:nil];
        }
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[WeiboAccounts shared]accounts].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WeiboAccountCell";
    WeiboAccountCell *cell = (WeiboAccountCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[WeiboAccountCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
    }
    WeiboAccount *account = [[[WeiboAccounts shared]accounts] objectAtIndex:indexPath.row];
    NSString *name = account.screenName;
    if (!name) {
        name = account.userId;
    }
    cell.weiboAccount = account;
    
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


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        WeiboAccount *account = [[[WeiboAccounts shared]accounts] objectAtIndex:indexPath.row];
        [[WeiboAccounts shared] removeWeiboAccount:account];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    WeiboAccount *account = [[[WeiboAccounts shared]accounts] objectAtIndex:indexPath.row];
    if ([[WeiboAccounts shared] currentAccount] == account) {
        [self close:nil];
    }
    else {
        [[WeiboAccounts shared] setCurrentAccount:account];
        [self.tableView reloadData];
    }
}

@end
