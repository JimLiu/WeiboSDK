//
//  HomeViewController.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-3.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddAccountViewController.h"
#import "SearchViewController.h"

@interface HomeViewController : UIViewController {
	AddAccountViewController *addAccountViewController;
}

@property (nonatomic, retain) IBOutlet AddAccountViewController *addAccountViewController;

- (IBAction)signIn:(id)sender;

@end
