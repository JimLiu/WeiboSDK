//
//  DirectMessageDataSource.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-14.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "DirectMessageDataSource.h"
#import "NSDictionaryAdditions.h"
#import "UserCache.h"
#import "FriendCache.h"

@interface DirectMessageDataSource (Private)

- (void)directMessagesDidReceive:(NSObject*)obj;

@end


@implementation DirectMessageDataSource
@synthesize directMessageDataSourceDelegate;

- (id)initWithTableView:(PullRefreshTableView *)_tableView {
	if (self = [super initWithTableView:_tableView]) {
		conversationsLockObject = [[NSObject alloc] init];
		NSString *filePath = [WeiboEngine getCurrentUserStoreagePath:@"conversations.db"];
		NSMutableDictionary *_conversations = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
		if (_conversations) {
			conversations = [_conversations retain];
			firstLoad = NO;
		}
		else {
			conversations = [[NSMutableArray alloc]init];
			firstLoad = YES;
		}
		conversationsDic = [[NSMutableDictionary alloc]init];
		unreadMessagesCount = 0;
		for (Conversation *con in conversations) {
			[conversationsDic setObject:con forKey:con.conversationKey];
			if (con.unread == YES) {
				unreadMessagesCount++;
			}
		}
		if (directMessageDataSourceDelegate) {
			[directMessageDataSourceDelegate unreadMessagesCountChanged:unreadMessagesCount];
		}		
		if (conversations.count > 0) {
			long long mostRecentDirectMessageId = [[conversations objectAtIndex:0] mostRecentDirectMessageId];
			if (mostRecentDirectMessageId > 0) {
				lastReceivedDirectMessageId = mostRecentDirectMessageId;
				lastSentDirectMessageId = mostRecentDirectMessageId;
			}
		}
	}
	return self;
}

- (void)setDirectMessageDataSourceDelegate:(id <DirectMessageDataSourceDelegate>)_directMessageDataSourceDelegate {
	if (directMessageDataSourceDelegate != _directMessageDataSourceDelegate) {
		directMessageDataSourceDelegate = _directMessageDataSourceDelegate;
		if (directMessageDataSourceDelegate) {
			[directMessageDataSourceDelegate unreadMessagesCountChanged:unreadMessagesCount];
		}				
	}
}

- (void)dealloc {
	receivedMessagesClient.delegate = nil;
	[receivedMessagesClient release];
	receivedMessagesClient = nil;
	sentMessagesClient.delegate = nil;
	[sentMessagesClient release];
	sentMessagesClient = nil;
	[conversations release];
	[conversationsDic release];
	[conversationsLockObject release];
	[super dealloc];
}

- (void)resetUnreadCounts {
	unreadMessagesCount = 0;
	for (Conversation *con in conversations) {
		if (con.unread == YES) {
			unreadMessagesCount++;
		}
	}
	if (directMessageDataSourceDelegate) {
		[directMessageDataSourceDelegate unreadMessagesCountChanged:unreadMessagesCount];
	}		
}

- (void)reloadTableViewDataSource{
	[self loadRecentDirectMessages];
}

- (void)loadRecentDirectMessages {
	if (receivedMessagesClient || sentMessagesClient) {
		return;
	}
	NetworkStatus connectionStatus = [[Reachability2 sharedReachability] internetConnectionStatus];
	int downloadCount = (connectionStatus == ReachableViaWiFiNetwork) ? 200 : 100;

	receivedMessagesClient = [[WeiboClient alloc] initWithTarget:self 
											   action:@selector(receivedMessagesDidReceive:obj:)];
	[receivedMessagesClient getDirectMessagesSinceID:lastReceivedDirectMessageId startingAtPage:0 count:downloadCount];
	
	sentMessagesClient = [[WeiboClient alloc] initWithTarget:self 
														  action:@selector(sentMessagesDidReceive:obj:)];
	[sentMessagesClient getDirectMessagesSentSinceID:lastSentDirectMessageId startingAtPage:0 count:downloadCount];
	
}

- (void)stopLoading {
	[self doneLoadingTableViewData];
}

