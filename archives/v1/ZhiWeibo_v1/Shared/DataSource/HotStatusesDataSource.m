//
//  HotStatusesDataSource.m
//  ZhiWeibo
//
//  Created by Zhang Jason on 1/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HotStatusesDataSource.h"
#import "Status.h"
#import "HotStatusesView.h"


@implementation HotStatusesDataSource

- (id)initWithScrollView:(UIScrollView*)_scrollView {
	self = [super init];
	if (self) {
		scrollView = [_scrollView retain];
		scrollView.delegate = self;
		statuses = [[NSMutableArray alloc] init];
		loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[loadingView startAnimating];
		loadingView.frame = CGRectMake(134, 29, 19, 19);
		[scrollView addSubview:loadingView];
		views = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)loadHotStatues {
	if (date != nil) {
		NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
		[formatter setDateFormat:@"YYYY-MM-DD"];
		NSString *nowDate = [formatter stringFromDate:[NSDate date]];
		NSString *usedDate = [formatter stringFromDate:date];
		NSLog(@"%@,  %@",nowDate,usedDate);
		if ([nowDate isEqualToString:usedDate]) {
			return;
		}
	}
	
	if (weiboClient) { 
		weiboClient.delegate = nil;
		[weiboClient release];
		weiboClient = nil;
	}
	[statuses removeAllObjects];
	[views removeAllObjects];
	[self refreshView];
	weiboClient = [[WeiboClient alloc] initWithTarget:self 
											   action:@selector(statuesDidReceive:obj:)];
	[weiboClient getHotStatusesDaily:20];
}

- (void)statuesDidReceive:(WeiboClient*)sender obj:(NSObject*)obj {
	if (sender.hasError) {
		NSLog(@"usersDidReceive error!!!, errorMessage:%@, errordetail:%@"
			  , sender.errorMessage, sender.errorDetail);
        if (sender.statusCode == 401) {
            ZhiWeiboAppDelegate *appDelegate = [ZhiWeiboAppDelegate getAppDelegate];
            [appDelegate openAuthenticateView];
        }
        [sender alert];
    }
    if (obj == nil || ![obj isKindOfClass:[NSArray class]]) {
		weiboClient.delegate = nil;
		[weiboClient release];
		weiboClient = nil;
        return;
    }
	
	NSArray *ary = (NSArray*)obj;
	
	for (int i = 0; i < [ary count]; i++) {
		NSDictionary *dic1 = (NSDictionary*)[ary objectAtIndex:i];
		if (![dic1 isKindOfClass:[NSDictionary class]]) {
			continue;
		}
		Status* user = [Status statusWithJsonDictionary:[ary objectAtIndex:i]];
		[statuses addObject:user];
		[views addObject:[NSNull null]];
	}
	date = [[NSDate date] retain];
	
	[loadingView stopAnimating];
	scrollView.contentSize = CGSizeMake(250 * statuses.count, 76);
	[self refreshView];
	weiboClient.delegate = nil;
	[weiboClient release];
	weiboClient = nil;
}

- (void)loadView:(int)page {
	if (page >= 0 && page < statuses.count) {
		UIView *view = [views objectAtIndex:page];
		if ((NSNull *)view == [NSNull null]) {
			Status *status = [statuses objectAtIndex:page];
			HotStatusesView *h = [[HotStatusesView alloc] initWithFrame:CGRectMake(250*page, 0, 250, 76)];
			[h setStatus:status];
			[scrollView addSubview:h];
			[views replaceObjectAtIndex:page withObject:h];
			[h release];
		}
	}
}

- (void)refreshView {
	if (statuses.count > 0) {
		/*
		while (scrollView.subviews.count) {
			UIView* child = scrollView.subviews.lastObject;
			[child removeFromSuperview];
		}
		 */
		[loadingView stopAnimating];
		[loadingView removeFromSuperview];
		int page = scrollView.contentOffset.x / 250;
		[self loadView:page];
		[self loadView:page + 1];
		[self loadView:page + 2];
	}
	else {
		while (scrollView.subviews.count) {
			UIView* child = scrollView.subviews.lastObject;
			[child removeFromSuperview];
		}
		scrollView.contentSize = CGSizeMake(250, 76);
		[loadingView startAnimating];
		[scrollView addSubview:loadingView];
		[scrollView setNeedsLayout];
	}

}

- (void)dealloc {
	[scrollView release];
	[loadingView release];
	[statuses release];
	[views release];
	[super dealloc];
}

- (void)scrollViewDidScroll:(UIScrollView *)_scrollView {
	if ((int)(_scrollView.contentOffset.x) % 250 > 125) {
		[self refreshView];
	}
}

@end
