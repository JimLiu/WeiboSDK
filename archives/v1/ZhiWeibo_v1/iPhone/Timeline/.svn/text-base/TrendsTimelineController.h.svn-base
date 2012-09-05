//
//  TrendsTimelineController.h
//  ZhiWeibo
//
//  Created by Zhang Jason on 12/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendsTimelineDataSource_Phone.h"
#import "TweetViewController.h"

@interface TrendsTimelineController : UITableViewController<StatusDataSourceDelegate> {
	TrendsTimelineDataSource_Phone *dataSource;
	TweetViewController* tweetView;
}

@property (nonatomic, retain) IBOutlet TweetViewController *tweetView;


//- (IBAction)refreshButtonTouch:(id)sender;

//- (IBAction)composeButtonTouch:(id)sender;

- (void)loadTimeline;

- (id)initWithTrendsName:(NSString *)trendsName;

@end