- (void)receivedMessagesDidReceive:(WeiboClient*)sender obj:(NSObject*)obj {
	[receivedMessagesClient autorelease];
	receivedMessagesClient = nil;
	
	if (sender.hasError) {
		NSLog(@"receivedMessagesDidReceive error!!!, errorMessage:%@, errordetail:%@"
			  , sender.errorMessage, sender.errorDetail);
        [sender alert];
		[self stopLoading];
        return;
    }
	
	[self directMessagesDidReceive:obj];
}

- (void)sentMessagesDidReceive:(WeiboClient*)sender obj:(NSObject*)obj {
	[sentMessagesClient autorelease];
	sentMessagesClient = nil;

	if (sender.hasError) {
		NSLog(@"sentMessagesDidReceive error!!!, errorMessage:%@, errordetail:%@"
			  , sender.errorMessage, sender.errorDetail);
        [sender alert];
		[self stopLoading];
        return;
    }
	
	[self directMessagesDidReceive:obj];
}

- (void)directMessagesDidReceive:(NSObject*)obj {

    if (obj == nil || ![obj isKindOfClass:[NSArray class]]) {
		[self stopLoading];
        return;
    }
	
	NSArray *ary = (NSArray*)obj;   
	int newMessageCounts = 0;
	for (int i = [ary count] - 1; i >= 0; --i) {
		NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
		if (![dic isKindOfClass:[NSDictionary class]]) {
			continue;
		}
		//long long dmId = [dic getLongLongValueValueForKey:@"id" defaultValue:-1];
		DirectMessage *dm = [DirectMessage directMessageWithJsonDictionary:dic];
		//NSLog(@"dm senderid:%lld recieverid:%lld conversationid:%lld", dm.senderId, dm.recipientId, dm.conversationId);
		[dm save];
		newMessageCounts++;
		User *currentUser = [WeiboEngine getCurrentUser];
		if (dm.recipientId != currentUser.userId) { // sent message
			if (lastSentDirectMessageId < dm.directMessageId) {
				lastSentDirectMessageId = dm.directMessageId;
			}
		}
		else {
			if (lastReceivedDirectMessageId < dm.directMessageId) {
				lastReceivedDirectMessageId = dm.directMessageId;
			}
		}

		
		@synchronized(conversationsLockObject) { // lock it
			Conversation *conversation = [conversationsDic objectForKey:dm.conversationKey];
			if (!conversation) {
				conversation = [[Conversation alloc] init];
				conversation.conversationId = dm.conversationId;
				[conversations addObject:conversation];
				[conversationsDic setObject:conversation forKey:conversation.conversationKey];
				[conversation release];
				conversation.user = dm.recipientId == currentUser.userId ? dm.sender : dm.recipient;			
			}
			if (dm.createdAt > conversation.mostRecentDate) {
				if (dm.recipientId != currentUser.userId) {
					conversation.hasReplied = YES;
				}
				else {
					conversation.hasReplied = NO;
				}

				if (dm.senderId != currentUser.userId 
					&& conversation.unread == NO && firstLoad == NO) { // first time load, no unread
					unreadMessagesCount++;
					conversation.unread = YES;
				}
				conversation.mostRecentDate = dm.createdAt;
				conversation.mostRecentMessage = dm.text;
				conversation.mostRecentDirectMessageId = dm.directMessageId;
			}
		}
	}
	
	firstLoad == YES;
	
	if (newMessageCounts > 0) {
		@synchronized(conversationsLockObject) { // lock it
			NSArray *sortedConversations = [conversations sortedArrayUsingSelector:@selector(compare:)];
			[conversations release];
			conversations = [[NSMutableArray arrayWithArray:sortedConversations] retain];
		}
		
		if (directMessageDataSourceDelegate) {
			[directMessageDataSourceDelegate unreadMessagesCountChanged:unreadMessagesCount];
			[directMessageDataSourceDelegate reloadConversation];
		}
	}
		
	
	[self stopLoading];
	[tableView reloadData];
	for (UITableViewCell *cell in [tableView visibleCells]) {
		[cell setNeedsDisplay];
	}
}


- (void)saveConversationsToLocal {
	NSString *filePath = [WeiboEngine getCurrentUserStoreagePath:@"conversations.db"];
	[NSKeyedArchiver archiveRootObject:conversations toFile:filePath];
	firstLoad = NO;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return conversations.count;
}


- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 61;
}

