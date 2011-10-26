//
//  DirectMessageConversation.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-31.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface Conversation : NSObject {
	long long conversationId;
	NSNumber *_conversationKey;
	BOOL hasReplied;
	BOOL unread;
	User *user;
	time_t mostRecentDate;
	NSString *mostRecentMessage;
	long long mostRecentDirectMessageId;
	NSString *draft;
}

@property (nonatomic, assign) long long conversationId;
@property (nonatomic, readonly) NSNumber *conversationKey;
@property (nonatomic, assign) BOOL hasReplied;
@property (nonatomic, assign) BOOL unread;
@property (nonatomic, retain) User *user;
@property (nonatomic, assign) time_t mostRecentDate;
@property (nonatomic, retain) NSString *mostRecentMessage;
@property (nonatomic, assign) long long mostRecentDirectMessageId;
@property (nonatomic, retain) NSString *draft;

- (NSString *)mostRecentDateString;


@end
