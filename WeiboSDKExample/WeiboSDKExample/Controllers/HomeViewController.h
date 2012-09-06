//
//  HomeViewController.h
//  WeiboSDKExample
//
//  Created by junmin liu on 12-9-5.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountsViewController.h"
#import "ComposeViewController.h"
#import "TimelineQuery.h"

@interface HomeViewController : UITableViewController {
    NSMutableArray *_statuses;
    BOOL _failedToLoad;
   
    TimelineQuery *_query;
}

@end
