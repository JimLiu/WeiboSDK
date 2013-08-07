//
//  WeiboAccounts.h
//  WeiboSDK
//
//  Created by Liu Jim on 8/3/13.
//  Copyright (c) 2013 openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboAccount.h"
#import "WeiboAuthentication.h"


@interface WeiboAccounts : NSObject {
    dispatch_queue_t _dataQueue;
}

+ (WeiboAccounts *)shared;

@property (nonatomic, assign) WeiboAccount *currentAccount;

- (NSMutableArray *)accounts;

- (void)loadWeiboAccounts;

- (void)saveWeiboAccounts;

- (BOOL)addAccount:(WeiboAccount *)account;

- (void)removeWeiboAccount:(WeiboAccount *)account;

- (void)signOut;


@end
