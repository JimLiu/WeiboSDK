//
//  CommonPhrasesViewController.m
//  ZhiWeibo
//
//  Created by Zhang Jason on 2/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CommonPhrasesViewController.h"
#import "WeiboEngine.h"


@implementation CommonPhrasesViewController

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
		NSString *filePath = [WeiboEngine getCurrentUserStoreagePath:@"commonphrases.db"];
		phrases = [[NSKeyedUnarchiver unarchiveObjectWithFile:filePath] retain];
		if (!phrases) {
			phrases = [[NSMutableArray alloc] init];
		}
		searchResult = [[NSMutableArray alloc] initWithArray:phrases];
	}
	return self;
}

- (void)storageTrendsToLocal {
	NSString *filePath = [WeiboEngine getCurrentUserStoreagePath:@"commonphrases.db"];
	[NSKeyedArchiver archiveRootObject:phrases toFile:filePath];
}

- (void)search {
	
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
	[phrases release];
	[searchResult release];
    [super dealloc];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return searchResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"PhraseCell";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	cell.textLabel.text = [searchResult objectAtIndex:indexPath.row];
	return cell;
}

@end
