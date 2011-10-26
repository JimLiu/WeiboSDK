//
//  TrendSearchViewController.h
//  ZhiWeibo
//
//  Created by Zhang Jason on 12/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TrendSearchViewControllerDelegate

- (void) addTrend:(NSString*)trend;

@end

@interface TrendSearchViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate> {
	IBOutlet UISearchBar *searchBar;
	IBOutlet UISearchDisplayController *displayContrller;
	
	NSMutableArray *trends;
	NSMutableArray *searchResult;
	
	id<TrendSearchViewControllerDelegate> trendSearchViewControllerDelegate;
}

@property (nonatomic,assign) id<TrendSearchViewControllerDelegate> trendSearchViewControllerDelegate;

- (void)storageTrendsToLocal;
- (void)search;
	

@end
