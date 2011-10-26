//
//  WeiboEngine.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-20.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "WeiboEngine.h"

#define kServiceName					@"zhiweibo"

static NSString *_username;
static NSString *_password;
static WeiboAccounts *_weiboAccounts;

@implementation WeiboEngine

+ (NSString *)getWeiboAccountsStoragePath {
	NSString *filePath = [[PathHelper documentDirectoryPathWithName:@"db"] 
						  stringByAppendingPathComponent:@"accounts.weibo"];
	return filePath;
}

+ (void)loadWeiboAccounts {
	NSString *filePath = [WeiboEngine getWeiboAccountsStoragePath];
	WeiboAccounts *weiboAccounts = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
	if (!weiboAccounts) {
		weiboAccounts = [[[WeiboAccounts alloc] init] autorelease];
		[NSKeyedArchiver archiveRootObject:weiboAccounts toFile:filePath];
	}
	[_weiboAccounts release];
	_weiboAccounts = [weiboAccounts retain];
}

+ (void)saveWeiboAccounts {
	NSString *filePath = [self getWeiboAccountsStoragePath];
	[NSKeyedArchiver archiveRootObject:self.weiboAccounts toFile:filePath];
}

+ (WeiboAccounts *)weiboAccounts
{
	if (!_weiboAccounts) {
		[self loadWeiboAccounts];
	}
	return _weiboAccounts;
}

+ (void)addWeiboAccount:(WeiboAccount *)account selected:(BOOL)selected {
	[self.weiboAccounts addAccount:account selected:selected];
	[self saveWeiboAccounts];
}

+ (void)removeWeiboAccount:(WeiboAccount *)account {
	[self.weiboAccounts removeAccount:account];
	[self saveWeiboAccounts];
}

+ (void)removeWeiboAccountAtIndex:(int)index {
	[self.weiboAccounts removeWeiboAccountAtIndex:index];
	[self saveWeiboAccounts];
}

+ (void)selectAccountAtIndex:(int)index {
	[self.weiboAccounts setSelectedIndex:index];
}

+ (WeiboAccount *)currentAccount {
	return [self.weiboAccounts currentAccount];
}


+ (NSString *)username
{
	if(!_username)
		_username = [[[NSUserDefaults standardUserDefaults] stringForKey:@"DefaultAccount"] copy];
    return _username;
}


+ (NSString *)password
{
	if(!_password && [WeiboEngine username])
	{
		NSError *error = nil;
		_password = [[SFHFKeychainUtils getPasswordForUsername:[WeiboEngine username] andServiceName:kServiceName error:&error] copy];
	}
	
    return _password;
}

+ (void)setUsername:(NSString *)newUsername password:(NSString *)newPassword remember:(BOOL)storePassword
{
    // Set new credentials.
    [_username release];
    _username = [newUsername copy];
    [_password release];
    _password = [newPassword copy];
	
	if(storePassword)
	{
		NSError *error = nil;
		[[NSUserDefaults standardUserDefaults] setObject:_username forKey:@"DefaultAccount"];
		[SFHFKeychainUtils storeUsername:_username andPassword:_password forServiceName:kServiceName updateExisting:YES error:&error];
	}
	else
	{
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DefaultAccount"];
	}
}

+ (void)forgetPassword
{
	NSError *error = nil;
	[SFHFKeychainUtils deleteItemForUsername:_username andServiceName:kServiceName error:&error];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DefaultAccount"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)remindPassword
{
	[[NSUserDefaults standardUserDefaults] setObject:[WeiboEngine username] forKey:@"DefaultAccount"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)selectUser:(User *)user {
	if (user) {
		[_username release];
		[_password release];
		NSError *error = nil;
		_username = [user.username copy];
		_password = [[SFHFKeychainUtils getPasswordForUsername:_username andServiceName:kServiceName error:&error] copy];
	}
}

+ (NSString *)getCurrentUserStoreagePath:(NSString *)filename {
	User *user = [self currentAccount].user;
	if (!user) {
		return nil;
	}
	return [[PathHelper documentDirectoryPathWithName:[NSString stringWithFormat:@"%lld", user.userId]]
			stringByAppendingPathComponent:filename];
}


+ (void)selectWeiboAccount:(int)selectedIndex {
	self.weiboAccounts.selectedIndex = selectedIndex;
	NSString *filePath = [WeiboEngine getWeiboAccountsStoragePath];
	[NSKeyedArchiver archiveRootObject:self.weiboAccounts toFile:filePath];	
	
	User *user = [self getCurrentUser];
	[WeiboEngine selectUser:user];
}

+ (void)selectCurrentUser {
	User *user = [self getCurrentUser];
	[WeiboEngine selectUser:user];
}

+ (User *)getCurrentUser {
	return [self currentAccount].user;
}

@end
