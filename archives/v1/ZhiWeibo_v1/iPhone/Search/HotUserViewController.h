//
//  HotUserViewController.h
//  ZhiWeibo
//
//  Created by Zhang Jason on 1/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotUserDataSource.h"


@interface HotUserViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource,FriendsFollowersDataSourceDelegate> {
	NSMutableArray *categroy;
	NSMutableDictionary *categroyDic;
	
	UITableViewController *usersViewController;
	HotUserDataSource *hotUserDataSource;
}

@end
