//
//  Draft.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-29.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Status.h"
#import "Comment.h"

typedef enum {
	DraftTypeNewTweet,
	DraftTypeReTweet,
	DraftTypeReplyComment
} DraftType;

typedef enum {
	DraftStatusDraft,
	DraftStatusSending,
	DraftStatusSentFailt,
} DraftStatus;

@interface Draft : NSObject {
	long draftId;
	DraftType draftType;
	DraftStatus draftStatus;
	Status *replyToStatus;
	Comment *replyToComment;
	BOOL comment;
	BOOL retweet;
	BOOL commentToOriginalStatus;
	time_t createdAt;
	NSString *text;
	double latitude;
	double longitude;
	NSData *attachmentData;
	UIImage *attachmentImage;	
	int clientCount;//可能需要创建多个连接，这是连接数
	int failedClientCount;//失败的连接数
}

@property (nonatomic, assign) long draftId;
@property (nonatomic, assign) DraftType draftType;
@property (nonatomic, assign) DraftStatus draftStatus;
@property (nonatomic, retain) Status *replyToStatus;
@property (nonatomic, retain) Comment *replyToComment;
@property (nonatomic, assign) BOOL comment;
@property (nonatomic, assign) BOOL retweet;
@property (nonatomic, assign) BOOL commentToOriginalStatus;
@property (nonatomic, assign) time_t createdAt;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, readonly) NSData *attachmentData;
@property (nonatomic, retain) UIImage *attachmentImage;
@property (nonatomic, assign) int clientCount;
@property (nonatomic, assign) int failedClientCount;

- (id)initWithType:(DraftType)_draftType;

- (void)save;

- (void)delete;

@end
