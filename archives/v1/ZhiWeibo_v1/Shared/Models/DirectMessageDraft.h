//
//  DirectMessageDraft.h
//  ZhiWeibo
//
//  Created by Zhang Jason on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	DirectMessageDraftStateEditing,
	DirectMessageDraftStateSending,
	DirectMessageDraftStateSent,
	DirectMessageDraftStateFault
} DirectMessageDraftState;

@interface DirectMessageDraft : NSObject {
	long draftId;
	DirectMessageDraftState directMessageDraftState;
	time_t createdAt;
	NSString *text;
	long long senderId;
	long long	recipientId;
}

@property (nonatomic,assign) long draftId;
@property (nonatomic,assign) DirectMessageDraftState directMessageDraftState;
@property (nonatomic,assign) time_t createdAt;
@property (nonatomic,retain) NSString *text;
@property (nonatomic,assign) long long	recipientId;
@property (nonatomic,assign) long long senderId;


- (NSString *)getDraftPath;
- (void)save;
- (void)delete;

@end
