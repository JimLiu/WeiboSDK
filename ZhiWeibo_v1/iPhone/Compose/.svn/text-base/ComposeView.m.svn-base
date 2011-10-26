//
//  ComposeView.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-24.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "ComposeView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Alpha.h"
#import "ComposeViewController.h"

// This is defined in Math.h
#define M_PI   3.14159265358979323846264338327950288   /* pi */

// Our conversion definition
#define DEGREES_TO_RADIANS(angle) ((angle / 180.0) * M_PI)

@interface ComposeView (Private)

- (void)initViews;

- (void)initButtons;

- (UIImage *)maskImage:(UIImage *)image;

- (UIImage *)maskHighlightImage:(UIImage *)image;

- (void)showKeyboard;

- (void)hideKeyboard;

- (void)showImagePicker:(BOOL)hasCamera;

@end


@implementation ComposeView
@synthesize draft;
@synthesize composeViewController;
@synthesize canResponseEmotion;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		[self initViews];
		canResponseEmotion = NO;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		[self initViews];
		canResponseEmotion = NO;
	}
	return self;
}

- (void)initViews {
	CGFloat keyboardHeight= self.frame.size.width > self.frame.size.height ? 161 : 216;
	
	tweetText = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 
															self.frame.size.width, self.frame.size.height - keyboardHeight - 1 - 40)];
	disclosureButton = [[UIButton alloc] initWithFrame:
						CGRectMake(self.frame.size.width - 58 - 2, self.frame.size.height - keyboardHeight - 38 - 1, 58, 38)];
	geoTagIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	geotagImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mini-pin-classic.png"]];
	composePanel = [[ComposePanelView alloc]initWithFrame:
					CGRectMake(0, self.frame.size.height - keyboardHeight - 1, self.frame.size.width, keyboardHeight + 1)];
	
	emoticonsPopupView = [[EmoticonsPopupView alloc]initWithFrame:CGRectZero];
	emoticonsPopupView.hidden = YES;
	
	emoticonPreviewView = [[EmoticonPreviewView alloc]initWithFrame:CGRectZero];
	emoticonPreviewView.hidden = YES;
	
	disclosureImage = [[[UIImage imageNamed:@"compose-disclosure-classic.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:0] retain];
	disclosureFlipImage = [[[UIImage imageNamed:@"compose-disclosure-flip-classic.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:0] retain];
	[disclosureButton setBackgroundImage:disclosureImage forState:UIControlStateNormal];
	[disclosureButton setTitle:@"140" forState:UIControlStateNormal];
	
	attachmentPreviewButton = [[UIButton alloc] initWithFrame:
							   CGRectMake(2, self.frame.size.height - keyboardHeight - 38 - 1, 60, 38)];
	[attachmentPreviewButton setBackgroundImage:[UIImage imageNamed:@"compose-attachments-bg.png"] forState:UIControlStateNormal];
	attachmentPreviewButton.imageEdgeInsets = UIEdgeInsetsMake(0, 18, 0, 0);
	tweetText.font = [UIFont systemFontOfSize:16];
	tweetText.delegate = self;
	geotagImageView.hidden = YES;
	attachmentPreviewButton.hidden = YES;
	[self addSubview:tweetText];
	[self addSubview:composePanel];
	[self addSubview:geoTagIndicator];
	[self addSubview:geotagImageView];
	[self addSubview:disclosureButton];
	[self addSubview:attachmentPreviewButton];
	
	textRange.location  = [tweetText.text length];
	textRange.length    = 0;
	locationManager = [[LocationManager alloc] initWithDelegate:self]; 
	maxLength = 140;
	disclosureButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
	disclosureButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 16);
	[disclosureButton addTarget:self
						 action:@selector(disclosureButtonTouch:)
			   forControlEvents:UIControlEventTouchUpInside];	
	
	[self initButtons];
	[self addSubview:emoticonsPopupView];
	[self addSubview:emoticonPreviewView];
	
	saveActionsheet= [[UIActionSheet alloc] initWithTitle:nil delegate:self
										cancelButtonTitle:@"取消" destructiveButtonTitle:nil
										otherButtonTitles:@"保存", @"不保存", nil];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emoticonDidPicked:) name:@"EmoticonDidPicked" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emoticonDidHighlighted:) name:@"EmoticonDidHighlighted" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteStatusChar:) name:@"deleteStatusChar" object:nil];
}

