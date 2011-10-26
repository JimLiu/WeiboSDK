//
//  AppDelegate_iPhone.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-19.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZhiWeiboAppDelegate.h"
#import "AddAccountViewController.h"
#import "WeiboEngine.h"
#import "WeiboClient.h"
#import "ComposeViewController.h"
#import "HomeViewController.h"
#import "NewDirectMessageViewController.h"
#import "DirectMessageController.h"


@interface AppDelegate_iPhone : ZhiWeiboAppDelegate<NewDirectMessageViewControllerDelegate> {
	IBOutlet UITabBarController*    tabBarController;
	UINavigationController *homeViewController;
	UIViewController *rootViewController;
	AddAccountViewController *addAccountView;
	BOOL userSignined;
	
	int                             selectedTab;
    BOOL                            initialized;
    NSTimeInterval                  autoRefreshInterval;
    NSTimer*                        autoRefreshTimer;
    NSDate*                         lastRefreshDate;

	NewDirectMessageViewController *newDirectMessageViewController;
	DirectMessageController *directMessageController;
	ComposeViewController *composeView;
}

@property (nonatomic, retain) IBOutlet NewDirectMessageViewController *newDirectMessageViewController;
@property (nonatomic, retain) IBOutlet DirectMessageController *directMessageController;
@property (nonatomic, retain) IBOutlet ComposeViewController *composeView;
@property (nonatomic, retain) IBOutlet UINavigationController *homeViewController;

- (void) openAddAccountView;

@end

