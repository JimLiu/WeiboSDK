//
//  AddAccountViewController.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-20.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboClient.h"
#import "WeiboEngine.h"
#import "User.h"


@interface AddAccountViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, OAuthCallbacks> {
    IBOutlet UIBarButtonItem*   saveButton;
    IBOutlet UIBarButtonItem*   cancelButton;
    IBOutlet UITableViewCell*   username;
    IBOutlet UITableViewCell*   password;
    IBOutlet UITextField*       usernameField;
    IBOutlet UITextField*       passwordField;	
	IBOutlet UIView*			maskView;
	WeiboClient *client;
    OAuth *oAuth;
    NSOperationQueue *queue;
}

@property (nonatomic, retain) OAuth *oAuth;

- (IBAction) save:(id)sender;

- (IBAction) cancel:(id)sender;

- (IBAction)textFieldValueChanged:(UITextField *)textField;

@end