- (void)initButtons {
	CGFloat width = composePanel.frame.size.width;
	CGFloat height = composePanel.frame.size.height;
	CGFloat y = composePanel.frame.origin.y + 1;

	CGFloat blockWidth = (width - 4) / 3;
	CGFloat blockHeight = (height - 2 - 1) / 2;
	
	cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(0, y, blockWidth, blockHeight)];
	photoLibraryButton = [[UIButton alloc] initWithFrame:CGRectMake(blockWidth + 2, y, blockWidth, blockHeight)];
	geotagButton = [[UIButton alloc] initWithFrame:CGRectMake(blockWidth * 2 + 4, y, blockWidth, blockHeight)];
	usernamesButton = [[UIButton alloc] initWithFrame:CGRectMake(0, blockHeight + y + 2, blockWidth, blockHeight)];
	hashtagsButton = [[UIButton alloc] initWithFrame:CGRectMake(blockWidth + 2, blockHeight + y + 2, blockWidth, blockHeight)];
	emoticonsButton = [[UIButton alloc] initWithFrame:CGRectMake(blockWidth * 2 + 3, blockHeight + y + 2, blockWidth, blockHeight)];
	
	[cameraButton setImage:[self maskImage:[UIImage imageNamed:@"compose-camera.png"]] 
				  forState:UIControlStateNormal];
	[cameraButton setTitle:@"拍照" forState:UIControlStateNormal];
	[photoLibraryButton setImage:[self maskImage:[UIImage imageNamed:@"compose-photolibrary.png"]] forState:UIControlStateNormal];
	[photoLibraryButton setTitle:@"相册" forState:UIControlStateNormal];
	[geotagButton setImage:[self maskImage:[UIImage imageNamed:@"geotag-pin-classic.png"]] forState:UIControlStateNormal];
	[geotagButton setImage:[self maskHighlightImage:[UIImage imageNamed:@"geotag-pin-classic.png"]] forState:UIControlStateSelected];
	[geotagButton setTitle:@"位置" forState:UIControlStateNormal];
	[usernamesButton setImage:[self maskImage:[UIImage imageNamed:@"compose-at.png"]] forState:UIControlStateNormal];
	[usernamesButton setTitle:@"好友" forState:UIControlStateNormal];
	[hashtagsButton setImage:[self maskImage:[UIImage imageNamed:@"compose-hash.png"]] forState:UIControlStateNormal];
	[hashtagsButton setTitle:@"话题" forState:UIControlStateNormal];
	[emoticonsButton setImage:[self maskImage:[UIImage imageNamed:@"compose-emoticons.png"]] forState:UIControlStateNormal];
	[emoticonsButton setTitle:@"表情" forState:UIControlStateNormal];
	
	retweetCheckbox = [[CheckBoxView alloc] initWithFrame:CGRectZero];
	commentCurrentTweetCheckbox = [[CheckBoxView alloc] initWithFrame:CGRectZero];
	commentOriginalTweetCheckbox = [[CheckBoxView alloc] initWithFrame:CGRectZero];
	retweetCheckbox.text = @"同时转发一条微博";
	commentCurrentTweetCheckbox.text = @"同时作为评论发布";
	commentOriginalTweetCheckbox.text = @"同时作为原文评论发布";

	retweetCheckbox.hidden = YES;
	commentCurrentTweetCheckbox.hidden = YES;
	commentOriginalTweetCheckbox.hidden = YES;
	
	[retweetCheckbox addTarget:self action:@selector(retweetCheckboxButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
	[commentCurrentTweetCheckbox addTarget:self action:@selector(commentCurrentTweetCheckboxButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
	[commentOriginalTweetCheckbox addTarget:self action:@selector(commentOriginalTweetCheckboxButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
	
	[self addSubview:cameraButton];
	[self addSubview:photoLibraryButton];
	[self addSubview:geotagButton];
	[self addSubview:usernamesButton];
	[self addSubview:hashtagsButton];
	[self addSubview:emoticonsButton];	
	[self addSubview:retweetCheckbox];
	[self addSubview:commentCurrentTweetCheckbox];
	[self addSubview:commentOriginalTweetCheckbox];
	
	BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
	cameraButton.enabled = hasCamera;
	
	[cameraButton addTarget:self
					 action:@selector(cameraButtonTouch:)
		   forControlEvents:UIControlEventTouchUpInside];	
	[photoLibraryButton addTarget:self
					 action:@selector(photoLibraryButtonTouch:)
		   forControlEvents:UIControlEventTouchUpInside];	
	[geotagButton addTarget:self
					 action:@selector(geotagButtonTouch:)
		   forControlEvents:UIControlEventTouchUpInside];	
	[usernamesButton addTarget:self
					 action:@selector(usernamesButtonTouch:)
		   forControlEvents:UIControlEventTouchUpInside];	
	[hashtagsButton addTarget:self
					 action:@selector(hashtagsButtonTouch:)
		   forControlEvents:UIControlEventTouchUpInside];	
	[emoticonsButton addTarget:self
					 action:@selector(emoticonsButtonTouch:)
		   forControlEvents:UIControlEventTouchUpInside];	
}


- (void)layoutSubviews {
	CGFloat keyboardHeight= self.frame.size.width > self.frame.size.height ? 161 : 216;
	tweetText.frame = CGRectMake(0, 0, 
								 self.frame.size.width, self.frame.size.height - keyboardHeight - 1 - 40);
	disclosureButton.frame = CGRectMake(self.frame.size.width - 58 - 2, self.frame.size.height - keyboardHeight - 38 - 1, 58, 38);
	geoTagIndicator.center = CGPointMake(disclosureButton.frame.origin.x - geoTagIndicator.frame.size.width / 2 - 2, disclosureButton.frame.origin.y + disclosureButton.frame.size.height / 2);
	geotagImageView.frame = CGRectMake(geoTagIndicator.center.x - 5, geoTagIndicator.center.y - 6, 10, 13);
	
	//if (composePanel.isCommentMode) {
	//	composePanel.frame = CGRectMake(0, self.frame.size.height - keyboardHeight / 2 - 1, self.frame.size.width, keyboardHeight / 2 + 1);		
	//}
	//else {
		composePanel.frame = CGRectMake(0, self.frame.size.height - keyboardHeight - 1, self.frame.size.width, keyboardHeight + 1);
	//}

	emoticonsPopupView.frame = composePanel.frame;
	[emoticonsPopupView setNeedsLayout];
	[composePanel setNeedsDisplay];
	
	attachmentPreviewButton.frame = CGRectMake(2, self.frame.size.height - keyboardHeight - 38 - 1, 60, 38);
	
	CGFloat width = composePanel.frame.size.width;
	CGFloat height = composePanel.frame.size.height;
	CGFloat y = composePanel.frame.origin.y + 1;
	CGFloat blockWidth = (width - 4) / 3;
	CGFloat blockHeight = (height - 2 - 1) / 2;
	cameraButton.frame = CGRectMake(0, y, blockWidth, blockHeight);
	photoLibraryButton.frame = CGRectMake(blockWidth + 2, y, blockWidth, blockHeight);
	geotagButton.frame = CGRectMake(blockWidth * 2 + 4, y, blockWidth, blockHeight);
	
	CGFloat buttonY = composePanel.isCommentMode ? self.frame.size.height - keyboardHeight / 2 + 3 : blockHeight + y + 2;
	usernamesButton.frame = CGRectMake(0, buttonY, blockWidth, blockHeight);
	hashtagsButton.frame = CGRectMake(blockWidth + 2, buttonY, blockWidth, blockHeight);
	emoticonsButton.frame = CGRectMake(blockWidth * 2 + 3, buttonY, blockWidth, blockHeight);

	if (draft.draftType == DraftTypeReTweet) {
		if (draft.replyToStatus.retweetedStatus) { // 是转发，显示两个选项
			commentCurrentTweetCheckbox.frame = CGRectMake(20, y + (blockHeight - 60) / 2, width - 30, 26);
			commentOriginalTweetCheckbox.frame = CGRectMake(20, y + (blockHeight - 60) / 2 + 35, width - 30, 26);
		}
		else {
			commentCurrentTweetCheckbox.frame = CGRectMake(20, y + (blockHeight - 26) / 2, width - 30, 26);
		}
	}
	else if (draft.draftType == DraftTypeReplyComment) {
		if (draft.replyToStatus.retweetedStatus) { // 是转发，显示两个选项
			retweetCheckbox.frame = CGRectMake(20, y + (blockHeight - 60) / 2, width - 30, 26);
			commentOriginalTweetCheckbox.frame = CGRectMake(20, y + (blockHeight - 60) / 2 + 35, width - 30, 26);
		}
		else {
			retweetCheckbox.frame = CGRectMake(20, y + (blockHeight - 26) / 2, width - 30, 26);
		}
	}
}

- (Draft *)getDraft {
	if (draft.draftType == DraftTypeReTweet) {
		if (draft.replyToStatus.retweetedStatus) { // 是转发，显示两个选项
			draft.commentToOriginalStatus = commentOriginalTweetCheckbox.isChecked;
		}
		draft.comment = commentCurrentTweetCheckbox.isChecked;
	}
	else if (draft.draftType == DraftTypeReplyComment) {
		if (draft.replyToStatus.retweetedStatus) { // 是转发，显示两个选项
			draft.commentToOriginalStatus = commentOriginalTweetCheckbox.isChecked;
		}
		draft.retweet = retweetCheckbox.isChecked;
	}
	return draft;
}

- (void)dealloc {
	[draft release];
	[disclosureImage release];
	[disclosureFlipImage release];
	[attachmentPreviewButton release];
	[tweetText release];
	[disclosureButton release];
	[geoTagIndicator release];
	[composePanel release];
	[emoticonsPopupView release];
	[emoticonPreviewView release];
	[locationManager release];
	[saveActionsheet release];
	[retweetCheckbox release];
	[commentCurrentTweetCheckbox release];
	[commentOriginalTweetCheckbox release];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}


- (void)setControls {
	composePanel.isCommentMode = draft.draftType != DraftTypeNewTweet;
	if (composePanel.isCommentMode) {
		cameraButton.hidden = YES;
		photoLibraryButton.hidden = YES;
		geotagButton.hidden = YES;		
	}
	else {
		cameraButton.hidden = NO;
		photoLibraryButton.hidden = NO;
		geotagButton.hidden = NO;		
	}
	
	if (draft.draftType == DraftTypeReTweet) {
		retweetCheckbox.hidden = YES;
		commentCurrentTweetCheckbox.hidden = NO;
		commentOriginalTweetCheckbox.hidden = !draft.replyToStatus.retweetedStatus;
	}
	else if (draft.draftType == DraftTypeReplyComment) {
		retweetCheckbox.hidden = NO;
		commentCurrentTweetCheckbox.hidden = YES;
		commentOriginalTweetCheckbox.hidden = !draft.replyToStatus.retweetedStatus;
	}
	else {
		retweetCheckbox.hidden = YES;
		commentCurrentTweetCheckbox.hidden = YES;
		commentOriginalTweetCheckbox.hidden = YES;
	}

	
	[self setNeedsLayout];
}

- (void)setDraft:(Draft *)_draft {
	if (draft != _draft) {
		[draft release];
		draft = [_draft retain];
		if (draft.draftType == DraftTypeReTweet) {
			if (draft.replyToStatus.retweetedStatus) {
				tweetText.text = [NSString stringWithFormat:@" //@%@:%@", draft.replyToStatus.user.screenName, draft.replyToStatus.text];
				textRange = NSMakeRange(0, 0);
			}
			else {
				tweetText.text = @"转发微博";
				textRange = NSMakeRange(0, 4);
			}
		}
		else if (draft.draftType == DraftTypeReplyComment) {
			if (draft.replyToComment) {
				tweetText.text = [NSString stringWithFormat:@"回复@%@: ", draft.replyToComment.user.screenName];
				textRange = NSMakeRange(tweetText.text.length - 1, 0);
			}
		}

		[self textViewDidChange:tweetText];
		[self setControls];
	}
}

- (void)deleteStatusChar:(NSNotification*)notification {
	if (canResponseEmotion) {
		if (notification == nil) return;
		tweetText.selectedRange = textRange;
		[tweetText deleteChar];
	}
}

- (void)emoticonDidHighlighted:(NSNotification*)notification {
	if (canResponseEmotion) {
		if (notification == nil) return;
		
		EmoticonNode *node = (EmoticonNode *)[notification object];
		if (node) {
			emoticonPreviewView.hidden = NO;
			CGRect frame = CGRectMake(composePanel.frame.origin.x + node.bounds.origin.x - 17, 
									  composePanel.frame.origin.y + node.bounds.origin.y - 50,
									  80, 120);
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
			tweetText.selectedRange = textRange;
			[tweetText insertString:phrase];
			textRange = tweetText.selectedRange;
			[self textViewDidChange:tweetText];
		}
	}
}

- (void)cameraButtonTouch:(id)sender {
	[self showImagePicker:YES];
}

- (void)photoLibraryButtonTouch:(id)sender {
	[self showImagePicker:NO];
}

- (void)geotagButtonTouch:(id)sender {
	if (!locationManager.isUpdating) {
		if (draft.latitude != 0 || draft.longitude != 0) {
			draft.latitude = draft.longitude = 0;
			[geoTagIndicator stopAnimating];
			geotagButton.selected = NO;
			geotagImageView.hidden = YES;
		}
		else {
			[geoTagIndicator startAnimating];
			[locationManager getCurrentLocation];
			geotagButton.selected = YES;
		}		
	}
	[self showKeyboard];
}

- (void)usernamesButtonTouch:(id)sender {
	[composeViewController showUserNamesSearchViewController];
}

- (void)hashtagsButtonTouch:(id)sender {
	[composeViewController showTrendSearchViewController];
}

- (void)emoticonsButtonTouch:(id)sender {
	emoticonsPopupView.hidden = NO;
	emoticonsPopupView.opaque = 0;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	emoticonsPopupView.opaque = 0.8;
	[UIView commitAnimations];
}

- (void)showKeyboard
{
    tweetText.selectedRange = textRange;
    [tweetText becomeFirstResponder];
	emoticonsPopupView.hidden = YES;
	[self performSelector:@selector(selectRange) withObject:nil afterDelay:0.5];
}

- (void)selectRange { 
	tweetText.selectedRange = textRange;
}

- (void)hideKeyboard {
	textRange = tweetText.selectedRange;
	[tweetText resignFirstResponder];
}

- (void)imagePickerControllerDidDisappear
{
}

- (void)flipDisclosureButton {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.25];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationBeginsFromCurrentState:YES];
	CGAffineTransform transform;
	CGAffineTransform transform2;
	if (recipientIsFirstResponder) {
		transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(180));
		transform2 = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(180));
		[disclosureButton setBackgroundImage:disclosureFlipImage forState:UIControlStateNormal];
	}
	else {
		transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0));
		transform2 = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0));
		[disclosureButton setBackgroundImage:disclosureImage forState:UIControlStateNormal];
	}
	disclosureButton.titleLabel.transform = transform2;
	disclosureButton.transform = transform;
	[UIView commitAnimations];	
}

