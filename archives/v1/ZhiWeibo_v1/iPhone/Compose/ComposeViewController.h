//
//  ComposeViewController.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-23.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeView.h"
#import "WeiboClient.h"
#import "Draft.h"
#import "Status.h"
#import "UserNamesSearchViewController.h"
#import "TrendSearchViewController.h"
#import "CommonPhrasesViewController.h"

typedef enum {
	kResizeSmall,
	kResizeMedium,
	kResizeLarge,
	kResizeOriginal
} MediaResize;

@interface ComposeViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate,TrendSearchViewControllerDelegate,UserNamesSearchViewControllerDelegate> {
	UINavigationBar *navigationBar;
	UINavigationItem *titleItem;
	UIBarButtonItem *closeButton;
	UIBarButtonItem *sendButton;
	ComposeView *composeView;
	UIView *maskView;
	UIImageView *alertBackgroundView;
	
	IBOutlet UserNamesSearchViewController *userNamesSearchViewController;
	IBOutlet TrendSearchViewController *trendSearchViewController;
	IBOutlet CommonPhrasesViewController *commonPhrasesViewController;
}

@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, retain) IBOutlet UINavigationItem *titleItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *closeButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *sendButton;
@property (nonatomic, retain) IBOutlet UIView *maskView;
@property (nonatomic, retain) IBOutlet UIImageView *alertBackgroundView;

- (IBAction)closeButtonTouch:(id)sender;

- (IBAction)sendButtonTouch:(id)sender;

- (void)enableSendButton:(BOOL)enabled;

- (void)composeNewTweet;

- (void)replyTweet:(Status *)status comment:(Comment *)comment;

- (void)retweet:(Status*)status;

- (void)advise;

- (void)close;

- (void)showImagePicker:(BOOL)hasCamera;

- (void)beginCompress;

- (void)endCompress;

- (void)loadDraft:(Draft *)draft;

- (void)showUserNamesSearchViewController;

- (void)showTrendSearchViewController;

@end
