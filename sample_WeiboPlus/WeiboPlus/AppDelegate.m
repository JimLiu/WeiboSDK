//
//  AppDelegate.m
//  WeiboPlus
//
//  Created by junmin liu on 12-9-19.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)dealloc
{
    [_navController release];
    [_window release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)initTheme {
    UIImage *navBarImage = [UIImage imageNamed:@"bg_title_bar.png"];
    
    [[UINavigationBar appearance] setBackgroundImage:navBarImage
                                       forBarMetrics:UIBarMetricsDefault];
    
    UIImage *barButtonImage = [[UIImage imageNamed:@"btn_title_bar_rect.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0];
    UIImage *barButtonPressedImage = [[UIImage imageNamed:@"btn_title_bar_rect_pressed.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0];
    [[UIBarButtonItem appearance] setBackgroundImage:barButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackgroundImage:barButtonPressedImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    UIImage *backButtonImage = [[UIImage imageNamed:@"btn_title_bar_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,15,0,8)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIImage *backButtonPressedImage = [[UIImage imageNamed:@"btn_title_bar_back_pressed.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,15,0,8)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonPressedImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    [[UITabBar appearance] setBackgroundImage:[[UIImage imageNamed:@"bg_tab_bar.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    [[UITabBar appearance] setSelectionIndicatorImage:[[UIImage imageNamed:@"bg_tab_bar_selected.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    
    [[UIToolbar appearance] setBackgroundImage:[UIImage imageNamed:@"bg_tab_bar.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    //[[UIToolbar appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"btn_tool_bar_rect_default.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
}

- (void)signIn:(BOOL)animated {
    if (self.window.rootViewController.modalViewController) {
        return;
    }
    AccountsViewController *accountsViewController = [[AccountsViewController alloc]initWithNibName:nil bundle:nil];
    _navController = [[UINavigationController alloc] initWithRootViewController:accountsViewController];
    _navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.window.rootViewController presentViewController:_navController animated:animated completion:nil];
    [_navController release];
    [accountsViewController release];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initTheme];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

    self.window.rootViewController = [[[WeiboTabBarController alloc]initWithNibName:nil bundle:nil]autorelease];
    
    
    [self.window makeKeyAndVisible];
    
    if (![[WeiboAccounts shared] currentAccount]) {
        [self signIn:NO];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authError:) name:@"authError" object:nil];
    
    
    return YES;

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)signOut {
    [[WeiboAccounts shared] signOut];
}

- (void)authError:(NSNotification*)notification
{
    //NSDictionary* info = [notification userInfo];
    //NSError *error = notification.object;
    [self signOut];
    [self signIn:YES];
}

@end