- (void)disclosureButtonTouch:(id)sender {

	if (!recipientIsFirstResponder) {
		[self showKeyboard];
	}
	else {
		[self hideKeyboard];
	}
	
}


- (void)showImagePicker:(BOOL)hasCamera
{
    [composeViewController showImagePicker:hasCamera];
}

- (void)setAttachmentImage:(UIImage *)postImage {
	draft.attachmentImage = postImage;
	[draft save];
	[self showAttachmentPreviewButton:postImage];
}

- (void)showAttachmentPreviewButton:(UIImage *)image {
	UIImage *previewImage = [image imageScaledToSizeWithSameAspectRatio:CGSizeMake(24, 20)];
	[attachmentPreviewButton setImage:previewImage forState:UIControlStateNormal];
	attachmentPreviewButton.hidden = NO;
}

- (void)deleteAttachmentImage {
	draft.attachmentImage = nil;
	[draft save];
	[attachmentPreviewButton setImage:nil forState:UIControlStateNormal];
	attachmentPreviewButton.hidden = YES;	
}

- (void)clear {
	tweetText.text = @"";
	[draft release];
	draft = nil;
	[geoTagIndicator stopAnimating];
	geotagImageView.hidden = YES;
	geotagButton.selected = NO;
	[attachmentPreviewButton setImage:nil forState:UIControlStateNormal];
	attachmentPreviewButton.hidden = YES;
	retweetCheckbox.isChecked = NO;
	commentCurrentTweetCheckbox.isChecked = NO;
	commentOriginalTweetCheckbox.isChecked = NO;
}

