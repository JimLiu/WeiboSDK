//
//  ZhiWeiboAppDelegate.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-20.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "ZhiWeiboAppDelegate.h"
#import "Reachability2.h"

static int NetworkActivityIndicatorCounter = 0;

@implementation ZhiWeiboAppDelegate
@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	//NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];

    [window makeKeyAndVisible];
	[[Reachability2 sharedReachability] setNetworkStatusNotificationsEnabled:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged) name:@"kNetworkReachabilityChangedNotification" object:nil];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
	[super dealloc];
}


#pragma mark -
#pragma mark Private Methods

- (void)reachabilityChanged {
    connectionStatus = ([[Reachability2 sharedReachability] remoteHostStatus] != NotReachable);
}

#pragma mark -
#pragma mark Alert

static UIAlertView *sAlert = nil;

- (void)alert:(NSString*)title message:(NSString*)message
{
    if (sAlert) return;
    
    sAlert = [[UIAlertView alloc] initWithTitle:title
                                        message:message
									   delegate:self
							  cancelButtonTitle:@"Close"
							  otherButtonTitles:nil];
    [sAlert show];
    [sAlert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonInde
{
    sAlert = nil;
}

- (void)signIn:(WeiboAccount *)user {
}

- (void)closeAuthenticateView {
}

- (void)openAuthenticateView {
}

- (void)refresh {
}

- (void)composeNewTweet {
}

- (void)replyTweet:(Status *)status comment:(Comment *)comment {
}

- (void)retweet:(Status*)status {
}

- (void)newDM {
}

- (void)advise {
	
}

+(ZhiWeiboAppDelegate*)getAppDelegate
{
    return (ZhiWeiboAppDelegate*)[UIApplication sharedApplication].delegate;
}


+ (void) increaseNetworkActivityIndicator
{
	if (NetworkActivityIndicatorCounter < 0) {
		NetworkActivityIndicatorCounter = 0;
	}
	NetworkActivityIndicatorCounter++;
	BOOL preVisible = [UIApplication sharedApplication].networkActivityIndicatorVisible;
	if (!preVisible) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NetworkActivityIndicatorCounter > 0;
	}
}

+ (void) decreaseNetworkActivityIndicator
{
	if (NetworkActivityIndicatorCounter > 0) {
		NetworkActivityIndicatorCounter--;
	}
	BOOL preVisible = [UIApplication sharedApplication].networkActivityIndicatorVisible;
	if (preVisible && NetworkActivityIndicatorCounter <= 0) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NetworkActivityIndicatorCounter > 0;
	}
}

- (void)loadDraft:(Draft *)draft {
	
}

- (void)signOut {
}

@end
