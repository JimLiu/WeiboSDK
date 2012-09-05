//
//  WeiboAccounts.m
//  Zhiweibo2
//
//  Created by junmin liu on 11-2-14.
//  Copyright 2011 Openlab. All rights reserved.
//

#import "WeiboAccounts.h"


@implementation WeiboAccounts
@synthesize accounts, selectedIndex;

- (id)init {
	if (self = [super init]) {
		selectedIndex = 0;
		accounts = [[NSMutableArray alloc] init];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
		selectedIndex = [decoder decodeIntForKey:@"selectedIndex"];
		accounts = [[decoder decodeObjectForKey:@"accounts"] retain];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt:selectedIndex forKey:@"selectedIndex"];
    [encoder encodeObject:accounts forKey:@"accounts"];
}

- (void)dealloc {
	[accounts release];
	[super dealloc];
}

- (void)addAccount:(WeiboAccount *)account selected:(BOOL)selected {
	if (!accounts) {
        accounts = [[NSMutableArray alloc] init];
    }
	int accountIndex = -1;
	BOOL isExists = NO;
	for (WeiboAccount *wa in accounts) {
		accountIndex++;
		if (wa.user.userId == account.user.userId) {
			isExists = YES;
			break;
		}
	}
	if (isExists) {
		[accounts removeObjectAtIndex:accountIndex];
	}
	[accounts insertObject:account atIndex:0];
	if (selected) {
		selectedIndex = 0;
	}
}

- (void)removeAccount:(WeiboAccount *)account {
	[accounts removeObject:account];
	if (selectedIndex > accounts.count - 1) {
		selectedIndex = 0;
	}
}

- (void)removeWeiboAccountAtIndex:(int)index {
	if (index >= 0 && index < accounts.count) {
		[accounts removeObjectAtIndex:index];
		if (selectedIndex == index) {
			selectedIndex = index - 1;
		}
	}
}


- (WeiboAccount *)currentAccount {
	if (accounts.count == 0) {
		return nil;
	}
	if (selectedIndex < 0 || selectedIndex > accounts.count - 1) {
		selectedIndex = 0;
	}
	return [accounts objectAtIndex:selectedIndex];
}

- (void)setSelectedIndex:(int)_index {
	if (_index < 0 || _index > accounts.count - 1) {
		_index = 0;
	}
	selectedIndex = _index;
}

@end
