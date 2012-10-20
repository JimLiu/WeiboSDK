//
//  WeiboTabBarController.m
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-8-25.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "WeiboTabBarController.h"

@interface WeiboTabBarController ()

@end

@implementation WeiboTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    HomeViewController *homeViewController = [[[HomeViewController alloc]initWithNibName:nil bundle:nil] autorelease];
    UINavigationController *homeNavicationController = [[[UINavigationController alloc]initWithRootViewController:homeViewController] autorelease];
    
    MentionViewController *mentionViewController = [[[MentionViewController alloc]initWithNibName:nil bundle:nil] autorelease];
    UINavigationController *mentionNavicationController = [[[UINavigationController alloc]initWithRootViewController:mentionViewController] autorelease];
    
    DiscoverViewController *discoverViewController = [[[DiscoverViewController alloc]initWithNibName:nil bundle:nil] autorelease];
    UINavigationController *discoverNavicationController = [[[UINavigationController alloc]initWithRootViewController:discoverViewController] autorelease];
    
    ProfileViewController *profileViewController = [[[ProfileViewController alloc]initWithNibName:nil bundle:nil] autorelease];
    UINavigationController *profileNavicationController = [[[UINavigationController alloc]initWithRootViewController:profileViewController] autorelease];
    
    self.viewControllers = [NSArray arrayWithObjects:
                            homeNavicationController,
                            mentionNavicationController,
                            discoverNavicationController,
                            profileNavicationController,
                            nil];
    
    
    NSArray *selectedImages = [NSArray arrayWithObjects:@"ic_tab_home_selected.png", @"ic_tab_at_selected.png", @"ic_tab_hash_selected.png", @"ic_tab_profile_selected.png", nil];
    NSArray *unselectedImages = [NSArray arrayWithObjects:@"ic_tab_home_default.png", @"ic_tab_at_default.png", @"ic_tab_hash_default.png", @"ic_tab_profile_default.png", nil];
    
    for (int i=0; i<self.tabBar.items.count; i++) {
        TabBarItem *item = [self.tabBar.items objectAtIndex:i];
        UIImage *selectedImage = [UIImage imageNamed:[selectedImages objectAtIndex:i]];
        UIImage *unselectedImage = [UIImage imageNamed:[unselectedImages objectAtIndex:i]];
        [item setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:unselectedImage];
        if (i == 2) {
            item.isGlowed = YES;
        }
    }
     
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
