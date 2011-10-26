//
//  DirectMessageConversation.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-31.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "Conversation.h"


@implementation Conversation
@synthesize conversationId;
@synthesize user, mostRecentDate, mostRecentMessage;
@synthesize hasReplied, unread, mostRecentDirectMessageId;
@synthesize draft;

- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
		conversationId = [decoder decodeInt64ForKey:@"conversationId"];
		hasReplied = [decoder decodeBoolForKey:@"hasReplied"];
		unread = [decoder decodeBoolForKey:@"unread"];
		mostRecentMessage = [[decoder decodeObjectForKey:@"mostRecentMessage"]retain];
		mostRecentDate = [decoder decodeIntForKey:@"mostRecentDate"];
		user = [[decoder decodeObjectForKey:@"user"]retain];
		mostRecentDirectMessageId = [decoder decodeInt64ForKey:@"mostRecentDirectMessageId"];
		draft = [[decoder decodeObjectForKey:@"draft"] retain];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {	
	[encoder encodeInt64:conversationId forKey:@"conversationId"];
	[encoder encodeBool:hasReplied forKey:@"hasReplied"];
	[encoder encodeBool:unread forKey:@"unread"];
	[encoder encodeObject:mostRecentMessage forKey:@"mostRecentMessage"];
	[encoder encodeInt:mostRecentDate forKey:@"mostRecentDate"];
	[encoder encodeObject:user forKey:@"user"];
	[encoder encodeInt64:mostRecentDirectMessageId forKey:@"mostRecentDirectMessageId"];
	[encoder encodeObject:draft forKey:@"draft"];
}

- (NSNumber *)conversationKey {
	if (!_conversationKey) {
		_conversationKey = [[NSNumber numberWithLongLong:conversationId] retain];
	}
	return _conversationKey;
}

- (void)setConversationId:(long long)_newId {
	if (conversationId != _newId) {
		conversationId = _newId;
		[_conversationKey release];
		_conversationKey = nil;
	}
}

- (void)dealloc {
	[draft release];
	[_conversationKey release];
	[user release];
	[mostRecentMessage release];
	[super dealloc];
}

- (NSComparisonResult)compare:(Conversation *)otherObject {
    return self.mostRecentDate < otherObject.mostRecentDate;
}

- (NSString *)mostRecentDateString {
	static NSDateFormatter *dateFormatter = nil;
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	}
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:mostRecentDate];        
	return [dateFormatter stringFromDate:date];
}

@end
