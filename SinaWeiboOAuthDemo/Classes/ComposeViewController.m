//
//  ComposeViewController.m
//  SinaWeiboOAuthDemo
//
//  Created by junmin liu on 11-1-4.
//  Copyright 2011 Openlab. All rights reserved.
//

#import "ComposeViewController.h"

@interface ComposeViewController (Private)

- (void)postNewStatus;


@end

@implementation ComposeViewController
@synthesize btnSend, btnCancel, btnInsert, sendingView, imgAttachment;
@synthesize messageTextField;

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
	
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (IBAction)insert:(id)sender {
	UIImage *image = [UIImage imageNamed:@"Icon.png"];
	if (draft) {
		draft.attachmentImage = image;
		imgAttachment.image = image;
	}
}

- (void)focusInput {
	[messageTextField becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
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
	draft.text = messageTextField.text;
}

- (void)newTweet {
	[draft release];
	draft = [[Draft alloc]initWithType:DraftTypeNewTweet];
	[self focusInput];
}

- (void)postNewStatus
{
	WeiboClient *client = [[WeiboClient alloc] initWithTarget:self 
													   engine:[OAuthEngine currentOAuthEngine]
													   action:@selector(postStatusDidSucceed:obj:)];
	client.context = [draft retain];
	draft.draftStatus = DraftStatusSending;
	if (draft.attachmentImage) {
		[client upload:draft.attachmentData status:draft.text];
	}
	else {
		[client post:draft.text];
	}
}

- (void)postStatusDidSucceed:(WeiboClient*)sender obj:(NSObject*)obj;
{
	Draft *sentDraft = nil;
	if (sender.context && [sender.context isKindOfClass:[Draft class]]) {
		sentDraft = (Draft *)sender.context;
		[sentDraft autorelease];
	}
	
    if (sender.hasError) {
        [sender alert];	
        return;
    }
    
    NSDictionary *dic = nil;
    if (obj && [obj isKindOfClass:[NSDictionary class]]) {
        dic = (NSDictionary*)obj;    
    }
	
    if (dic) {
        Status* sts = [Status statusWithJsonDictionary:dic];
		if (sts) {
			//delete draft!
			if (sentDraft) {
				
			}
		}
    }
	[self cancel:nil];
}


@end
