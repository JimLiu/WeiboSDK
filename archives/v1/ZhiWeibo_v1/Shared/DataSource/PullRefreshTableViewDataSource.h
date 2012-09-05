//
//  PullRefreshTableViewDataSource.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-21.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RefreshTableHeaderView.h"
#import "PullRefreshTableView.h"

@interface PullRefreshTableViewDataSource : NSObject<UITableViewDelegate, UITableViewDataSource> {
	PullRefreshTableView *tableView;
	BOOL _reloading;

}

@property(assign,getter=isReloading) BOOL reloading;
@property (nonatomic, retain) PullRefreshTableView *tableView;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

- (id)initWithTableView:(PullRefreshTableView *)_tableView;

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;


@end
