//
//  AppDelegate.h
//  WeiboPlus
//
//  Created by junmin liu on 12-9-19.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountsViewController.h"
#import "WeiboTabBarController.h"
#import "WeiboAccounts.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UINavigationController *_navController;
}

@property (strong, nonatomic) UIWindow *window;

@end
