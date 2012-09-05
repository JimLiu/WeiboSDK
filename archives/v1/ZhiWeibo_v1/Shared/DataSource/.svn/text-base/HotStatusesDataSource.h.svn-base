//
//  HotStatusesDataSource.h
//  ZhiWeibo
//
//  Created by Zhang Jason on 1/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboClient.h"


@interface HotStatusesDataSource : NSObject<UIScrollViewDelegate> {
	WeiboClient *weiboClient;
	NSMutableArray *statuses;
	UIScrollView *scrollView;
	NSMutableArray *views;
	UIActivityIndicatorView *loadingView;
	
	NSDate *date;
}

- (id)initWithScrollView:(UIScrollView*)_scrollView;

- (void)loadHotStatues;

- (void)refreshView;

@end
