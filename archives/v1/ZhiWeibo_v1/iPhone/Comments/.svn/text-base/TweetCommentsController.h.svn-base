//
//  TweetCommentsController.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-28.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetCommentsDataSource.h"
#import "Status.h"

@interface TweetCommentsController : UIViewController<TweetCommentsDataSourceDelegate> {
	PullRefreshTableView *tableView;
	TweetCommentsDataSource *dataSource;
	Status *status;
	UIBarButtonItem *replyButton;
}

@property (nonatomic, retain) IBOutlet PullRefreshTableView *tableView;
@property (nonatomic, retain) Status *status;

@end
