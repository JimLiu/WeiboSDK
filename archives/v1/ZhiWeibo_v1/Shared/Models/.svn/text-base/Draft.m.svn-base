//
//  Draft.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-29.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "Draft.h"
#import "NSStringAdditions.h"
#import "WeiboEngine.h"

@implementation Draft
@synthesize draftId, draftType, draftStatus, replyToStatus, replyToComment;
@synthesize comment, retweet, commentToOriginalStatus;
@synthesize	createdAt, text, latitude, longitude, attachmentImage;
@synthesize clientCount, failedClientCount;

- (id)init {
	
	if (self = [super init]) {
		//draftId = [[NSString generateGuid] retain];
		draftId = (long)[[NSDate date] timeIntervalSince1970];
		createdAt = (time_t) [[NSDate date] timeIntervalSince1970];
	}
	return self;
}

- (id)initWithType:(DraftType)_draftType {
	if (self = [self init]) {
		draftType = _draftType;
	}
	return self;
}

- (void)dealloc {
	//[draftId release];
	[text release];
	[attachmentData release];
	[attachmentImage release];
	[super dealloc];
}

- (NSData *)attachmentData {
	if (!attachmentData && attachmentImage) {
		attachmentData = [UIImageJPEGRepresentation(attachmentImage, 0.8) retain];
	}
	return attachmentData;
}

- (void)setAttachmentImage:(UIImage *)_image {
	if (attachmentImage != _image) {
		[attachmentImage release];
		attachmentImage = [_image retain];
		[attachmentData release];
		if (attachmentImage) {
			attachmentData = [UIImageJPEGRepresentation(_image, 0.8) retain];
		}
		else {
			attachmentData = nil;
		}
		
	}
}

- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
		draftId = [decoder decodeIntForKey:@"draftId"];
		draftType = [decoder decodeIntForKey:@"draftType"];
		draftStatus = [decoder decodeIntForKey:@"draftStatus"];
		replyToStatus = [[decoder decodeObjectForKey:@"replyToStatus"] retain];
		replyToComment = [[decoder decodeObjectForKey:@"replyToComment"] retain];
		comment = [decoder decodeBoolForKey:@"comment"];
		retweet = [decoder decodeBoolForKey:@"retweet"];
		commentToOriginalStatus = [decoder decodeBoolForKey:@"commentToOriginalStatus"];
		createdAt = [decoder decodeIntForKey:@"createdAt"];
		text = [[decoder decodeObjectForKey:@"text"] retain];
		latitude = [decoder decodeDoubleForKey:@"latitude"];
		longitude = [decoder decodeDoubleForKey:@"longitude"];
		
		NSData *data = [decoder decodeObjectForKey:@"attachmentImage"];
		if (data) {
			attachmentData = [data retain];
			attachmentImage = [[UIImage imageWithData:attachmentData] retain];
		}
		
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeInt64:draftId forKey:@"draftId"];
	[encoder encodeInt:draftType forKey:@"draftType"];
	[encoder encodeInt:draftStatus forKey:@"draftStatus"];
	[encoder encodeObject:replyToStatus forKey:@"replyToStatus"];
	[encoder encodeObject:replyToComment forKey:@"replyToComment"];
	[encoder encodeBool:comment forKey:@"comment"];
	[encoder encodeBool:retweet forKey:@"retweet"];
	[encoder encodeBool:commentToOriginalStatus forKey:@"commentToOriginalStatus"];
	[encoder encodeInt:createdAt forKey:@"createdAt"];
	[encoder encodeObject:text forKey:@"text"];
	[encoder encodeDouble:latitude forKey:@"latitude"];
	[encoder encodeDouble:longitude forKey:@"longitude"];
	[encoder encodeObject:attachmentData forKey:@"attachmentImage"];
}

- (NSString *)getDraftPath {
	NSString *filePath = [WeiboEngine getCurrentUserStoreagePath:@"drafts"];
	[PathHelper createPathIfNecessary:filePath];
	
	return [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld.plist", draftId]];
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
