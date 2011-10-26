//
//  DraftsViewController.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-20.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Draft.h"
#import "WeiboEngine.h"


@interface DraftsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	UITableView *tableView;
	NSMutableArray *drafts;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (NSMutableArray*)loadDrafts;

@end
