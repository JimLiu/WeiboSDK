//
//  TabBar.m
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-9-2.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "TabBar.h"
#import "Images.h"

@implementation TabBar
@synthesize items = _items;
@synthesize selectedIndex = _selectedIndex;
@synthesize delegate = _delegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[Images tabBarBackgroundImage]];
        self.userInteractionEnabled = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}

//===========================================================
// dealloc
//===========================================================
- (void)dealloc
{
    [_items release];
    _delegate = nil;
    
    [super dealloc];
}

- (void)setItems:(NSMutableArray *)tabBarItems {
    if (tabBarItems != _items) {
        for (TabBarItem *item in _items) {
            [item removeFromSuperview];
        }
        _selectedIndex = -1;
        
        [_items release];
        _items = [tabBarItems retain];
        
        for (TabBarItem *item in _items) {
            [item addTarget:self action:@selector(tabBarItemSelected:) forControlEvents:UIControlEventTouchDown];
            [item addTarget:self action:@selector(tabBarItemDoubleTouched:) forControlEvents:UIControlEventTouchDownRepeat];
            
            [self addSubview:item];
        }
        [self setNeedsLayout];
    }
}

- (void)setSelectedIndex:(int)selectedIndex {
    if (selectedIndex < 0 || selectedIndex >= self.items.count) {
        return;
    }
    if (_selectedIndex != selectedIndex) {
        if (_selectedIndex >= 0) {
            TabBarItem *preItem = [self.items objectAtIndex:_selectedIndex];
            preItem.selected = NO;
        }
        
        _selectedIndex = selectedIndex;
        TabBarItem *item = [self.items objectAtIndex:_selectedIndex];
        item.selected = YES;
        
        if (_delegate) {
            [self.delegate tabBar:self didSelectTabAtIndex:_selectedIndex];
        }
    }
}

- (void)tabBarItemSelected:(id)sender {
    int index = [self.items indexOfObject:sender];
    [self setSelectedIndex:index];

}

- (void)tabBarItemDoubleTouched:(id)sender {
    int index = [self.items indexOfObject:sender];
    [self setSelectedIndex:index];
    if (_delegate) {
        [self.delegate tabBar:self didDoubleTouchTabAtIndex:_selectedIndex];
    }    
}


- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect frame = self.bounds;
	frame.size.width /= self.items.count;
	for (TabBarItem *item in self.items) {
		item.frame = frame;
		frame.origin.x += frame.size.width;
	}
}
@end
