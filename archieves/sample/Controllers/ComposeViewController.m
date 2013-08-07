//
//  ComposeViewController.m
//  SinaWeiboOAuthDemo
//
//  Created by junmin liu on 11-1-4.
//  Copyright 2011 Openlab. All rights reserved.
//

#import "ComposeViewController.h"
#import <WeiboSDK/Status.h>

@interface ComposeViewController (Private)

- (void)postNewStatus;


@end

@implementation ComposeViewController
@synthesize btnSend, btnCancel, btnInsert, sendingView, imgAttachment;
@synthesize messageTextField;
@synthesize statusText = _statusText;

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(textChanged:) 
												 name:UITextViewTextDidChangeNotification 
											   object:messageTextField];
	
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

- (IBAction)send:(id)sender {
	[self postNewStatus];
	sendingView.hidden = NO;
}

- (IBAction)cancel:(id)sender {
	messageTextField.text = @"";
	imgAttachment.image = nil;
	sendingView.hidden = YES;
	
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)insert:(id)sender {
	UIImage *image = [UIImage imageNamed:@"Icon.png"];
	imgAttachment.image = image;
}

- (void)focusInput {
	[messageTextField becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    messageTextField.text = self.statusText;
	btnSend.enabled = messageTextField.text.length > 0;
	btnInsert.enabled = messageTextField.text.length > 0;
	[self focusInput];
}

- (void)textChanged:(NSNotification *)notification{
	int maxLength = 140;
	btnSend.enabled = messageTextField.text.length > 0;
	btnInsert.enabled = messageTextField.text.length > 0;
	if (messageTextField.text.length >= maxLength)
    {
        messageTextField.text = [messageTextField.text substringToIndex:maxLength];
    }
    self.statusText = messageTextField.text;
}


- (void)postNewStatus
{
    WeiboRequest *request = [[WeiboRequest alloc] initWithDelegate:self];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *postPath = imgAttachment.image ? @"statuses/upload.json" : @"statuses/update.json";
    [params setObject:messageTextField.text forKey:@"status"];
    if (imgAttachment.image) {
        [params setObject:imgAttachment.image forKey:@"pic"];
    }
    
    [request postToPath:postPath params:params];
    
	
}


- (void)request:(WeiboRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Failed to post: %@", error);
    [request release];
    sendingView.hidden = YES;
}

- (void)request:(WeiboRequest *)request didLoad:(id)result {
    Status *status = [Status statusWithJsonDictionary:result];
    NSLog(@"status id: %lld", status.statusId);
    sendingView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
    [request release];
}

@end