- (void)close {
	if (draft.text.length > 0 || draft.attachmentData)
    {
		[saveActionsheet showInView:self];
    }	
	else {
		[draft delete];
		[self clear];
		[composeViewController close];
	}

}

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (actionSheet == saveActionsheet) {
		if (buttonIndex == 0) {
			//[draft updateDB];
			[draft save];
			[self clear];
			[composeViewController close];
		}
		else if (buttonIndex == 1) {
			//[draft deleteFromDB];
			[draft delete];
			[self clear];
			[composeViewController close];
		}
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {

}

//
// UITextViewDelegate
//
- (void)textViewDidChangeSelection:(UITextView *)textView
{
    textRange = tweetText.selectedRange;
}

- (void)checkTextView {
	BOOL enabled = tweetText.text.length > 0;
	[composeViewController enableSendButton:enabled];
}

- (void)textViewDidChange:(UITextView *)textView
{
    //[postView setCharCount];
	if (tweetText.text.length >= maxLength)
    {
        tweetText.text = [tweetText.text substringToIndex:maxLength];
    }
	draft.text = tweetText.text;
    //textRange = tweetText.selectedRange;
	int count = maxLength - [tweetText text].length;
	[disclosureButton setTitle:[NSString stringWithFormat:@"%d", count] forState:UIControlStateNormal];
	BOOL enabled = tweetText.text.length > 0;
	[composeViewController enableSendButton:enabled];
	if (enabled) {
		[draft save];
	}
	else {
		[draft delete];
	}

}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    recipientIsFirstResponder = YES;
	[self flipDisclosureButton];
	emoticonsPopupView.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    recipientIsFirstResponder = NO;
	//textRange = tweetText.selectedRange;
	[self flipDisclosureButton];
}

