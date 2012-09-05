//
//  RootViewController.h
//  SinaWeiboXAuthDemo
//
//  Created by junmin liu on 11-5-26.
//  Copyright 2011年 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboEngine.h"
#import "SinaWeiboClient.h"
#import "Status.h"
#import "AddXAuthAccountViewController.h"
#import "ComposeViewController.h"

@interface RootViewController : UITableViewController {
	NSMutableArray *statuses;
    SinaWeiboClient *weiboClient;
    
    AddXAuthAccountViewController *addUserViewController;
}


@property (nonatomic, retain) IBOutlet AddXAuthAccountViewController *addUserViewController;
@property (nonatomic, retain) IBOutlet ComposeViewController *composeViewController;

- (void)openAuthenticateView;

- (IBAction)refresh:(id)sender;

- (IBAction)compose:(id)sender;


@end
