//
//  FriendsTimelineController.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-20.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsTimelineDataSource_Phone.h"
#import "TweetViewController.h"
#import "WebViewController.h"

@interface FriendsTimelineController : UITableViewController<StatusDataSourceDelegate> {
	FriendsTimelineDataSource_Phone *dataSource;
	WebViewController *webViewController;
}

- (FriendsTimelineDataSource_Phone *)dataSource;

- (IBAction)refreshButtonTouch:(id)sender;

- (IBAction)composeButtonTouch:(id)sender;

- (void)loadTimeline;


@end
