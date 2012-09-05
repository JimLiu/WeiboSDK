//
//  NewDirectMessageViewController.h
//  ZhiWeibo
//
//  Created by Zhang Jason on 1/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "WeiboClient.h"

@protocol NewDirectMessageViewControllerDelegate

- (void)newDirectMessageTo:(long long)_userId;

@end


@interface NewDirectMessageViewController : UIViewController<UISearchDisplayDelegate,UITableViewDelegate,UITableViewDataSource> {
	IBOutlet UISearchBar *searchBar;
	IBOutlet UISearchDisplayController *displayController;
	
	WeiboClient *weiboClient;
	NSMutableArray *searchResult;
	
	IBOutlet UIView* maskView;
	
	id<NewDirectMessageViewControllerDelegate> newDirectMessageViewControllerDelegate;
}

@end
