//
//  AppDelegate_iPhone.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-19.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "AppDelegate_iPhone.h"
#import "ImageCache.h"
#import "FriendCache.h"
#import "Conversation.h"


@interface AppDelegate_iPhone(Private)
- (void)postInit;
- (void)setNextTimer:(NSTimeInterval)interval;
@end

@implementation AppDelegate_iPhone
@synthesize composeView;
@synthesize homeViewController;
@synthesize newDirectMessageViewController;
@synthesize directMessageController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
	User *user = [WeiboEngine currentAccount].user;
	if (!user) {
		[window addSubview:homeViewController.view];
		rootViewController = homeViewController;
		//[self openAddAccountView];
		userSignined = NO;
	}
	else {
		[WeiboEngine selectCurrentUser];
		tabBarController.selectedIndex = 0;
		[window addSubview:tabBarController.view];
		rootViewController = tabBarController;
		userSignined = YES;
		[self postInit];
	}
	
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	[super applicationWillResignActive:application];
	if (!userSignined) {
		return;
	}
    if (autoRefreshTimer) {
        [autoRefreshTimer invalidate];
        autoRefreshTimer = nil;
    }
    /*
    if (postView != nil) {
        [self.postView saveTweet];
    }
	 */
	NSArray *views = tabBarController.viewControllers;
    for (int i = 0; i < [views count]; ++i) {
        UINavigationController* nav = (UINavigationController*)[views objectAtIndex:i];
        UIViewController *c = [nav.viewControllers objectAtIndex:0];
        if ([c respondsToSelector:@selector(saveData)]) {
            [c performSelector:@selector(saveData)];
        }
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
 	[super applicationDidBecomeActive:application];
	if (!userSignined) {
		return;
	}
    if (lastRefreshDate == nil) {
        lastRefreshDate = [[NSDate date] retain];
    }
    else if (autoRefreshInterval) {
        NSDate *now = [NSDate date];
        NSTimeInterval diff = autoRefreshInterval - [now timeIntervalSinceDate:lastRefreshDate];
        if (diff < 0) {
            //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;          
			//[ZhiWeiboAppDelegate increaseNetworkActivityIndicator];
            diff = 2.0;
        }
        [self setNextTimer:diff];
    }
	/*
    if (postView != nil) {
        [self.postView checkProgressWindowState];
    }
	 */
	
}



- (void)applicationWillTerminate:(UIApplication *)application {
	/*    if (postView != nil) {
	 [self.postView saveTweet];
	 [postView release];
	 }*/
	NSArray *views = tabBarController.viewControllers;
    for (int i = 0; i < [views count]; ++i) {
        UINavigationController* nav = (UINavigationController*)[views objectAtIndex:i];
        UIViewController *c = [nav.viewControllers objectAtIndex:0];
        if ([c respondsToSelector:@selector(saveData)]) {
            [c performSelector:@selector(saveData)];
        }
    }
	[ImageCache removeExpiredImages];
    [super applicationWillTerminate:application];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
	[super applicationDidReceiveMemoryWarning:application];
}


- (void)dealloc {
    [super dealloc];
}

- (void)signIn:(WeiboAccount *)account {
	userSignined = YES;
	[rootViewController dismissModalViewControllerAnimated:YES];
	[homeViewController.view removeFromSuperview];
	[tabBarController.view removeFromSuperview];
	[window addSubview:tabBarController.view];
	rootViewController = tabBarController;
	addAccountView = nil;
	[self postInit];
}

- (void)signOut {
	
	NSArray *views = tabBarController.viewControllers;
    for (int i = 0; i < [views count]; ++i) {
        UINavigationController* nav = (UINavigationController*)[views objectAtIndex:i];
        UIViewController *c = [nav.viewControllers objectAtIndex:0];
		if ([c respondsToSelector:@selector(saveData)]) {
			[c performSelector:@selector(saveData)];
		}
        if ([c respondsToSelector:@selector(reset)]) {
            [c performSelector:@selector(reset)];
        }
    }
    [WeiboEngine removeWeiboAccount:[WeiboEngine currentAccount]];
	[rootViewController dismissModalViewControllerAnimated:YES];
	[homeViewController.view removeFromSuperview];
	[tabBarController.view removeFromSuperview];
	[window addSubview:homeViewController.view];
	rootViewController = homeViewController;
	userSignined = NO;
	//NSLog(@"%d",weiboAccounts.selectedIndex);
	//weiboAccounts.selectedIndex = -1;
	//NSLog(@"%d",weiboAccounts.selectedIndex);
}

