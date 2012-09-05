//
//  CommentViewController.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-11.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "TweetUserView.h"
#import "Comment.h"
#import "WebViewController.h"
#import "PhotoViewController.h"
#import "MapViewController.h"
#import "UserTabBarController.h"
#import "TweetCommentsController.h"

@interface CommentViewController : UIViewController<MFMailComposeViewControllerDelegate,UIWebViewDelegate,UIActionSheetDelegate,MFMessageComposeViewControllerDelegate> {
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
	//UserTabBarController *userTabBarController;
	
	TweetCommentsController *commentsController;
	
	Comment *comment;
	
	WeiboClient *loadCommentCountsClient;
	UIActionSheet *actionButtonActionSheet;
}

@property (nonatomic, retain) IBOutlet TweetUserView *userView;
//@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet WebViewController *webViewController;
@property (nonatomic, retain) IBOutlet PhotoViewController *photoViewController;
@property (nonatomic, retain) IBOutlet MapViewController *mapViewController;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *replyButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *retweetButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *favoriteButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *actionButton;
@property (nonatomic, retain) Comment *comment;


- (void)loadHtml;

- (IBAction)didReplyButtonTouch:(id)sender;
- (IBAction)didRetweetButtonTouch:(id)sender;
- (IBAction)didFavoriteButtonTouch:(id)sender;
- (IBAction)didActionButtonTouch:(id)sender;

- (UIView *)getDocumentView;
- (void)loadCommentsCount;

@end
