//
//  WeiboAccounts.m
//  WeiboSDK
//
//  Created by Liu Jim on 8/3/13.
//  Copyright (c) 2013 openlab. All rights reserved.
//

#import "WeiboAccounts.h"
#import "PathHelper.h"


@interface WeiboAccounts()

@property (nonatomic, strong) NSMutableDictionary *accountsDictionary;
@property (nonatomic, strong) NSMutableArray *accounts;

@end

@implementation WeiboAccounts

- (id)init {
    self = [super init];
    if (self) {
        self.accountsDictionary = [[NSMutableDictionary alloc] init];
        self.accounts = [[NSMutableArray alloc] init];
        dispatch_queue_t lowPriQueue =
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
        _dataQueue = dispatch_queue_create("com.openlab.weiboAccounts.data", DISPATCH_QUEUE_SERIAL);
        dispatch_set_target_queue(_dataQueue, lowPriQueue);

    }
    return self;
}

+ (WeiboAccounts *)shared {
    static WeiboAccounts* _instance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[WeiboAccounts alloc] init];
        [_instance loadWeiboAccounts];
    });
    
    return _instance;
    
}

- (NSMutableArray *)accounts {
    return _accounts;
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
		weiboAccounts = [[NSMutableArray alloc] init];
		[NSKeyedArchiver archiveRootObject:weiboAccounts toFile:filePath];
	}
	self.accounts = [NSMutableArray arrayWithArray:weiboAccounts];
    for (WeiboAccount *account in self.accounts) {
        [_accountsDictionary setObject:account forKey:account.userId];
    }
}

- (void)saveWeiboAccounts {
    dispatch_async(_dataQueue, ^{
        NSString *filePath = [self getWeiboAccountsStoragePath];
        [NSKeyedArchiver archiveRootObject:_accounts toFile:filePath];
    });
}

- (BOOL)addAccount:(WeiboAccount *)account {
    if (!account.user) {
        return NO;
    }
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
    return YES;
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
    return nil;
}

- (void)signOut {
    WeiboAccount *currentAccount = [self currentAccount];
    if (currentAccount) {
        [self removeWeiboAccount:currentAccount];
    }
}

@end
