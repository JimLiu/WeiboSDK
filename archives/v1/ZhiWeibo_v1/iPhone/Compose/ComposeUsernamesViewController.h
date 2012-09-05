//
//  ComposeUsernamesViewController.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-25.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ComposeView;

@interface ComposeUsernamesViewController : UIViewController<UISearchBarDelegate> {
    IBOutlet UITableView*   friendsView;
    ComposeView*     composeView;
    NSString*               screenName;
    NSMutableArray*         letters;
    NSMutableArray*         index;
    int                     numLetters;
	
    NSMutableArray*         searchResult;
    BOOL                    inSearch;	
}

@property(nonatomic, assign) ComposeView* composeView;

- (IBAction) close:(id)sender;

@end
