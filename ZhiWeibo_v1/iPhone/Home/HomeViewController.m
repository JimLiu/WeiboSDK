//
//  HomeViewController.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-3.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "HomeViewController.h"


@implementation HomeViewController
@synthesize addAccountViewController;

- (id)initWithCoder:(NSCoder *)aDecoder {
	[super initWithCoder:aDecoder];
	if (self) {
		addAccountViewController = [[AddAccountViewController alloc] init];
		self.hidesBottomBarWhenPushed = YES;
		self.title = @"智微博";
	}
	return self;
}

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
	[addAccountViewController release];
    [super dealloc];
}



- (IBAction)signIn:(id)sender {
	[self.navigationController presentModalViewController:addAccountViewController 
												 animated:YES];
}

@end
