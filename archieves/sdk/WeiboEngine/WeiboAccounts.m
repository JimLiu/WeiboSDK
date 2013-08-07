//
//  WeiboAccounts.m
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-8-21.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "WeiboAccounts.h"
#import "PathHelper.h"

static WeiboAccounts *gInstance;

@implementation WeiboAccounts

- (id)init {
    self = [super init];
    if (self) {
        _accountsDictionary = [[NSMutableDictionary alloc] init];
        _accounts = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)dealloc {
    [_accountsDictionary release];
    [_accounts release];
    [super dealloc];
}

+ (WeiboAccounts *)shared {

    if (!gInstance) {
        gInstance = [[WeiboAccounts alloc] init];
        [gInstance loadWeiboAccounts];
    }
    return gInstance;

}

- (NSString *)getWeiboAccountsStoragePath {
	NSString *filePath = [[PathHelper documentDirectoryPathWithName:@"db"]
						  stringByAppendingPathComponent:@"accounts.db"];
	return filePath;
}

- (void)loadWeiboAccounts {
	NSString *filePath = [self getWeiboAccountsStoragePath];
	NSArray *weiboAccounts = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
	if (!weiboAccounts) {
		weiboAccounts = [[[NSMutableArray alloc] init] autorelease];
		[NSKeyedArchiver archiveRootObject:weiboAccounts toFile:filePath];
	}
	[_accounts release];
	_accounts = [[NSMutableArray arrayWithArray:weiboAccounts] retain];
    for (WeiboAccount *account in _accounts) {
        [_accountsDictionary setObject:account forKey:account.userId];
    }
}

- (void)saveWeiboAccounts {
	NSString *filePath = [self getWeiboAccountsStoragePath];
	[NSKeyedArchiver archiveRootObject:_accounts toFile:filePath];
}

- (void)syncAccount:(WeiboAccount *)account {
    UserQuery *query = [UserQuery query];
    query.completionBlock = ^(WeiboRequest *request, User *user, NSError *error) {
        if (error) {
            //
            NSLog(@"UserQuery error: %@", error);
        }
        else {
            account.screenName = user.screenName;
            account.profileImageUrl = user.profileLargeImageUrl;
            [self saveWeiboAccounts];
        }
    };
    [query queryWithUserId:[account.userId longLongValue]];    
}

- (void)addAccount:(WeiboAccount *)account {
    WeiboAccount *addedAccount = [_accountsDictionary objectForKey:account.userId];
    if (addedAccount) {
        addedAccount.accessToken = account.accessToken;
        addedAccount.expirationDate = account.expirationDate;
    }
    else {
        addedAccount = account;
        if (_accounts.count == 0) {
            account.selected = YES;
        }
        [_accountsDictionary setObject:account forKey:account.userId];
        [_accounts insertObject:account atIndex:0];
    }
    [self saveWeiboAccounts];
    if (!account.screenName || !account.profileImageUrl) {
        [self syncAccount:account];
    }
}

- (void)removeWeiboAccount:(WeiboAccount *)account {
    WeiboAccount *accountToBeRemoved = [_accountsDictionary objectForKey:account.userId];
    BOOL isCurrentAccount = accountToBeRemoved.selected;
    if (accountToBeRemoved) {
        [_accounts removeObject:accountToBeRemoved];
        [_accountsDictionary removeObjectForKey:account.userId];
    }
    if (isCurrentAccount) {
        if (_accounts.count > 0) {
            [[_accounts objectAtIndex:0] setSelected:YES];
        }
    }
    [self saveWeiboAccounts];
}

- (void)setCurrentAccount:(WeiboAccount *)currentAccount {
    for (WeiboAccount *account in _accounts) {
        account.selected = [account.userId isEqualToString:currentAccount.userId];
    }
    [self saveWeiboAccounts];
}

- (WeiboAccount *)currentAccount {
    for (WeiboAccount *account in _accounts) {
        if (account.selected) {
            return account;
        }
    }
    //if (_accounts.count > 0) {
        //return [_accounts objectAtIndex:0];
    //}
    return nil;
}

- (void)signOut {
    WeiboAccount *currentAccount = [self currentAccount];
    if (currentAccount) {
        [self removeWeiboAccount:currentAccount];
    }
}

- (NSMutableArray *)accounts {
    return _accounts;
}

- (void)addAccountWithAuthentication:(WeiboAuthentication *)auth {
    WeiboAccount *account = [[[WeiboAccount alloc]init] autorelease];
    account.accessToken = auth.accessToken;
    account.userId = auth.userId;
    account.expirationDate = auth.expirationDate;
    
    [self addAccount:account];
}


@end
