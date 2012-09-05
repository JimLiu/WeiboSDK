//
//  RepostTimelineController.h
//  ZhiWeibo
//
//  Created by Zhang Jason on 1/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RepostTimelineDataSource_Phone.h"
#import "TweetViewController.h"
#import "WebViewController.h"

@interface RepostTimelineController : UITableViewController<StatusDataSourceDelegate> {
	RepostTimelineDataSource_Phone *dataSource;
	TweetViewController* tweetView;
	WebViewController *webViewController;
}

@property (nonatomic, retain) IBOutlet TweetViewController *tweetView;


//- (IBAction)refreshButtonTouch:(id)sender;

//- (IBAction)composeButtonTouch:(id)sender;

- (void)loadTimeline;

- (void)setStatus:(Status*)status;

@end
