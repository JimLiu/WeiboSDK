//
//  WeiboAccount.h
//  Zhiweibo2
//
//  Created by junmin liu on 11-2-14.
//  Copyright 2011 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuth.h"
#import "User.h"


@interface WeiboAccount : NSObject {
	OAuth *_oAuth;
	User *_user;
}

@property (nonatomic, retain) OAuth *oAuth;
@property (nonatomic, retain) User *user;



- (id)initWithUser:(User *)user 
			 oAuth:(OAuth *)oAuth;


+ (WeiboAccount *)accountWithUser:(User *)user 
							oAuth:(OAuth *)oAuth;

- (NSString *)getCurrentUserStoreagePath:(NSString *)filename;

@end
