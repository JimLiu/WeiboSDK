//
//  MentionsTimelineController.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-20.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MentionsTimelineDataSource_Phone.h"
#import "TweetViewController.h"

@interface MentionsTimelineController : UITableViewController<StatusDataSourceDelegate> {
	MentionsTimelineDataSource_Phone *dataSource;
	WebViewController *webViewController;
}

- (MentionsTimelineDataSource_Phone *)dataSource;

- (void)loadTimeline;

- (IBAction)refreshButtonTouch:(id)sender;

- (IBAction)composeButtonTouch:(id)sender;


@end