//
// UITextFieldDelegate
//
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    recipientIsFirstResponder = true;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([str length] == 0) {
        //sendButton.enabled = false;
    }
    else {
        int length = 140 - [tweetText.text length];
        if (length == 140) {
            //sendButton.enabled = false;
        }
        else if (length < 0) {
            //sendButton.enabled = false;
        }
        else {
            //sendButton.enabled = true;
        }
    }
    return true;
}


- (void)locationManagerDidReceiveLocation:(LocationManager*)manager location:(CLLocation*)location
{
    [geoTagIndicator stopAnimating];
    draft.latitude  = location.coordinate.latitude;
    draft.longitude = location.coordinate.longitude;
	[draft save];
	geotagImageView.hidden = NO;
}

- (void)locationManagerDidFail:(LocationManager*)manager
{
    [geoTagIndicator stopAnimating];
	geotagImageView.hidden = YES;
	geotagButton.selected = NO;
}



- (UIImage *)maskImage:(UIImage *)image {
	return [image maskWithColor:[UIColor colorWithWhite:0xFF/255.0F alpha:1] shadowColor:[UIColor blackColor]
				   shadowOffset:CGSizeMake(0, 1)
					 shadowBlur:2];
}

- (UIImage *)maskHighlightImage:(UIImage *)image {
	return [image maskWithColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"geotag-background.png"]] shadowColor:[UIColor blackColor]
				   shadowOffset:CGSizeMake(0, 1)
					 shadowBlur:2];
}