- (void)openAuthenticateView {
	[self openAddAccountView];
}

- (void)openAddAccountView
{
    if (addAccountView) return;
    
    addAccountView = [[[AddAccountViewController alloc] initWithNibName:@"AddAccountViewController" bundle:nil] autorelease];
    //UINavigationController *parentNav = [[[UINavigationController alloc] initWithRootViewController:addAccountView] autorelease];
	
    //UINavigationController* nav = (UINavigationController*)[tabBarController.viewControllers objectAtIndex:0];
    [rootViewController presentModalViewController:addAccountView animated:YES];
}

- (void)closeAuthenticateView {
	addAccountView = nil;
}

- (void)postInit
{
	if (!userSignined) {
		return;
	}
	// Load Cache
	
	[FriendCache loadFromLocal];
	
    // Load views
    //
    NSArray *views = tabBarController.viewControllers;
    for (int i = 0; i < [views count]; ++i) {
        UINavigationController* nav = (UINavigationController*)[views objectAtIndex:i];
        UIViewController *c = [nav.viewControllers objectAtIndex:0];
        if ([c respondsToSelector:@selector(loadTimeline)]) {
            [c performSelector:@selector(loadTimeline)];
        }
    }
    
	if (!autoRefreshTimer) {
		int interval = 1;//[[NSUserDefaults standardUserDefaults] integerForKey:@"autoRefresh"];
		autoRefreshInterval = 60;
		if (interval > 0) {
			autoRefreshInterval = interval * 60;
			if (autoRefreshInterval < 180) 
				autoRefreshInterval = 180;
			[self setNextTimer:autoRefreshInterval];
		}
	}
    
    initialized = true;
}


- (void)setNextTimer:(NSTimeInterval)interval
{
    autoRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(autoRefresh:) userInfo:nil repeats:false];    
}


- (void)refresh {
	if (!userSignined) {
		return;
	}
	NSArray *views = tabBarController.viewControllers;
    for (int i = 0; i < [views count]; ++i) {
        UINavigationController* nav = (UINavigationController*)[views objectAtIndex:i];
        UIViewController *c = [nav.viewControllers objectAtIndex:0];
        if ([c respondsToSelector:@selector(autoRefresh)]) {
            [c performSelector:@selector(autoRefresh)];
        }
    }
}

- (void)autoRefresh:(NSTimer*)timer
{
    [lastRefreshDate release];
    lastRefreshDate = [[NSDate date] retain];
    
	[self refresh];
	
    [self setNextTimer:autoRefreshInterval];
}


- (void)composeNewTweet {
	[tabBarController presentModalViewController:composeView animated:YES];
	[composeView composeNewTweet];
}

- (void)replyTweet:(Status *)status comment:(Comment *)comment {
	[tabBarController presentModalViewController:composeView animated:YES];
	[composeView replyTweet:status comment:comment];
}

- (void)retweet:(Status*)status {
	[tabBarController presentModalViewController:composeView animated:YES];
	[composeView retweet:status];
}

- (void)newDM {
	[tabBarController presentModalViewController:newDirectMessageViewController animated:YES];
}

- (void)loadDraft:(Draft *)draft {
	[tabBarController presentModalViewController:composeView animated:YES];
	[composeView loadDraft:draft];
}

- (void)newDirectMessageTo:(long long)_userId {
	tabBarController.selectedIndex = 3;
	Conversation *con = [[Conversation alloc] init];
	con.conversationId = _userId + [[WeiboEngine getCurrentUser] userId];
	[directMessageController conversationSelected:con];
	[con release];
}

- (void)advise {
	[tabBarController presentModalViewController:composeView animated:YES];
	[composeView advise];
}

@end
