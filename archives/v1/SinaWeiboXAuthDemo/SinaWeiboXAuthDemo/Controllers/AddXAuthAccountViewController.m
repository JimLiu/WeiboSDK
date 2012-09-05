//
//  AddXAuthAccountViewController.m
//  SinaWeiboXAuthDemo
//
//  Created by junmin liu on 11-5-26.
//  Copyright 2011年 Openlab. All rights reserved.
//

#import "AddXAuthAccountViewController.h"


@implementation AddXAuthAccountViewController
@synthesize oAuth;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	
	[maskView setHidden:YES];
	queue = [[NSOperationQueue alloc] init];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	[queue release];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
	/*
     client.delegate = nil;
     [client release];
     client = nil;
     [WeiboEngine selectCurrentUser];
     [[ZhiWeiboAppDelegate getAppDelegate] closeAuthenticateView];
	 */
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender
{
    //saveButton.enabled = false;    
	[usernameField resignFirstResponder];
	[passwordField resignFirstResponder];
	[maskView setHidden:NO];
	if (!oAuth) {
		oAuth = [[SinaWeiboOAuth alloc]init];
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
	
	/*
     [WeiboEngine setUsername:usernameField.text	password:passwordField.text remember:NO];
     
     client.delegate = nil;
     [client release];
     client = [[WeiboClient alloc] initWithTarget:self 
     action:@selector(accountDidVerify:obj:)];
     [client verify];
	 */
}

/*
 - (void)accountDidVerify:(WeiboClient*)sender obj:(NSObject*)obj;
 {
 [client autorelease];
 client = nil;
 if (sender.hasError) {
 [sender alert];
 [maskView setHidden:YES];
 return;
 }
 
 
 NSDictionary *dic = nil;
 if (obj && [obj isKindOfClass:[NSDictionary class]]) {
 dic = (NSDictionary*)obj;    
 }
 
 if (dic) {
 User* user = [User userWithJsonDictionary:dic];
 NSLog(@"accountDidVerify id:%d", user.userId);
 if (user && user.userId > 0) {
 user.username = usernameField.text;
 [WeiboEngine addWeiboAccount:user selected:YES];
 maskView.hidden = NO;
 [WeiboEngine setUsername:usernameField.text	password:passwordField.text remember:YES];
 //[self dismissModalViewControllerAnimated:YES];
 [[ZhiWeiboAppDelegate getAppDelegate] signIn:user];
 [maskView setHidden:YES];
 usernameField.text = @"";
 passwordField.text = @"";
 return;
 }
 }
 maskView.hidden = NO;
 [[ZhiWeiboAppDelegate getAppDelegate]alert:@"微博开放接口错误" message:@"微博开放接口返回数据出错。请稍候重试！"];
 }
 */

- (IBAction)textFieldValueChanged:(UITextField *)textField;
{
	saveButton.enabled = usernameField.text.length > 0 && passwordField.text.length > 0;
}

- (void)loginFailed {
	[maskView setHidden:YES];
	NSString *title = @"认证失败";
	NSString *msg = @"登录失败，请重试！";

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                        message:msg
									   delegate:self
							  cancelButtonTitle:@"Close"
							  otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

- (void) authorizeTokenDidSucceed:(OAuth *)_oAuth {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(authorizeTokenDidSucceed:)
							   withObject:_oAuth
							waitUntilDone:NO];
		return;
	}
    [[WeiboEngine engine]setOAuth:_oAuth];
	NSLog(@"authorizeTokenDidSucceed");
	WeiboConnection *connection = [[_oAuth getWeiboConnectionWithDelegate:self 
																   action:@selector(verifyCredentialsResult:obj:)] retain];
	[connection verifyCredentials];
	
	
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
	
    [[WeiboEngine engine] setUser:user];
	
	[maskView setHidden:YES];
	usernameField.text = @"";
	passwordField.text = @"";
    
    [sender release];
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
