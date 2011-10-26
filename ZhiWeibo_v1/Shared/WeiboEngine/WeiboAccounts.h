//
//  WeiboAccounts.h
//  Zhiweibo2
//
//  Created by junmin liu on 11-2-14.
//  Copyright 2011 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboAccount.h"

@interface WeiboAccounts : NSObject {
	NSMutableArray *accounts;
	int selectedIndex;
}

@property (nonatomic, retain) NSMutableArray *accounts;
@property (nonatomic, assign) int selectedIndex;

- (WeiboAccount *)currentAccount;

- (void)addAccount:(WeiboAccount *)account selected:(BOOL)selected;

- (void)removeAccount:(WeiboAccount *)account;

- (void)removeWeiboAccountAtIndex:(int)index;

@end
