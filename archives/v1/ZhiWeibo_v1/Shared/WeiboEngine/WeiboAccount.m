//
//  WeiboAccount.m
//  Zhiweibo2
//
//  Created by junmin liu on 11-2-14.
//  Copyright 2011 Openlab. All rights reserved.
//

#import "WeiboAccount.h"
#import "PathHelper.h"

@implementation WeiboAccount
@synthesize oAuth = _oAuth;
@synthesize user = _user;


- (id)initWithUser:(User *)user 
			 oAuth:(OAuth *)oAuth { 
    self = [super init];
	if (self) {
		_oAuth = [oAuth retain];
		_user = [user retain];
	}
	return self;
}


- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
	if (self) {
		_oAuth = [[decoder decodeObjectForKey:@"oAuth"]retain];
		_user = [[decoder decodeObjectForKey:@"user"]retain];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:_oAuth forKey:@"oAuth"];
	[encoder encodeObject:_user forKey:@"user"];
}

- (void)dealloc {
	[_oAuth release];
	[_user release];
	[super dealloc];
}

+ (WeiboAccount *)accountWithUser:(User *)user 
							oAuth:(OAuth *)oAuth {
	return [[[WeiboAccount alloc]initWithUser:user oAuth:oAuth] autorelease];
}

- (NSString *)getCurrentUserStoreagePath:(NSString *)filename {
	if (!_user) {
		return nil;
	}
	return [[PathHelper documentDirectoryPathWithName:[NSString stringWithFormat:@"%lld", _user.userId]]
			stringByAppendingPathComponent:filename];
}

@end