- (UITableViewCell *)getConversationTableViewCell:(UITableView *)_tableView 
										   conversation:(Conversation*)conversation {
	return nil;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView 
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	Conversation *conversation = [conversations objectAtIndex:indexPath.row];
	if (conversation) {
		return [self getConversationTableViewCell:_tableView conversation:conversation];
	}
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    return cell;
	
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Conversation *conversation = [conversations objectAtIndex:indexPath.row];
	if (conversation) {
		if (directMessageDataSourceDelegate) {
			[directMessageDataSourceDelegate conversationSelected:conversation];
		}
		if (conversation.unread == YES) {
			conversation.unread = NO;
			unreadMessagesCount--;
			if (directMessageDataSourceDelegate) {
				[directMessageDataSourceDelegate unreadMessagesCountChanged:unreadMessagesCount];
			}			
			UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
			if (cell) {
				[cell setNeedsDisplay];
			}
		}		
	}
}

#pragma mark -
#pragma mark DirectMessage Send

- (void)sendDirectMessage:(DirectMessageDraft*)_draft {
	WeiboClient *sendMessageClient = [[WeiboClient alloc] initWithTarget:self action:@selector(sendMessagesDidReceive:obj:)];
	sendMessageClient.context = [_draft retain];
	[sendMessageClient sendDirectMessage:_draft.text to:_draft.recipientId];
	_draft.directMessageDraftState = DirectMessageDraftStateSending;
	[_draft save];
	@synchronized(conversationsLockObject) {
		NSNumber *key = [NSNumber numberWithLongLong:(_draft.recipientId + _draft.senderId)];
		Conversation *conversation = [conversationsDic objectForKey:key];
		if (!conversation) {
			conversation = [[Conversation alloc] init];
			conversation.conversationId = [key longLongValue];
			[conversations addObject:conversation];
			[conversationsDic setObject:conversation forKey:conversation.conversationKey];
			[conversation release];
			User *user = [UserCache get:[NSNumber numberWithLongLong:_draft.recipientId]];
			if (!user) {
				user = [FriendCache getUserBYId:_draft.recipientId];
			}
			conversation.user = user;
		}
		if (_draft.createdAt > conversation.mostRecentDate) {
			conversation.hasReplied = YES;
			conversation.mostRecentDate = _draft.createdAt;
			conversation.mostRecentMessage = _draft.text;
		}
		NSArray *sortedConversations = [conversations sortedArrayUsingSelector:@selector(compare:)];
		[conversations release];
		conversations = [[NSMutableArray arrayWithArray:sortedConversations] retain];
	}
	[directMessageDataSourceDelegate reloadConversation];  
}

- (void)sendMessagesDidReceive:(WeiboClient*)sender obj:(NSObject*)obj {	
	DirectMessageDraft *_draft = (DirectMessageDraft*)sender.context;
	[sentMessagesClient release];
	sentMessagesClient = nil;
	if (sender.hasError) {
		NSLog(@"sendMessagesDidReceive error!!!, errorMessage:%@, errordetail:%@"
			  , sender.errorMessage, sender.errorDetail);
        [sender alert];
		_draft.directMessageDraftState = DirectMessageDraftStateFault;
		[_draft save];
		[directMessageDataSourceDelegate reloadConversation];
        return;
    }
	[_draft delete];
	[_draft release];
	NSArray *ary = [NSArray arrayWithObject:obj];
	/*
	NSDictionary *dic = [ary objectAtIndex:0];
	if ([dic isKindOfClass:[NSDictionary class]]) {
		long long maxId = [[dic objectForKey:@"id"] longLongValue];
		WeiboClient *_receivedMessagesClient = [[WeiboClient alloc] initWithTarget:self 
															  action:@selector(receivedMessagesDidReceive:obj:)];
		[_receivedMessagesClient getDirectMessagesSinceID:lastReceivedDirectMessageId 
											withMaximumID:maxId startingAtPage:0 count:50];
		
		WeiboClient *_sentMessagesClient = [[WeiboClient alloc] initWithTarget:self 
														  action:@selector(sentMessagesDidReceive:obj:)];
		[_sentMessagesClient getDirectMessagesSentSinceID:lastSentDirectMessageId
											withMaximumID:maxId startingAtPage:0 count:50];
	}
	 */
	[self loadRecentDirectMessages];
	[self directMessagesDidReceive:ary];

}

@end
