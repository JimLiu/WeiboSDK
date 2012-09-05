//
//  DraftsViewController.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-20.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "DraftsViewController.h"


@implementation DraftsViewController
@synthesize tableView;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(draftPostCompleted:) 
													 name:@"draftPostCompleted" object:nil];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(draftPostCompleted:) 
													 name:@"draftPostCompleted" object:nil];
	}
	return self;
}

- (void)draftPostCompleted:(NSNotification*)notification {
	if (notification == nil) return;
	
	Draft *draft = (Draft *)[notification object];
	
	if (draft) {
		// todo;
		NSLog(@"draft text: %@", draft.text);
	}
	[drafts release];
	drafts = [[self loadDrafts] retain];
	[tableView reloadData];
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

- (id)init {
	if(self = [super init]){
		self.hidesBottomBarWhenPushed = YES;
	}
	return self;
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

- (void)viewWillAppear:(BOOL)animated {
	[drafts release];
	drafts = [[self loadDrafts] retain];
	[tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
	[drafts release];
	drafts = nil;
}


- (void)dealloc {
	[drafts release];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}


- (NSMutableArray*)loadDrafts {
	NSMutableArray *_drafts = [NSMutableArray array];
	NSString *filePath = [WeiboEngine getCurrentUserStoreagePath:@"drafts"];
	[PathHelper createPathIfNecessary:filePath];
	NSFileManager* fm = [NSFileManager defaultManager];
	NSDirectoryEnumerator* e = [fm enumeratorAtPath:filePath];
	NSMutableArray *filenames = [NSMutableArray array];
	for (NSString* fileName; fileName = [e nextObject]; ) {
		NSString* path = [filePath stringByAppendingPathComponent:fileName];
		[filenames addObject:path];
	}
	
	int maxCount = 20; //限制一下，否则如果都是带附件的，内存就不够用了！待改进;by jim
	for (int i=filenames.count-1; i >= 0; i--) {
		//NSData* data = [NSData dataWithContentsOfFile:path];		
		NSString *filename = [filenames objectAtIndex:i];
		if (![filename hasSuffix:@".db"] 
			&& ![filename hasSuffix:@".plist"])
			continue;
		Draft* draft = (Draft*)[NSKeyedUnarchiver unarchiveObjectWithFile:filename];
		if (draft) {
			[_drafts addObject:draft];
		}
		if (filenames.count - i > maxCount) {
			break;
		}
	}
	return _drafts;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)_tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [drafts count];
}

- (NSString *)getDraftType:(Draft *)draft {
	if (draft.draftType == DraftTypeNewTweet) {
		return @"新微博";
	}
	if (draft.draftType == DraftTypeReTweet) {
		return @"转发微博";
	}
	if (draft.draftType == DraftTypeReplyComment) {
		return @"评论微博";
	}
	return @"";
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	Draft *draft = (Draft *)[drafts objectAtIndex:indexPath.row];
	if (draft.attachmentImage) {
		cell.imageView.image = draft.attachmentImage;
	}
    cell.textLabel.text = [self getDraftType:draft];
	cell.detailTextLabel.text = draft.text;
    
    return cell;
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < drafts.count) {
		id obj = [drafts objectAtIndex:indexPath.row];
		if (obj) {
			if ([obj isKindOfClass:[Draft class]]) {
				Draft *draft = obj;
				if (draft) {
					[[ZhiWeiboAppDelegate getAppDelegate] loadDraft:draft];
				}
				
			}
		}
	}
	else {
		[_tableView deselectRowAtIndexPath:indexPath animated:NO];
	}
}

@end
