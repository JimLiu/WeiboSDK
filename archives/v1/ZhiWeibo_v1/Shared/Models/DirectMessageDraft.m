//
//  DirectMessageDraft.m
//  ZhiWeibo
//
//  Created by Zhang Jason on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DirectMessageDraft.h"
#import "WeiboEngine.h"


@implementation DirectMessageDraft

@synthesize draftId;
@synthesize createdAt;
@synthesize directMessageDraftState;
@synthesize text;
@synthesize senderId;
@synthesize recipientId;

- (id)init {
	
	if (self = [super init]) {
		draftId = (long)[[NSDate date] timeIntervalSince1970];
		createdAt = (time_t) [[NSDate date] timeIntervalSince1970];
		directMessageDraftState = DirectMessageDraftStateEditing;
		senderId = [[WeiboEngine getCurrentUser] userId];
	}
	return self;
}


- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
		draftId = [decoder decodeIntForKey:@"draftId"];
		directMessageDraftState = [decoder decodeIntForKey:@"directMessageDraftState"];
		createdAt = [decoder decodeIntForKey:@"createdAt"];
		text = [[decoder decodeObjectForKey:@"text"] retain];
		//NSLog(@"init:%@",text);
		senderId = [decoder decodeInt64ForKey:@"senderId"];
		recipientId = [decoder decodeInt64ForKey:@"recipientId"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeInt:draftId forKey:@"draftId"];
	[encoder encodeInt:directMessageDraftState forKey:@"directMessageDraftState"];
	[encoder encodeInt:createdAt forKey:@"createdAt"];
	[encoder encodeObject:text forKey:@"text"];
	//NSLog(@"save:%@",text);
	[encoder encodeInt64:senderId forKey:@"senderId"];
	[encoder encodeInt64:recipientId forKey:@"recipientId"];
	
}

- (void)dealloc {
	[text release];
	[super dealloc];
}

- (long long)conversationId {
	return senderId + recipientId;
}

- (NSString *)getDraftPath {
	NSString *filePath = [WeiboEngine getCurrentUserStoreagePath:@"conversations"];
	filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld",self.conversationId]];

	[PathHelper createPathIfNecessary:filePath];
	
	return [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.draft.db", createdAt]];
}

- (void)save {
	NSString *filePath = [self getDraftPath];
	[NSKeyedArchiver archiveRootObject:self toFile:filePath];	
}

- (void)delete {
	NSString *filePath = [self getDraftPath];
	NSFileManager* fm = [NSFileManager defaultManager];
	if (filePath && [fm fileExistsAtPath:filePath]) {
		[fm removeItemAtPath:filePath error:nil];
	}
}

@end
