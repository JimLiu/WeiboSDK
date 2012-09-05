//
//  TrendSearchViewController.m
//  ZhiWeibo
//
//  Created by Zhang Jason on 12/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TrendSearchViewController.h"
#import "WeiboEngine.h"
#import "Status.h"


@implementation TrendSearchViewController
@synthesize trendSearchViewControllerDelegate;

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
		NSString *filePath = [WeiboEngine getCurrentUserStoreagePath:@"trends.db"];
		trends = [[NSKeyedUnarchiver unarchiveObjectWithFile:filePath] retain];
		if (!trends) {
			trends = [[NSMutableArray alloc] init];
		}
		searchResult = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)storageTrendsToLocal {
	NSString *filePath = [WeiboEngine getCurrentUserStoreagePath:@"trends.db"];
	[NSKeyedArchiver archiveRootObject:trends toFile:filePath];
}

- (void)search {
	if ([searchBar.text isEqualToString:@""] || [searchBar.text isEqualToString:@"#"]) {
		[searchResult removeAllObjects];
		[searchResult addObjectsFromArray:trends];
	}
	else {
		NSString *searchKey;
		if ([searchBar.text hasPrefix:@"#"]) {
			searchKey = [searchBar.text substringFromIndex:1];
		}
		else {
			searchKey = searchBar.text;
		}
		[searchResult removeAllObjects];
		for (NSString *trend in trends) {
			if ([[trend lowercaseString] rangeOfString:[searchKey lowercaseString]].location != NSNotFound) {
				[searchResult addObject:trend];
				//NSLog(@"%@",trend);
			}
		}
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[displayContrller setActive:YES animated:YES];
	[searchBar becomeFirstResponder];
	searchBar.text = @"#";
	//[tableView reloadData];
	[super viewWillAppear:animated];
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
	[trends release];
	[searchResult release];
    [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return  searchResult.count + 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"TrendSearchCell";
    //NSLog(@"%d",searchResult.count);
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	if (indexPath.row == 0) {
		cell.textLabel.text = [NSString stringWithFormat:@"%@#",searchBar.text];
		cell.textLabel.textColor = [UIColor blueColor];
	}
	else if(indexPath.row <= searchResult.count){
		NSString *trend = [searchResult objectAtIndex:indexPath.row - 1];
		//NSLog(@"%@",trend);
		if(trend){
			cell.textLabel.text = [NSString stringWithFormat:@"%@#",trend];
		}
		cell.textLabel.textColor = [UIColor blackColor];
	}
    return cell;
}
/*
- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
}
*/

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row <= searchResult.count) {
		if (indexPath.row == 0) {
			[trendSearchViewControllerDelegate addTrend:[NSString stringWithFormat:@"%@#",searchBar.text]];
			if ([searchBar.text isEqualToString:@"#"] || [searchBar.text isEqualToString:@""] || [searchBar.text isEqualToString:@"##"]) {
				[self dismissModalViewControllerAnimated:YES];
				return;
			}
			NSString *trendKey;
			if (![searchBar.text hasPrefix:@"#"]) {
				trendKey = [NSString stringWithFormat:@"#%@",searchBar.text];
			}
			else {
				trendKey = searchBar.text;
			}
			for (NSString *trend in trends) {
				if([trend isEqualToString:trendKey]) {
					[self dismissModalViewControllerAnimated:YES];
					return;
				}
			}
			//NSLog(@"%@",trendKey);
			[trends insertObject:trendKey atIndex:0];
			[self storageTrendsToLocal];
			[self dismissModalViewControllerAnimated:YES];
			return;
		}
		[trendSearchViewControllerDelegate addTrend:[NSString stringWithFormat:@"%@#",[searchResult objectAtIndex:indexPath.row -  1]]];
		[trends insertObject:[trends objectAtIndex:indexPath.row - 1] atIndex:0];
		[trends removeObjectAtIndex:indexPath.row];
		[self dismissModalViewControllerAnimated:YES];
	}
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	if (searchBar.text) {
		[self search];
	}
	return YES;
}

- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
	[self dismissModalViewControllerAnimated:YES];
}

@end
