//
//  ConversationController.m
//  ZhiWeibo
//
//  Created by junmin liu on 11-1-3.
//  Copyright 2011 Openlab. All rights reserved.
//

#import "ConversationController.h"
#import "AppDelegate_iPhone.h"
#import "WeiboEngine.h"
#import "UserTabBarController.h"
#import "TrendsTimelineController.h"
#import "WebViewController.h"

#define txtViewEdgeInsetX 44
#define txtViewEdgeInsetY 6
#define txtViewWidth 206
#define txtViewHeight 35

#define txtMaxLength 300

@interface ConversationController (Private)

- (void)registerForKeyboardNotifications;

@end


@implementation ConversationController
@synthesize tableView;
@synthesize conversation;
@synthesize txtBackgrounView;
@synthesize conversationControllerDelegate;
@synthesize webViewController;
@synthesize btnEmotion,btnKeyboard;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		dataSource = [[ConversationDataSource alloc]initWithTableView:tableView];
		dataSource.conversationDataSourceDelegate = self;
		self.hidesBottomBarWhenPushed = YES;
		//[self registerForKeyboardNotifications];
		
		canResponseEmotion = NO;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emoticonDidPicked:) name:@"EmoticonDidPicked" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emoticonDidHighlighted:) name:@"EmoticonDidHighlighted" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteStatusChar:) name:@"deleteStatusChar" object:nil];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		dataSource = [[ConversationDataSource alloc]initWithTableView:tableView];
		dataSource.conversationDataSourceDelegate = self;
		self.hidesBottomBarWhenPushed = YES;
		//[self registerForKeyboardNotifications];
		
		canResponseEmotion = NO;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emoticonDidPicked:) name:@"EmoticonDidPicked" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emoticonDidHighlighted:) name:@"EmoticonDidHighlighted" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteStatusChar:) name:@"deleteStatusChar" object:nil];
	}
	return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	dataSource.tableView = tableView;
	dataSource.conversationDataSourceDelegate = self;
	UIColor *backgroundColor = [UIColor colorWithRed:0xE2/255.F green:0xE7/255.F blue:0xED/255.f alpha:1.0];
	self.view.backgroundColor = backgroundColor;
	tableView.backgroundColor = [UIColor clearColor];
	if (!emoticonsPopupView) {
		emoticonsPopupView = [[EmoticonsPopupView alloc] initWithFrame:CGRectMake(0, 480, 320, 216)];
	}
	if (!emoticonPreviewView) {
		emoticonPreviewView = [[EmoticonPreviewView alloc]initWithFrame:CGRectZero];
	}
	[self.view addSubview:emoticonsPopupView];
	[self.view addSubview:emoticonPreviewView];
	if (!txtView) {
		txtView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(txtViewEdgeInsetX, txtViewEdgeInsetY, txtViewWidth, txtViewHeight)];
	}
	[txtView setBackground:[[UIImage imageNamed:@"directmessage_textview.png"] stretchableImageWithLeftCapWidth:30 topCapHeight:17]];
	[txtBackgrounView addSubview:txtView];
	txtView.delegate = self;
	txtView.minNumberOfLines = 1;
	txtView.maxNumberOfLines = 6;
	txtView.font = [UIFont boldSystemFontOfSize:15.0f];
	txtBackgrounView.image = [[UIImage imageNamed:@"directmessage_toolbarbackground.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:23];
	//txtBackgrounView.image = [[UIImage imageNamed:@""] stretchableImageWithLeftCapWidth:15 topCapHeight:5];
}

- (void)viewWillAppear:(BOOL)animated {
	canResponseEmotion = YES;
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[txtView resignFirstResponder];
	if (emotionViewShown) {
		emoticonsPopupView.frame = CGRectMake(0, 480, 320, 216);
		emotionViewShown = NO;
		[self initFrame];
	}
	canResponseEmotion = NO;
	[super viewWillDisappear:animated];
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
	[dataSource release];
	[conversation release];
	[txtView release];
    [super dealloc];
}

- (void)resendDraft:(DirectMessageDraft *)_draft {
	[conversationControllerDelegate sendDirectMessage:_draft];
}

- (void)processTweetNode:(TweetNode *)node {
	TweetLinkNode *linkNode = (TweetLinkNode*)node;
	NSString *command = linkNode.url;
	if ([command isMatchedByRegex:@"https?://[a-zA-Z0-9\\-.]+(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?"]) {
		[self.navigationController pushViewController:webViewController animated:YES];
		NSURL *url = [NSURL URLWithString:command];
		[webViewController loadUrl:url];
	}
	else if ([command hasPrefix:@"@"]) {
		UserTabBarController *userTabBarController = [[[UserTabBarController alloc] initWithoutNib] autorelease];
		[userTabBarController loadUserByScreenName:[command substringFromIndex:1]];
		[self.navigationController pushViewController:userTabBarController animated:YES];
	}
	else if ([command isMatchedByRegex:@"#[^#]+#"]) {
		NSString *trend = [command substringWithRange:NSMakeRange(1, command.length - 2)];
		TrendsTimelineController *c = [[[TrendsTimelineController alloc] initWithTrendsName:trend] autorelease];
		c.title = trend;
		[self.navigationController pushViewController:c animated:YES];
	}
}

- (void)initFrame {
	CGSize size = txtView.internalTextView.contentSize;
	if ([txtView.text isEqualToString:@""]) {
		size.height = txtViewHeight;
	}
	txtBackgrounView.frame = CGRectMake(txtBackgrounView.frame.origin.x, (keyboardShown||emotionViewShown?200:416) - size.height - 12, txtBackgrounView.frame.size.width, size.height + 12);
	txtView.frame = CGRectMake(txtView.frame.origin.x, txtView.frame.origin.y, txtView.frame.size.width, size.height);
	tableView.frame = CGRectMake(0, 0,tableView.frame.size.width , (keyboardShown||emotionViewShown?200:416) - txtBackgrounView.frame.size.height);
	int scrollTo = [tableView numberOfRowsInSection:0] - 1;
	if (scrollTo >= 0) {
		[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:scrollTo inSection:0] 
						 atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	}
	//NSLog(@"%@",NSStringFromCGSize(txtView.internalTextView.contentSize));
	//NSLog(@"%@",NSStringFromCGRect(txtView.frame));
}


- (void)setConversation:(Conversation *)_conversation {
	if (conversation != _conversation) {
		[conversation release];
		txtView.text = @"";
		conversation = [_conversation retain];
		//NSLog(@"%@",conversation.draft);
		dataSource.conversation = conversation;
		txtView.text = conversation.draft;
		[self initFrame];
		//NSLog(@"%@",NSStringFromCGSize(txtView.internalTextView.contentSize));
		emotionViewShown = NO;
		keyboardShown = NO;
		emoticonPreviewView.hidden = YES;
	}
}

- (void)reloadDataSource {
	if (dataSource.conversation) {
		[dataSource reset];
	}
}

- (void)deleteStatusChar:(NSNotification*)notification {
	if (canResponseEmotion) {
		if (notification == nil || textRange.location <= 0) return;
		NSMutableString *text = [NSMutableString stringWithString:txtView.text];
		[text deleteCharactersInRange:NSMakeRange(textRange.location - 1, 1)];
		textRange.location -= 1;
		txtView.text = [NSString stringWithString:text];
	}
}

- (void)emoticonDidHighlighted:(NSNotification*)notification {
	if (canResponseEmotion) {
		if (notification == nil) return;
		
		EmoticonNode *node = (EmoticonNode *)[notification object];
		if (node) {
			emoticonPreviewView.hidden = NO;
			CGRect frame = CGRectMake(emoticonsPopupView.frame.origin.x + node.bounds.origin.x - 17, 
									  emoticonsPopupView.frame.origin.y + node.bounds.origin.y - 50,
									  80, 120);
			//NSLog(@"%@,  %@",NSStringFromCGRect(frame),NSStringFromCGRect(self.view.frame));
			emoticonPreviewView.frame = frame;
			emoticonPreviewView.emoticonNode = node;
		}
		else {
			emoticonPreviewView.hidden = YES;
		}
	}
}

- (void)emoticonDidPicked:(NSNotification*)notification {
	if (canResponseEmotion) {
		if (notification == nil) return;
		
		NSString *phrase = (NSString *)[notification object];
		
		if (phrase) {
			NSMutableString *text = [NSMutableString stringWithString:txtView.text];
			//NSLog(@"%@",NSStringFromRange(txtView.selectedRange));
			if (textRange.location != NSNotFound) {
				[text insertString:phrase atIndex:textRange.location];
				textRange.location += phrase.length;
			}
			else {
				[text appendString:phrase];
				textRange.location = text.length;
			}

			
			txtView.text = [NSString stringWithString:text];
		}
	}
}


/*
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasShown:)
												 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasHidden:)
												 name:UIKeyboardWillHideNotification object:nil];
	keyboardShown = NO;
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if (keyboardShown) {
        return;
	}
	keyboardShown = YES;
    NSDictionary* info = [aNotification userInfo];
    NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    aValue = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
	NSTimeInterval animationDuration;
	[aValue getValue:&animationDuration];
	UIViewAnimationCurve animationCurve;
	aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
	[aValue getValue:&animationCurve];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:animationDuration];
	[UIView setAnimationCurve:animationCurve];
	
	self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - keyboardSize.height);
	[self initFrame];
	[UIView commitAnimations];
	//NSLog(@"%@",NSStringFromCGRect(self.view.frame));
	//NSLog(@"%f,%d",animationDuration,animationCurve);
	
}


// Called when the UIKeyboardDidHideNotification is sent
- (void)keyboardWasHidden:(NSNotification*)aNotification
{
	if (!keyboardShown) {
		return;
	}
	keyboardShown = NO;
    NSDictionary* info = [aNotification userInfo];
    NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    aValue = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
	NSTimeInterval animationDuration;
	[aValue getValue:&animationDuration];
	UIViewAnimationCurve animationCurve;
	aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
	[aValue getValue:&animationCurve];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:animationDuration];
	[UIView setAnimationCurve:animationCurve];
	self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height + keyboardSize.height);
	[self initFrame];
	[UIView commitAnimations];
	//NSLog(@"%@",NSStringFromCGRect(self.view.frame));
	NSLog(@"%f,%d",animationDuration,animationCurve);
}
*/

- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView {
	btnEmotion.hidden = NO;
	btnKeyboard.hidden = YES;
	keyboardShown = YES;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:0];
	//self.view.frame = CGRectMake(0, 0, 320, 200);
	[self initFrame];
	[UIView commitAnimations];
	return YES;
}

- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView {
	emoticonsPopupView.frame = CGRectMake(0, 480, 320, 216);
	emotionViewShown = NO;
}

- (BOOL)growingTextViewShouldEndEditing:(HPGrowingTextView *)growingTextView{
	keyboardShown = NO;
	if (emotionViewShown) {
		[self initFrame];
	}
	else {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationCurve:0];
		//self.view.frame = CGRectMake(0, 0, 320, 416);
		[self initFrame];
		[UIView commitAnimations];
	}
	return YES;
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView {
	if (growingTextView.text.length >= txtMaxLength) {
		growingTextView.text = [growingTextView.text substringToIndex:txtMaxLength];
		[[AppDelegate_iPhone getAppDelegate] alert:@"错误" message:@"私信字数不能超过300"];
		return;
	}
	conversation.draft = txtView.text;
	textRange = growingTextView.selectedRange;
	//NSLog(@"%@",NSStringFromRange(textRange));
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
	CGRect r = txtView.frame;
	r.size.height = height;
	txtView.frame = r;
	//NSLog(@"%f,%@",height,NSStringFromCGRect(txtView.frame));
	[self initFrame];
}

- (void)growingTextViewDidChangeSelection:(HPGrowingTextView *)growingTextView {
	textRange = growingTextView.selectedRange;
	//NSLog(@"%@",NSStringFromRange(textRange));
}


