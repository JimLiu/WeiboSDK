//
//  ConversationDataSource.h
//  ZhiWeibo
//
//  Created by junmin liu on 11-1-3.
//  Copyright 2011 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboClient.h"
#import "DirectMessage.h"
#import "DirectMessageDraft.h"
#import "Conversation.h"
#import "WeiboEngine.h"
#import "Conversation.h"
#import "MessageTableViewCell.h"
#import "TweetDocument.h"
#import "MessageDraftViewCell.h"

@protocol ConversationDataSourceDelegate

- (void)resendDraft:(DirectMessageDraft*)_draft;

- (void)processTweetNode:(TweetNode*)node;

- (void)hideKeyboard;

@end


@interface ConversationDataSource : NSObject<UITableViewDelegate, UITableViewDataSource,MessageDraftViewCellDelegate,MessageTableViewCellDelegate> {

	UITableView *tableView;
	Conversation *conversation;
	NSMutableArray *messageFiles;
	NSMutableDictionary *messagesDic;
	NSMutableDictionary *messageDocs;
	
	id<ConversationDataSourceDelegate> conversationDataSourceDelegate;
}

@property (nonatomic, assign) id<ConversationDataSourceDelegate> conversationDataSourceDelegate;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) Conversation *conversation;

- (id)initWithTableView:(UITableView *)_tableView;

- (void)reloadMessages;

- (void)reset;

@end
