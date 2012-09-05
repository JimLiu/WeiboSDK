//
//  ComposeViewController.h
//  SinaWeiboOAuthDemo
//
//  Created by junmin liu on 11-1-4.
//  Copyright 2011 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Draft.h"
#import "SinaWeiboClient.h"
#import "Status.h"
#import "RequestFile.h"

@interface ComposeViewController : UIViewController {
	UIBarButtonItem *btnSend;
	UIBarButtonItem *btnCancel;
	UIBarButtonItem *btnInsert;
	UITextView *messageTextField;
	UIView *sendingView;
	UIImageView *attachmentImage;
	Draft *draft;
}

@property (nonatomic, retain) IBOutlet UITextView *messageTextField;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnSend;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnCancel;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnInsert;
@property (nonatomic, retain) IBOutlet UIView *sendingView;
@property (nonatomic, retain) IBOutlet UIImageView *imgAttachment;

- (void)newTweet;

- (IBAction)send:(id)sender;

- (IBAction)cancel:(id)sender;

- (IBAction)insert:(id)sender;

@end
