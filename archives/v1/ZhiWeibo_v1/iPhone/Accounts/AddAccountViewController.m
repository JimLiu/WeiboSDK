//
//  AddAccountViewController.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-20.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "AddAccountViewController.h"


@implementation AddAccountViewController
@synthesize oAuth;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
        queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        queue = [[NSOperationQueue alloc] init];
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[maskView setHidden:YES];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)viewDidAppear:(BOOL)animated
{
    [usernameField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	client.delegate = nil;
	[client release];
	client = nil;
	[saveButton release];
	[cancelButton release];
    [queue release];
    [oAuth release];
    [super dealloc];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    UITableViewCell *cell;
	
    UILabel *label;
    UITextField *text;
    if (indexPath.row == 0) {
		cell = username;
	}
	else {
		cell = password;
	}
	cell.backgroundColor = [UIColor whiteColor];
	text = (UITextField*)[cell viewWithTag:2];
	text.font = [UIFont systemFontOfSize:16];
	
	label = (UILabel*)[cell viewWithTag:1];
	label.font = [UIFont boldSystemFontOfSize:16];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
	
    if (indexPath.row == 0) {
		cell = username;
	}
	else {
		cell = password;
	}
	UITextField *text = (UITextField*)[cell viewWithTag:2];
	[text becomeFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == usernameField) {
        [passwordField becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
    //[self saveSettings];
	if (textField == passwordField 
		&& usernameField.text.length > 0 
		&& passwordField.text.length > 0) {
		[self save:saveButton];
	}
    return YES;
}

- (IBAction)cancel:(id)sender
{
	client.delegate = nil;
	[client release];
	client = nil;
	[WeiboEngine selectCurrentUser];
	[[ZhiWeiboAppDelegate getAppDelegate] closeAuthenticateView];
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender
{
    //saveButton.enabled = false;    
    /*
	[usernameField resignFirstResponder];
	[passwordField resignFirstResponder];
	[maskView setHidden:NO];
	
	[WeiboEngine setUsername:usernameField.text	password:passwordField.text remember:NO];

	client.delegate = nil;
	[client release];
    client = [[WeiboClient alloc] initWithTarget:self 
													   action:@selector(accountDidVerify:obj:)];
	[client verify];
    */
    if (!oAuth) {
		oAuth = [[OAuth alloc]init];
		oAuth.delegate = self;
	}

    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
							  usernameField.text, @"username",
							  passwordField.text, @"password",
							  nil];
    
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]
										initWithTarget:oAuth
										selector:@selector(synchronousAuthorizeTokenWithUserInfo:)
										object:userInfo];
	
	[queue addOperation:operation];
	[operation release];
     
    //[oAuth performSelectorInBackground:@selector(synchronousAuthorizeTokenWithUserInfo:) withObject:userInfo];
} 

- (IBAction)textFieldValueChanged:(UITextField *)textField;
{
	saveButton.enabled = usernameField.text.length > 0 && passwordField.text.length > 0;
}

- (void)loginFailed {
	[maskView setHidden:YES];
	NSString *title = NSLocalizedString(@"Verify Credential Error Title", nil);
	NSString *msg = NSLocalizedString(@"Verify Credential Error Message", nil);
	[[ZhiWeiboAppDelegate getAppDelegate] alert:title message:msg];
}

- (void) authorizeTokenDidSucceed:(OAuth *)_oAuth {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(authorizeTokenDidSucceed:)
							   withObject:_oAuth
							waitUntilDone:NO];
		return;
	}
	NSLog(@"authorizeTokenDidSucceed");
    WeiboClient *weiboClient = [[WeiboClient alloc]initWithTarget:self action:@selector(verifyCredentialsResult:obj:) oAuth:_oAuth];
	[weiboClient verify];
	
}

- (void) authorizeTokenDidFail:(OAuth *)_oAuth {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(authorizeTokenDidFail:)
							   withObject:_oAuth
							waitUntilDone:NO];
		return;
	}
	NSLog(@"authorizeTokenDidFail");
	[self loginFailed];
}


- (void) verifyCredentialsResult:(WeiboConnection*)sender 
							 obj:(NSObject*)obj {
	if (sender.hasError) {		
		NSLog(@"verifyCredentialsResult error!!!, errorMessage:%@, errordetail:%@"
			  , sender.errorMessage, sender.errorDetail);
        [sender release];
		[self loginFailed];
        return;
    }
	
    if (obj == nil || ![obj isKindOfClass:[NSDictionary class]]) {
		NSLog(@"verifyCredentialsResult data format error.%@", @"");
        [sender release];
		[self loginFailed];
        return;
    }
    
    
    NSDictionary *dic = (NSDictionary*)obj;
	User *user = [User userWithJsonDictionary:dic];
	NSLog(@"user: %@", user.screenName);
	
	WeiboAccount *account = [WeiboAccount accountWithUser:user oAuth:oAuth];
	[WeiboEngine addWeiboAccount:account selected:YES];
	
	[maskView setHidden:YES];
	usernameField.text = @"";
	passwordField.text = @"";
    
    [sender release];
    [[ZhiWeiboAppDelegate getAppDelegate] signIn:account];
	[self.parentViewController dismissModalViewControllerAnimated:YES];
    
}

- (void) requestTokenDidSucceed:(OAuth *)_oAuth {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(requestTokenDidSucceed:)
							   withObject:_oAuth
							waitUntilDone:NO];
		return;
	}
    
	NSLog(@"requestTokenDidSucceed");
	
}



- (void) requestTokenDidFail:(OAuth *)_oAuth {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(requestTokenDidFail:)
							   withObject:_oAuth
							waitUntilDone:NO];
		return;
	}
	NSLog(@"requestTokenDidFail");
}


@end
