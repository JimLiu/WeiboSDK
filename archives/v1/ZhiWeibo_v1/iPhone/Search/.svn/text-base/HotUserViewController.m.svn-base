//
//  HotUserViewController.m
//  ZhiWeibo
//
//  Created by Zhang Jason on 1/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HotUserViewController.h"
#import "UserTabBarController.h"


@implementation HotUserViewController

- (id)initWithStyle:(UITableViewStyle)_style {
	self = [super initWithStyle:_style];
	if (self) {
		self.title = @"热门用户";
		categroy = [[NSMutableArray alloc] initWithObjects:@"人气关注",@"影视明星",@"港台名人",@"模特",@"美食&健康",@"体育名人",@"商界名人",@"IT互联网",@"歌手",@"作家",@"主持人",@"媒体总编",@"炒股高手",nil];
		categroyDic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"default",@"ent",@"hk_famous",@"model",@"cooking",@"sports",@"finance",@"tech",@"singer",@"writer",@"moderator",@"medium",@"stockplayer",nil] forKeys:categroy];
		usersViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
		hotUserDataSource = [[HotUserDataSource alloc] initWithTableView:usersViewController.tableView];
		hotUserDataSource.friendsFollowersDataSourceDelegate = self;
	}
	return self;
}

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
	 hotUserDataSource.tableView = usersViewController.tableView;
	 [super viewDidLoad];
 }
 
- (void)userSelected:(User *)_user {
	UserTabBarController *c = [[[UserTabBarController alloc] initWithoutNib] autorelease];
	[c loadUser:_user];
	[self.navigationController pushViewController:c animated:YES];
}

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
    [super dealloc];
}

- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section {
	return categroy.count;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *cellName = @"Cell";
	UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellName];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
	}
	cell.textLabel.text = [categroy objectAtIndex:indexPath.row];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	NSString *key = [categroy objectAtIndex:indexPath.row];
	//NSLog(@"%@",[categroyDic objectForKey:key]);
	[hotUserDataSource loadUsersByCategory:[categroyDic objectForKey:key]];
	usersViewController.title = key;
	[self.navigationController pushViewController:usersViewController animated:YES];
}

@end
