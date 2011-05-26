//
//  SinaWeiboClient.h
//  Zhiweibo2
//
//  Created by junmin liu on 11-2-21.
//  Copyright 2011 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboConnection.h"

@interface SinaWeiboClient : WeiboConnection {

}

+ (SinaWeiboClient *)connectionWithDelegate:(id)aDelegate 
									 action:(SEL)anAction
									  oAuth:(OAuth *)_oAuth;

+ (SinaWeiboClient *)connectionWithDelegate:(id)aDelegate 
									 action:(SEL)anAction;

#pragma mark -
#pragma mark Followed Timeline 

- (void)getFollowedTimelineMaximumID:(long long)maxID startingAtPage:(int)page count:(int)count;
- (void)getFollowedTimelineSinceID:(long long)sinceID startingAtPage:(int)pageNum count:(int)count; // statuses/friends_timeline
- (void)getFollowedTimelineSinceID:(long long)sinceID withMaximumID:(long long)maxID startingAtPage:(int)pageNum count:(int)count; // statuses/friends_timeline


- (void)post:(NSString*)tweet;

- (void)upload:(NSData*)jpeg status:(NSString *)status;


@end