- (void)retweetCheckboxButtonTouch:(id)sender {
	draft.retweet = retweetCheckbox.isChecked;
	[draft save];
}

- (void)commentCurrentTweetCheckboxButtonTouch:(id)sender {
	draft.comment = commentCurrentTweetCheckbox.isChecked;
	[draft save];
}

- (void)commentOriginalTweetCheckboxButtonTouch:(id)sender {
	draft.commentToOriginalStatus = commentCurrentTweetCheckbox.isChecked;
	[draft save];
}

- (void)loadDraft:(Draft *)_draft {
	draft = [_draft retain];
	tweetText.text = _draft.text;
	textRange.location = draft.text.length;
	[self showKeyboard];
	[self setControls];
	if(_draft.draftType == DraftTypeNewTweet) {
		if(_draft.attachmentImage)
			[self showAttachmentPreviewButton:_draft.attachmentImage];
		if(_draft.latitude + _draft.longitude != 0)
			geotagImageView.hidden = NO;
	}
	retweetCheckbox.isChecked = _draft.retweet;
	commentCurrentTweetCheckbox.isChecked = _draft.comment;
	commentOriginalTweetCheckbox.isChecked = _draft.commentToOriginalStatus;
	//NSLog(@"%@,  %@",NSStringFromRange(tweetText.selectedRange),NSStringFromRange(textRange));
}

- (void)addTrend:(NSString*)trend {
	if (trend && [trend isEqualToString:@""]) {
		return;
	}
	tweetText.selectedRange = textRange;
	[tweetText insertString:trend];
	textRange = tweetText.selectedRange;
	[self textViewDidChange:tweetText];
	[tweetText becomeFirstResponder];
}

- (void)addUserScreenName:(NSString *)userScreenName {
	if (userScreenName && [userScreenName isEqualToString:@""]) {
		return;
	}
	tweetText.selectedRange = textRange;
	[tweetText insertString:[NSString stringWithFormat:@"%@ ",userScreenName]];
	textRange = tweetText.selectedRange;
	[self textViewDidChange:tweetText];
	[tweetText becomeFirstResponder];
}

@end
