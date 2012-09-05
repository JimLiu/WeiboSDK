//
//  CommonPhrasesViewController.h
//  ZhiWeibo
//
//  Created by Zhang Jason on 2/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CommonPhrasesViewController : UIViewController<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource> {
	IBOutlet UISearchBar *searchBar;
	IBOutlet UITableView *tableView;
	
	NSMutableArray *phrases;
	NSMutableArray *searchResult;
}

- (void)storageTrendsToLocal;
- (void)search;

@end
