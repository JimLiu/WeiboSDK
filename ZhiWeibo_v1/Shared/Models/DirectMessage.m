//
//  DirectMessage.m
//  WeiboPad
//
//  Created by junmin liu on 10-10-6.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "DirectMessage.h"
#import "WeiboEngine.h"
#import "PathHelper.h"


@implementation DirectMessage
@synthesize directMessageId, text, senderId, recipientId, createdAt, senderScreenName, recipientScreenName;
@synthesize sender, recipient;
@synthesize conversationId;


- (id)init {
	if(self = [super init]){

	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
		directMessageId = [decoder decodeInt64ForKey:@"directMessageId"];
		text = [[decoder decodeObjectForKey:@"text"]retain];
		senderId = [decoder decodeInt64ForKey:@"senderId"];
		recipientId = [decoder decodeInt64ForKey:@"recipientId"];
		createdAt = [decoder decodeIntForKey:@"createdAt"];
		senderScreenName = [[decoder decodeObjectForKey:@"senderScreenName"] retain];
		recipientScreenName = [[decoder decodeObjectForKey:@"recipientScreenName"]retain];
		sender = [[decoder decodeObjectForKey:@"sender"]retain];
		recipient = [[decoder decodeObjectForKey:@"recipient"] retain];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {	
	[encoder encodeInt64:directMessageId forKey:@"directMessageId"];
	[encoder encodeObject:text forKey:@"text"];
	[encoder encodeInt64:senderId forKey:@"senderId"];
	[encoder encodeInt64:recipientId forKey:@"recipientId"];
	[encoder encodeInt:createdAt forKey:@"createdAt"];
	[encoder encodeObject:senderScreenName forKey:@"senderScreenName"];
	[encoder encodeObject:recipientScreenName forKey:@"recipientScreenName"];
	[encoder encodeObject:sender forKey:@"sender"];
	[encoder encodeObject:recipient forKey:@"recipient"];
}

- (long long)conversationId {
	return senderId + recipientId;
}

- (NSNumber *)conversationKey {
	return [NSNumber numberWithLongLong:[self conversationId]];
}

- (DirectMessage*)initWithJsonDictionary:(NSDictionary*)dic {

	if (self = [super init]) {
		directMessageId = [dic getLongLongValueValueForKey:@"id" defaultValue:-1];
		text = [[dic getStringValueForKey:@"text" defaultValue:@""] retain];
		senderId = [dic getLongLongValueValueForKey:@"sender_id" defaultValue:-1];
		recipientId = [dic getLongLongValueValueForKey:@"recipient_id" defaultValue:-1];
		senderScreenName = [[dic getStringValueForKey:@"sender_screen_name" defaultValue:@""] retain];
		recipientScreenName = [[dic getStringValueForKey:@"recipient_screen_name" defaultValue:@""] retain];
		createdAt = [dic getTimeValueForKey:@"created_at" defaultValue:0];
		
		NSDictionary* senderDic = [dic objectForKey:@"sender"];
		if (senderDic) {
			sender = [[User userWithJsonDictionary:senderDic] retain];
		}
		
		NSDictionary* recipientDic = [dic objectForKey:@"recipient"];
		if (recipientDic) {
			recipient = [[User userWithJsonDictionary:recipientDic] retain];
		}
		
	}
	return self;

}

+ (DirectMessage*)directMessageWithJsonDictionary:(NSDictionary*)dic {
	return [[[DirectMessage alloc] initWithJsonDictionary:dic] autorelease];
}

- (void)dealloc {
	[text release];
	[senderScreenName release];
	[recipientScreenName release];
	[sender release];
	[recipient release];
	[super dealloc];
}

- (void)save {
	NSString *filename = [NSString stringWithFormat:@"conversations/%lld", self.conversationId];
	NSString *filePath = [WeiboEngine getCurrentUserStoreagePath:filename];
	[PathHelper createPathIfNecessary:filePath];
	filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.%lld.db", createdAt, directMessageId]];
	[NSKeyedArchiver archiveRootObject:self toFile:filePath];
}

- (NSString *)timeString {
	static NSDateFormatter *dateFormatter = nil;
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	}
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:createdAt];        
	return [dateFormatter stringFromDate:date];
}

@end
