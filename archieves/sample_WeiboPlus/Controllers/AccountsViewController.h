//
//  AccountsViewController.h
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-8-20.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSignIn.h"
#import "WeiboAccounts.h"

@interface AccountsViewController : UITableViewController<WeiboSignInDelegate> {
    WeiboSignIn *_weiboSignIn;
}

@end
