//
//  SearchDataSource.h
//  ZhiWeibo
//
//  Created by Zhang Jason on 1/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboClient.h"
#import "LoadMoreCell.h"

typedef enum {
	SearchTypeUser,
	SearchTypeStatus
} SearchType;


@protocol SearchDataSourceDelegate

- (void)userSelected:(User *)user;

- (void)statusSelected:(Status *)status;

@end

@interface SearchDataSource : NSObject<UITableViewDelegate,UITableViewDataSource> {
	SearchType searchType;
	UISearchDisplayController *searchDisplayController;
	WeiboClient *weiboClient;
	
	NSMutableArray *userResults;
	NSMutableArray *statusResults;
	
	NSString *userKey;
	NSString *statusKey;
	
	LoadMoreCell *loadCell;
	BOOL userIsRestored;
	BOOL statusIsRestored;

	int downloadCount;
	int page;
	
	id<SearchDataSourceDelegate> searchDataSourceDelegate;
}

@property (nonatomic, retain)UISearchDisplayController *searchDisplayController;
@property (nonatomic,assign)id<SearchDataSourceDelegate> searchDataSourceDelegate;

- (id)initWithController:(UISearchDisplayController *)_searchDisplayController;
- (void)setSearchType:(SearchType)type;
- (void)searchUserByName:(NSString*)name;
- (void)searchStatusByName:(NSString*)name;

@end
