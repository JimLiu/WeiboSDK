//
//  TabBar.h
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-9-2.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarItem.h"

@class TabBar;

@protocol TabBarDelegate
@required

- (void)tabBar:(TabBar *)aTabBar didSelectTabAtIndex:(NSInteger)index;

@optional

- (void)tabBar:(TabBar *)aTabBar didDoubleTouchTabAtIndex:(NSInteger)index;

@end

@interface TabBar : UIView {
    NSMutableArray *_items;
    int _selectedIndex;
    id<TabBarDelegate> _delegate;
}

@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, assign) id<TabBarDelegate> delegate;



@end
