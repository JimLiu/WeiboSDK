//
//  CommentsTimelineController.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-20.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentsTimelineDataSource_Phone.h"
#import "CommentViewController.h"
#import "WebViewController.h"

@interface CommentsTimelineController : UITableViewController<CommentsDataSourceDelegate> {
	CommentsTimelineDataSource_Phone *dataSource;
	CommentViewController *commentView;
	WebViewController *webViewController;
}

//@property (nonatomic, retain) IBOutlet CommentViewController *commentView;

- (CommentsTimelineDataSource_Phone *)dataSource;

- (IBAction)refreshButtonTouch:(id)sender;

- (IBAction)composeButtonTouch:(id)sender;

- (void)loadTimeline;

/*
- (IBAction)refreshButtonTouch:(id)sender;

- (IBAction)composeButtonTouch:(id)sender;
 */

@end
