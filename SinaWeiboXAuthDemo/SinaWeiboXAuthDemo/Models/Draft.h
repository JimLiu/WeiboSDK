//
//  Draft.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-10-28.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Statement.h"
#import "DBConnection.h"

typedef enum {
	DraftTypeNewTweet,
	DraftTypeReTweet,
	DraftTypeReplyComment,
	DraftTypeDirectMessage,
} DraftType;

typedef enum {
	DraftStatusDraft,
	DraftStatusSending,
	DraftStatusSentFailt,
} DraftStatus;

@interface Draft : NSObject {
	NSString *draftId;
	DraftType draftType;
	DraftStatus draftStatus;
	long long statusId;
	long long commentId;
	int recipientedId;
	BOOL commentOrRetweet;
	time_t createdAt;
	NSString *text;
	double latitude;
	double longitude;
	NSData *attachmentData;
	UIImage *attachmentImage;
}

@property (nonatomic, retain) NSString *draftId;
@property (nonatomic, assign) DraftType draftType;
@property (nonatomic, assign) DraftStatus draftStatus;
@property (nonatomic, assign) long long statusId;
@property (nonatomic, assign) long long commentId;
@property (nonatomic, assign) int recipientedId;
@property (nonatomic, assign) BOOL commentOrRetweet;
@property (nonatomic, assign) time_t createdAt;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, readonly) NSData *attachmentData;
@property (nonatomic, retain) UIImage *attachmentImage;

- (id)initWithType:(DraftType)_draftType;

- (void)updateDB;

- (void)deleteFromDB;

@end
