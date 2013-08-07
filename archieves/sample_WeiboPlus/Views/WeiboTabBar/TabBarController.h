//
//  TabBarController.h
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-9-3.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBar.h"
#import "TabBarItem.h"

@interface TabBarController : UIViewController<TabBarDelegate> {
    NSArray *_viewControllers;
    NSMutableArray *_tabBarItems;
    TabBar *_tabBar;
    int _selectedIndex;
    UIView *_contentView;
    BOOL _visible;
}

@property (nonatomic, retain) NSArray *viewControllers;
@property (nonatomic, retain) TabBar *tabBar;
@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, retain) IBOutlet UIView *contentView;


@end