- (void)hideKeyboard {
	btnEmotion.hidden = NO;
	btnKeyboard.hidden = YES;
	if (emotionViewShown) {
		emotionViewShown = NO;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationCurve:0];
		[self initFrame];
		emoticonsPopupView.frame = CGRectMake(0, 480, 320, 216);
		[UIView commitAnimations];
	}
}

- (IBAction)btnSendTouched:(id)sender {
	if (![txtView.text isEqualToString:@""]) {
		DirectMessageDraft *draft = [[DirectMessageDraft alloc] init];
		draft.text = txtView.text;
		draft.recipientId = conversation.conversationId - draft.senderId;
		[conversationControllerDelegate sendDirectMessage:draft];
		[draft release];
		conversation.draft = @"";
		textRange = NSMakeRange(0, 0);
		txtView.text = @"";
		textRange.location = 0;
		txtView.frame = CGRectMake(txtViewEdgeInsetX, txtViewEdgeInsetY, txtViewWidth, txtViewHeight);
		[txtView resignFirstResponder];
	}
}

- (IBAction)btnEmotionTouched:(id)sender{
	btnEmotion.hidden = YES;
	btnKeyboard.hidden = NO;
	if (keyboardShown) {
		emoticonsPopupView.frame = CGRectMake(0, 200, 320, 216);
		keyboardShown = NO;
		emotionViewShown = YES;
		[txtView.internalTextView resignFirstResponder];
	}
	else {
		emotionViewShown = YES;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationCurve:0];
		[self initFrame];
		emoticonsPopupView.frame = CGRectMake(0, 200, 320, 216);
		[UIView commitAnimations];
	}
}

- (IBAction)btnKeyboardTouched:(id)sender{
	btnEmotion.hidden = NO;
	btnKeyboard.hidden = YES;
	[txtView.internalTextView becomeFirstResponder];
	//emoticonsPopupView.frame = CGRectMake(0, 480, 320, 216);
}

@end
