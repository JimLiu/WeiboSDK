//
//  TweetViewController.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-25.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "TweetUserView.h"
#import "Status.h"
#import "TweetCommentsController.h"
#import "WebViewController.h"
#import "PhotoViewController.h"
#import "MapViewController.h"
#import "UserTabBarController.h"
#import "PathHelper.h"

@interface TweetViewController : UIViewController<MFMailComposeViewControllerDelegate,UIWebViewDelegate,UIActionSheetDelegate,MFMessageComposeViewControllerDelegate>{
	TweetUserView *userView;
	UIWebView *webView;
	UIToolbar *toolbar;
	UIBarButtonItem *replyButton;
	UIBarButtonItem *retweetButton;
	UIBarButtonItem *favoriteButton;
	UIBarButtonItem *actionButton;
	WebViewController *webViewController;
	PhotoViewController *photoViewController;
	MapViewController *mapViewController;
	
	UIImage *favoritedImage;
	UIImage *unfavoritedImage;

	TweetCommentsController *commentsController;
	Status *status;
	
	WeiboClient *favoriteClient;
	WeiboClient *loadCommentCountsClient;	
	
	UIActionSheet *actionButtonActionSheet;
	
}

@property (nonatomic, retain) IBOutlet TweetUserView *userView;
//@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet TweetCommentsController *commentsController;
@property (nonatomic, retain) IBOutlet WebViewController *webViewController;
@property (nonatomic, retain) IBOutlet PhotoViewController *photoViewController;
@property (nonatomic, retain) IBOutlet MapViewController *mapViewController;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *replyButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *retweetButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *favoriteButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *actionButton;
@property (nonatomic, retain) Status *status;
@property (nonatomic, retain) UIImage *favoritedImage;
@property (nonatomic, retain) UIImage *unfavoritedImage;


- (void)loadHtml;

- (IBAction)didReplyButtonTouch:(id)sender;
- (IBAction)didRetweetButtonTouch:(id)sender;
- (IBAction)didFavoriteButtonTouch:(id)sender;
- (IBAction)didActionButtonTouch:(id)sender;

@end
