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

@interface DirectMessage : NSObject {
	sqlite_int64	directMessageId; // 私信ID
	NSString*		text;
	int				senderId;
	int				recipientId;
	time_t			createdAt;
	NSString*		senderScreenName;
	NSString*		recipientScreenName;
	User*			sender;
	User*			recipient;
}

@property (nonatomic, assign) sqlite_int64	directMessageId; // 私信ID
@property (nonatomic, retain) NSString*		text;
@property (nonatomic, assign) int			senderId;
@property (nonatomic, assign) int			recipientId;
@property (nonatomic, assign) time_t		createdAt;
@property (nonatomic, retain) NSString*		senderScreenName;
@property (nonatomic, retain) NSString*		recipientScreenName;
@property (nonatomic, retain) User*			sender;
@property (nonatomic, retain) User*			recipient;

- (DirectMessage*)initWithJsonDictionary:(NSDictionary*)dic;

+ (DirectMessage*)directMessageWithJsonDictionary:(NSDictionary*)dic;

@end
