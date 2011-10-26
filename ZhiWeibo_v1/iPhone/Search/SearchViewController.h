//
//  SearchViewController.h
//  ZhiWeibo
//
//  Created by Zhang Jason on 1/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchDataSource.h"
#import "SearchViewDataSource.h"
#import "HotUserViewController.h"

@interface SearchViewController : UIViewController<UISearchBarDelegate,SearchDataSourceDelegate,UISearchDisplayDelegate,SearchViewDataSourceDelegate> {
	IBOutlet UISearchBar *searchBar;
	IBOutlet UITableView *tableView;
	
	NSString *userKey;
	NSString *statusKey;
	
	SearchDataSource *searchDataSource;
	SearchViewDataSource *searchViewDataSource;
	IBOutlet UISearchDisplayController *displayerController;
	HotUserViewController *hotUserViewController;
}

@end
