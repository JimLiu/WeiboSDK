//
//  SearchViewDataSource.h
//  ZhiWeibo
//
//  Created by Zhang Jason on 1/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboClient.h"
#import "LoadMoreCell.h"

@protocol SearchViewDataSourceDelegate

- (void)searchBarSelected;

- (void)suggestionsSelected;

- (void)trendSelected:(NSString*)trend;

@end

@class TrendNowCellView;
@interface SearchViewDataSource : NSObject<UITableViewDelegate,UITableViewDataSource> {
	UITableView *tableView;
	WeiboClient *weiboClient;
	NSMutableArray *trends;
	TrendNowCellView *trendNowCell;
	
	NSDate *date;
	
	id<SearchViewDataSourceDelegate> searchViewDelegate;
}

@property(nonatomic,assign)id<SearchViewDataSourceDelegate> searchViewDelegate;
@property(nonatomic,retain)UITableView *tableView;

- (id)initWithTableView:(UITableView *)_tableView;

- (void)loadRecent;

@end
