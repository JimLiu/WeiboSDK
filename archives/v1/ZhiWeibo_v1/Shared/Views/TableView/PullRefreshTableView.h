//
//  PullRefreshTableView.h
//  Weibo
//
//  Created by junmin liu on 10-10-11.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RefreshTableHeaderView;

@interface PullRefreshTableView : UITableView<UIScrollViewDelegate> {
	RefreshTableHeaderView *refreshHeaderView;
}

@property (nonatomic, retain) RefreshTableHeaderView *refreshHeaderView;

@end
