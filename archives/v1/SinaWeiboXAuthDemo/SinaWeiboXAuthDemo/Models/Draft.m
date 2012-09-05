//
//  Draft.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-10-28.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "Draft.h"
#import "NSStringAdditions.h"

@implementation Draft
@synthesize draftId, draftType, draftStatus, statusId, commentId, recipientedId, commentOrRetweet;
@synthesize	createdAt, text, latitude, longitude, attachmentImage;

- (id)init {
	
	if (self = [super init]) {
		draftId = [[NSString generateGuid] retain];
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
	[draftId release];
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
	// todo: auto resize image;
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


- (id)initWithStatement:(Statement *)stmt {
	if (self = [super init]) {
		draftId = [[stmt getString:0] retain];
		draftType = [stmt getInt32:1];
		draftStatus = [stmt getInt32:2];
		statusId = [stmt getInt64:3];
		commentId = [stmt getInt64:4];
		recipientedId = [stmt getInt32:5];
		commentOrRetweet = [stmt getInt32:6];
		createdAt = [stmt getInt32:7];
		text = [[stmt getString:8] retain];
		latitude = [stmt getDouble:9];
		longitude = [stmt getDouble:10];

		NSData *data = [stmt getData:11];
		if (data) {
			attachmentData = [data retain];
			attachmentImage = [[UIImage imageWithData:attachmentData] retain];
		}
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
		draftId = [[decoder decodeObjectForKey:@"draftId"] retain];
		draftType = [decoder decodeIntForKey:@"draftType"];
		draftStatus = [decoder decodeIntForKey:@"draftStatus"];
		statusId = [decoder decodeInt64ForKey:@"statusId"];
		commentId = [decoder decodeInt64ForKey:@"commentId"];
		recipientedId = [decoder decodeIntForKey:@"recipientedId"];
		commentOrRetweet = [decoder decodeBoolForKey:@"commentOrRetweet"];
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
	[encoder encodeObject:draftId forKey:@"draftId"];
	[encoder encodeInt:draftType forKey:@"draftType"];
	[encoder encodeInt:draftStatus forKey:@"draftStatus"];
	[encoder encodeInt64:statusId forKey:@"statusId"];
	[encoder encodeInt64:commentId forKey:@"commentId"];
	[encoder encodeInt:recipientedId forKey:@"recipientedId"];
	[encoder encodeBool:commentOrRetweet forKey:@"commentOrRetweet"];
	[encoder encodeInt:createdAt forKey:@"createdAt"];
	[encoder encodeObject:text forKey:@"text"];
	[encoder encodeDouble:latitude forKey:@"latitude"];
	[encoder encodeDouble:longitude forKey:@"longitude"];
	[encoder encodeObject:attachmentData forKey:@"attachmentImage"];
}

- (void)updateDB
{
    static Statement *stmt = nil;
    if (stmt == nil) {
        stmt = [DBConnection statementWithQuery:"REPLACE INTO drafts VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"];
        [stmt retain];
    }
    [stmt bindString:draftId              forIndex:1];
    [stmt bindInt32:draftType               forIndex:2];
	[stmt bindInt32:draftStatus forIndex:3];
    [stmt bindInt64:statusId         forIndex:4];
    [stmt bindInt64:commentId         forIndex:5];
    [stmt bindInt32:recipientedId         forIndex:6];
	[stmt bindInt32:commentOrRetweet forIndex:7];
    [stmt bindInt32:createdAt           forIndex:8];
    [stmt bindString:text        forIndex:9];
    [stmt bindDouble:latitude                forIndex:10];
    [stmt bindDouble:longitude    forIndex:11];
	[stmt bindData:attachmentData forIndex:12];
	
	int step = [stmt step];
    if (step != SQLITE_DONE) {
		NSLog(@"update error draft: %@.%d.%@", draftId, draftType, text);
        [DBConnection alert];
    }
    [stmt reset];
}


- (void)deleteFromDB
{
    Statement *stmt = [DBConnection statementWithQuery:"DELETE FROM drafts WHERE draftId = ?"];
    [stmt bindString:draftId forIndex:1];
    [stmt step]; // ignore error
}

/*
- (void)deleteByType:(DraftType)_type andText:(NSString *)_text {
    Statement *stmt = [DBConnection statementWithQuery:"DELETE FROM drafts WHERE draftType = ? and text = ?"];
    [stmt bindInt32:_type forIndex:1];
    [stmt bindString:_text forIndex:2];
    [stmt step]; // ignore error
}
 */

@end
