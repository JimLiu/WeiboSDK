//
//  UserNamesSearchViewController.h
//  ZhiWeibo
//
//  Created by Zhang Jason on 12/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserNamesSearchViewControllerDelegate

- (void) addUserScreenName:(NSString*)userScreenName;

@end


@interface UserNamesSearchViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate> {
	IBOutlet UISearchBar *searchBar;
	IBOutlet UISearchDisplayController *displayController;
	
	NSMutableArray *searchResult;
	
	NSMutableArray *sectionsArray;
	UILocalizedIndexedCollation *collation;
	
	id<UserNamesSearchViewControllerDelegate> userNamesSearchViewControllerDelegate;
}

@property (nonatomic,assign) id<UserNamesSearchViewControllerDelegate> userNamesSearchViewControllerDelegate;

- (void)search;
- (void)sort;

@end
