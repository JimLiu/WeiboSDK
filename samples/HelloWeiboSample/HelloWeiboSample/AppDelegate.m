//
//  AppDelegate.m
//  HelloWeiboSample
//
//  Created by Liu Jim on 8/4/13.
//  Copyright (c) 2013 openlab. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    Weibo *weibo = [[Weibo alloc] initWithAppKey:@"3326691039" withAppSecret:@"75dd27596a081b28651d214e246c1b15"];
    [Weibo setWeibo:weibo];
    // Override point for customization after application launch.
    
    if (weibo.isAuthenticated) {
        NSLog(@"current user: %@", weibo.currentAccount.user.name);
        /*
        [weibo newStatus:@"test weibo" pic:nil completed:^(Status *status, NSError *error) {
            if (error) {
                NSLog(@"failed to post:%@", error);
            }
            else {
                NSLog(@"success: %lld.%@", status.statusId, status.text);
            }
        }];
        
        NSData *img = UIImagePNGRepresentation([UIImage imageNamed:@"Icon"]);
        [weibo newStatus:@"test weibo with image" pic:img completed:^(Status *status, NSError *error) {
            if (error) {
                NSLog(@"failed to upload:%@", error);
            }
            else {
                StatusImage *statusImage = [status.images objectAtIndex:0];
                NSLog(@"success: %lld.%@.%@", status.statusId, status.text, statusImage.originalImageUrl);
            }
        }];
         */
    }
    
    
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

@end
