//
//  MoreViewController.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-20.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeiboClient;
@class SearchViewController;
@interface MoreViewController : UITableViewController {
	int unreadFollowersCount;
	WeiboClient *weiboClient;
	WeiboClient *resetUnreadWeiboClient;
	UILabel *unreadFollowersView;
	SearchViewController *searchViewControler;
}

- (void)autoRefresh;

- (void)unreadDidReceived:(WeiboClient*)sender obj:(NSObject*)obj;

- (void)resetUnread;

- (void)resetDidReceived:(WeiboClient*)sender obj:(NSObject*)obj;

@end
