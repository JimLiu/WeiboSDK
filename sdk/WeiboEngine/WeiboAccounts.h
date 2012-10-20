//
//  WeiboAccounts.h
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-8-21.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboAccount.h"
#import "WeiboAuthentication.h"
#import "UserQuery.h"


@interface WeiboAccounts : NSObject {    
    NSMutableDictionary *_accountsDictionary;
    NSMutableArray *_accounts;
}

+ (WeiboAccounts *)shared;

@property (nonatomic, assign) WeiboAccount *currentAccount;
@property (nonatomic, readonly) NSMutableArray *accounts;

- (void)loadWeiboAccounts;

- (void)saveWeiboAccounts;

- (void)addAccount:(WeiboAccount *)account;

- (void)addAccountWithAuthentication:(WeiboAuthentication *)auth;

- (void)removeWeiboAccount:(WeiboAccount *)account;

- (void)syncAccount:(WeiboAccount *)account;

- (void)signOut;

@end
