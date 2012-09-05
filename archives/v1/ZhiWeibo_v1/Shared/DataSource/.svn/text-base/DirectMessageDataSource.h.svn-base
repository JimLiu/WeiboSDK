//
//  DirectMessageDataSource.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-14.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboClient.h"
#import "DirectMessage.h"
#import "WeiboEngine.h"
#import "Conversation.h"
#import "PullRefreshTableView.h"
#import "PullRefreshTableViewDataSource.h"
#import "DirectMessageDraft.h"
#import "Reachability2.h"

@protocol DirectMessageDataSourceDelegate

- (void)unreadMessagesCountChanged:(int)unreadMessageCount;

- (void)conversationSelected:(Conversation *)conversation;

- (void)reloadConversation;

@end

@interface DirectMessageDataSource : PullRefreshTableViewDataSource<UITableViewDelegate, UITableViewDataSource> {
	WeiboClient *receivedMessagesClient;
	WeiboClient *sentMessagesClient;
	NSMutableArray *conversations;
	NSMutableDictionary *conversationsDic;
	NSObject *conversationsLockObject;
	id<DirectMessageDataSourceDelegate> directMessageDataSourceDelegate;
	int unreadMessagesCount;
	BOOL firstLoad;
	
	long long lastReceivedDirectMessageId;
	long long lastSentDirectMessageId;
}

@property (nonatomic, assign) id<DirectMessageDataSourceDelegate> directMessageDataSourceDelegate;

- (void)loadRecentDirectMessages;

- (void)saveConversationsToLocal;

- (void)resetUnreadCounts;

- (void)sendDirectMessage:(DirectMessageDraft*)_draft;

@end
