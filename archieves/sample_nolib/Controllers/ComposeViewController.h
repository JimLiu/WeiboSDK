//
//  ComposeViewController.h
//  SinaWeiboOAuthDemo
//
//  Created by junmin liu on 11-1-4.
//  Copyright 2011 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboRequest.h"
#import "Status.h"

@interface ComposeViewController : UIViewController<WeiboRequestDelegate> {
	UIBarButtonItem *btnSend;
	UIBarButtonItem *btnCancel;
	UIBarButtonItem *btnInsert;
	UITextView *messageTextField;
	UIView *sendingView;
	UIImageView *attachmentImage;
	
    NSString *_statusText;
    
}

@property (nonatomic, retain) IBOutlet UITextView *messageTextField;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnSend;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnCancel;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnInsert;
@property (nonatomic, retain) IBOutlet UIView *sendingView;
@property (nonatomic, retain) IBOutlet UIImageView *imgAttachment;

@property (nonatomic, copy) NSString *statusText;

- (IBAction)send:(id)sender;

- (IBAction)cancel:(id)sender;

- (IBAction)insert:(id)sender;

@end
