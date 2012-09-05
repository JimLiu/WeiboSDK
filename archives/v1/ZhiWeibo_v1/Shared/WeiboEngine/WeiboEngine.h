//
//  WeiboEngine.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-20.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFHFKeychainUtils.h"
#import "WeiboAccounts.h"
#import "PathHelper.h"
#import "WeiboAccount.h"

@interface WeiboEngine : NSObject {

}

+ (NSString *)username;
+ (NSString *)password;


+ (WeiboAccounts *)weiboAccounts;

+ (void)addWeiboAccount:(WeiboAccount *)account selected:(BOOL)selected;

+ (void)removeWeiboAccount:(WeiboAccount *)account;

+ (void)removeWeiboAccountAtIndex:(int)index;

+ (WeiboAccount *)currentAccount;

+ (void)selectAccountAtIndex:(int)index;



+ (void)setUsername:(NSString *)newUsername password:(NSString *)newPassword remember:(BOOL)storePassword;
+ (void)forgetPassword;
+ (void)remindPassword;
+ (void)selectUser:(User *)user;

+ (NSString *)consumerKey;
+ (NSString *)consumerSecret;
+ (void)setConsumerKey:(NSString *)key secret:(NSString *)secret;

+ (NSString *)getCurrentUserStoreagePath:(NSString *)filename;
+ (NSString *)getWeiboAccountsStoragePath;
+ (void)loadWeiboAccounts;
+ (void)selectWeiboAccount:(int)selectedIndex;
+ (void)selectCurrentUser;
+ (User *)getCurrentUser;

@end
