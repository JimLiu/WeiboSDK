//
//  ComposeView.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-24.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Draft.h"
#import "ComposePanelView.h"
#import "LocationManager.h"
#import "UIImage+Resize.h"
#import "EmoticonNode.h"
#import "CheckBoxView.h"
#import "EmoticonsPopupView.h"
#import "EmoticonPreviewView.h"
#import "UITextViewAdditions.h"

@class ComposeViewController;

@interface ComposeView : UIView<UITextViewDelegate, UIActionSheetDelegate> {
	UITextView *tweetText;
	UIButton *disclosureButton;
	ComposePanelView *composePanel;
	EmoticonsPopupView *emoticonsPopupView;
	EmoticonPreviewView *emoticonPreviewView;
	UIImage *disclosureImage;
	UIImage *disclosureFlipImage;
	UIActivityIndicatorView*   geoTagIndicator;
	UIImageView *geotagImageView;
	UIButton *attachmentPreviewButton;
	CheckBoxView *retweetCheckbox;
	CheckBoxView *commentCurrentTweetCheckbox;
	CheckBoxView *commentOriginalTweetCheckbox;
	//UIImageView *attachmentPreviewImageView;
	ComposeViewController *composeViewController;
	
	Draft *draft;
	int maxLength;
	
	BOOL	recipientIsFirstResponder;
	BOOL canResponseEmotion;
    NSRange	textRange;

	UIButton *cameraButton;
	UIButton *photoLibraryButton;
	UIButton *geotagButton;
	UIButton *usernamesButton;
	UIButton *hashtagsButton;
	UIButton *emoticonsButton;
	
	LocationManager* locationManager;
	UIActionSheet *saveActionsheet;
}

@property (nonatomic, retain) Draft *draft;
@property (nonatomic, assign) ComposeViewController *composeViewController;
@property (nonatomic, assign) BOOL canResponseEmotion;

- (Draft *)getDraft;

- (void)imagePickerControllerDidDisappear;

- (void)setAttachmentImage:(UIImage *)postImage;

- (void)showAttachmentPreviewButton:(UIImage *)image;

- (void)close;

- (void)clear;

- (void)checkTextView;

- (void)loadDraft:(Draft *)_draft;

- (void)addTrend:(NSString*)trend;

- (void)addUserScreenName:(NSString *)userScreenName;

@end
