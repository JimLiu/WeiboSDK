//
//  AddXAuthAccountViewController.h
//  SinaWeiboXAuthDemo
//
//  Created by junmin liu on 11-5-26.
//  Copyright 2011年 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboEngine.h"
#import "WeiboConnection.h"
#import "SinaWeiboOAuth.h"

@interface AddXAuthAccountViewController : UIViewController<OAuthCallbacks> {
    IBOutlet UIBarButtonItem*   saveButton;
    IBOutlet UIBarButtonItem*   cancelButton;
    IBOutlet UITableViewCell*   username;
    IBOutlet UITableViewCell*   password;
    IBOutlet UITextField*       usernameField;
    IBOutlet UITextField*       passwordField;	
	IBOutlet UIView*			maskView;
	
	OAuth *oAuth;
	
	NSOperationQueue *queue;

}

@property (nonatomic, retain) OAuth *oAuth;

- (IBAction) save:(id)sender;

- (IBAction) cancel:(id)sender;

- (IBAction)textFieldValueChanged:(UITextField *)textField;


@end
