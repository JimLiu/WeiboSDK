//
//  RootViewController.h
//  SinaWeiboOAuthDemo
//
//  Created by junmin liu on 11-1-4.
//  Copyright 2011 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthController.h"
#import "WeiboClient.h"
#import "ComposeViewController.h"

@class OAuthEngine;

@interface RootViewController : UIViewController<OAuthControllerDelegate> {
	OAuthEngine				*_engine;
	WeiboClient *weiboClient;
	NSMutableArray *statuses;
	ComposeViewController *composeViewController;
    UITableView *_tableView;
}

@property (nonatomic, retain) IBOutlet ComposeViewController *composeViewController;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (void)openAuthenticateView;

- (IBAction)refresh:(id)sender;

- (IBAction)compose:(id)sender;

- (IBAction)signOut:(id)sender;

@end
