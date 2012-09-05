//
//  DirectMessage.h
//  WeiboPad
//
//  Created by junmin liu on 10-10-6.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "NSDictionaryAdditions.h"
#import "User.h"

@interface DirectMessage : NSObject<NSCoding> {
	long long	directMessageId; // 私信ID
	NSString*		text;
	long long				senderId;
	long long				recipientId;
	time_t			createdAt;
	NSString*		senderScreenName;
	NSString*		recipientScreenName;
	User*			sender;
	User*			recipient;
	
}

@property (nonatomic, assign) long long	directMessageId; // 私信ID
@property (nonatomic, retain) NSString*		text;
@property (nonatomic, assign) long long			senderId;
@property (nonatomic, assign) long long			recipientId;
@property (nonatomic, assign) time_t		createdAt;
@property (nonatomic, retain) NSString*		senderScreenName;
@property (nonatomic, retain) NSString*		recipientScreenName;
@property (nonatomic, retain) User*			sender;
@property (nonatomic, retain) User*			recipient;
@property (nonatomic, readonly) long long conversationId;
@property (nonatomic, readonly) NSNumber *conversationKey;

- (DirectMessage*)initWithJsonDictionary:(NSDictionary*)dic;

+ (DirectMessage*)directMessageWithJsonDictionary:(NSDictionary*)dic;

- (void)save;

- (NSString *)timeString;

@end
