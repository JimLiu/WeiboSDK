//
//  UserTimelineController.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-12.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserTimelineDataSource_Phone.h"
#import "TweetViewController.h"

@interface UserTimelineController : UITableViewController<StatusDataSourceDelegate> {
	UserTimelineDataSource_Phone *dataSource;
	WebViewController *webViewController;
}

//- (IBAction)refreshButtonTouch:(id)sender;

//- (IBAction)composeButtonTouch:(id)sender;

- (void)loadTimeline;

- (void)setUser:(User *)user;

@end
