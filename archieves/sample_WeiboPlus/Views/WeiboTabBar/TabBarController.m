//
//  TabBarController.m
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-9-3.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController ()

- (void)loadTabs;

@end

static CGFloat tabBarHeight = 44;;

@implementation TabBarController
@synthesize viewControllers = _viewControllers;
@synthesize tabBar = _tabBar;
@synthesize selectedIndex = _selectedIndex;
@synthesize contentView = _contentView;

- (CGRect)tabBarFrame {
    return CGRectMake(0, self.view.bounds.size.height - tabBarHeight, self.view.bounds.size.width, tabBarHeight);
}

- (CGRect)contentViewFrame {
    return CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - tabBarHeight);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _selectedIndex = 0;
    }
    return self;
}

- (void)dealloc
{
    [_viewControllers release];
    [_tabBarItems release];
    [_tabBar release];
    [_contentView release];
    
    [super dealloc];
}

- (UIViewController *)selectedViewController {
    return [self.viewControllers objectAtIndex:self.selectedIndex];
}

- (void)setViewControllers:(NSArray *)viewControllers {
	if (_viewControllers != viewControllers) {
        [_viewControllers release];
		_viewControllers = [viewControllers retain];
		
		if (viewControllers != nil) {
			[self loadTabs];
            if (_viewControllers.count > 0) {
                self.selectedIndex = 0;
                [self setContentView:self.selectedViewController.view];
                [self.tabBar setSelectedIndex:self.selectedIndex];
            }
		}
        else {
            [_tabBarItems release];
            _tabBarItems = nil;
        }
	}
	
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBar = [[[TabBar alloc]initWithFrame:[self tabBarFrame]] autorelease];
    self.tabBar.delegate = self;
    [self.view addSubview:self.tabBar];
    if (!_tabBarItems) {        
        [self loadTabs];
    }
    else {
        self.tabBar.items = _tabBarItems;
    }
    [self.tabBar setSelectedIndex:self.selectedIndex];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    if (!self.childViewControllers)
        [self.selectedViewController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    
    if (!self.childViewControllers)
        [self.selectedViewController viewDidAppear:animated];
    
	_visible = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    
    if (!self.childViewControllers)
        [self.selectedViewController viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    
    if (![self respondsToSelector:@selector(addChildViewController:)])
        [self.selectedViewController viewDidDisappear:animated];
	_visible = NO;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return [self.selectedViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willAnimateFirstHalfOfRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
}

- (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willAnimateSecondHalfOfRotationFromInterfaceOrientation:fromInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self.selectedViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}


- (void)setContentView:(UIView *)contentView {
    if (_contentView != contentView) {
        [_contentView removeFromSuperview];
        [_contentView release];
        _contentView = [contentView retain];
        _contentView.frame = [self contentViewFrame];
        [self.view addSubview:_contentView];
        [self.view sendSubviewToBack:_contentView];
        [_contentView setNeedsLayout];
    }
}

- (void)setSelectedIndex:(int)selectedIndex {
    UIViewController *controller = [self.viewControllers objectAtIndex:selectedIndex];
    if (_selectedIndex == selectedIndex) {
        if ([controller isKindOfClass:[UINavigationController class]]) {
			[(UINavigationController *)controller popToRootViewControllerAnimated:YES];
		}
    }
    else {
        UIViewController *preController = [self.viewControllers objectAtIndex:_selectedIndex];
        if (!self.childViewControllers && _visible) {
            [preController viewWillDisappear:NO];
            [controller viewWillAppear:NO];
        }
        _selectedIndex = selectedIndex;
        [self setContentView:controller.view];
        if (!self.childViewControllers && _visible) {
            [preController viewDidDisappear:NO];
            [controller viewDidAppear:NO];
        }
    }
}

- (void)tabBar:(TabBar *)aTabBar didSelectTabAtIndex:(NSInteger)index {
    [self setSelectedIndex:index];
}

- (void)tabBar:(TabBar *)aTabBar didDoubleTouchTabAtIndex:(NSInteger)index {
    
}


- (void)loadTabs {
	NSMutableArray *tabBarItems = [NSMutableArray array];
	for (UIViewController *controller in self.viewControllers) {
        TabBarItem *item = [[[TabBarItem alloc]initWithFrame:CGRectZero]autorelease];
		[tabBarItems addObject:item];
        item.title = controller.tabBarItem.title;
	}
    [_tabBarItems release];
    _tabBarItems = [tabBarItems retain];
    self.tabBar.items = _tabBarItems;
}


@end
