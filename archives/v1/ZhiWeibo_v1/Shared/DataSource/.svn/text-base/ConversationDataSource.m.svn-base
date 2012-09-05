//
//  ConversationDataSource.m
//  ZhiWeibo
//
//  Created by junmin liu on 11-1-3.
//  Copyright 2011 Openlab. All rights reserved.
//

#import "ConversationDataSource.h"


@implementation ConversationDataSource
@synthesize tableView;
@synthesize conversation;
@synthesize conversationDataSourceDelegate;

- (id)initWithTableView:(UITableView *)_tableView {
	if (self = [super init]) {
		tableView = [_tableView retain];
		tableView.delegate = self;
		tableView.dataSource = self;
		
		messagesDic = [[NSMutableDictionary alloc]init];
		messageDocs = [[NSMutableDictionary alloc]init];

	}
	return self;
}

- (void)scrollToBottom {
	int pos = [tableView numberOfRowsInSection:0] - 1;
	if (pos > 0) {
		NSIndexPath *path = [NSIndexPath indexPathForRow: pos inSection:0];
		[tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:false];
	}
}

- (void)setTableView:(UITableView *)_tableView {
	if (tableView != _tableView) {
		[tableView release];
		tableView = [_tableView retain];
		tableView.dataSource = self;
		tableView.delegate = self;
		[tableView reloadData];
		[self scrollToBottom];
	}
}

- (void)setConversation:(Conversation *)_conversation {
	if (conversation != _conversation) {
		[conversation release];
		conversation = [_conversation retain];
		[self reset];
		//[self scrollToBottom];
	}
}

- (void)dealloc {
	[tableView release];
	[conversation release];
	[messagesDic release];
	[messageFiles release];
	[messageDocs release];
	[super dealloc];
}

- (void)resendDraft:(DirectMessageDraft *)_draft {
	[conversationDataSourceDelegate resendDraft:_draft];
}

- (void)reset {
	[messagesDic removeAllObjects];
	[messageFiles removeAllObjects];
	[messageDocs removeAllObjects];
	[self reloadMessages];
	[self scrollToBottom];
}

- (void)reloadMessages {
	NSString *filePath = [WeiboEngine getCurrentUserStoreagePath:
						  [NSString stringWithFormat:@"conversations/%lld", conversation.conversationId]];
	[PathHelper createPathIfNecessary:filePath];
	NSFileManager* fm = [NSFileManager defaultManager];
	NSDirectoryEnumerator* e = [fm enumeratorAtPath:filePath];
	NSMutableArray *filenames = [NSMutableArray array];
	for (NSString* filename; filename = [e nextObject]; ) {
		if (![filename hasSuffix:@".db"] 
			&& ![filename hasSuffix:@".plist"])
			continue;		
		NSString* path = [filePath stringByAppendingPathComponent:filename];
		[filenames addObject:path];
	}
	[messageFiles release];
	messageFiles = [filenames retain];
	[tableView reloadData];
}

- (TweetDocument *)getTweetDocumentWithDraft:(DirectMessageDraft *)message width:(CGFloat)width {
	NSString *key = [NSString stringWithFormat:@"messageDoc-D:lld%-w:f%", message.draftId, width];
	TweetDocument *doc = [messageDocs objectForKey:key];
	if (!doc) {
		doc = [[[TweetDocument alloc] init] autorelease];
		TweetLayout *statusLayout = [doc addLayoutForStatus:message.text
													 frame:CGRectMake(0, 0, width, 1)];
		statusLayout.font = [UIFont systemFontOfSize:15];
	}
	return doc;
}

- (TweetDocument *)getTweetDocument:(DirectMessage *)message width:(CGFloat)width {
	NSString *key = [NSString stringWithFormat:@"messageDoc-MI:lld%-w:f%", message.directMessageId, width];
	TweetDocument *doc = [messageDocs objectForKey:key];
	if (!doc) {
		doc = [[[TweetDocument alloc] init] autorelease];
		TweetLayout *statusLayout = [doc addLayoutForStatus:message.text
														  frame:CGRectMake(0, 0, width, 1)];
		statusLayout.font = [UIFont systemFontOfSize:15];
	}
	return doc;
}

- (DirectMessage *)getDirectMessage:(int)index {
	NSString *filename = [messageFiles objectAtIndex:index];
	if (filename) {
		DirectMessage *message = [messageDocs objectForKey:filename];
		if (!message) {
			message = (DirectMessage*)[NSKeyedUnarchiver unarchiveObjectWithFile:filename];
			if (message) {
				[messageDocs setObject:message forKey:filename];
			}
		}
		return message;
	}
	return nil;
}

- (DirectMessageDraft *)getDirectMessageDraft:(int)index {
	NSString *filename = [messageFiles objectAtIndex:index];
	DirectMessageDraft *draft = [messageDocs objectForKey:filename];
	if (!draft) {
		draft = (DirectMessageDraft*)[NSKeyedUnarchiver unarchiveObjectWithFile:filename];
		if (draft) {
			[messageDocs setObject:draft forKey:filename];
		}
	}
	return draft;
}

- (CGFloat)getMessageWidth:(DirectMessage *)message {
	return tableView.frame.size.width - 80 - 16 - 20;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return messageFiles.count;
}


- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *filename = [messageFiles objectAtIndex:indexPath.row];
	CGFloat width = [self getMessageWidth:nil];
	TweetDocument *doc;
	if ([filename hasSuffix:@".draft.db"]) {
		DirectMessageDraft *draft = [self getDirectMessageDraft:indexPath.row];
		doc = [self getTweetDocumentWithDraft:draft width:width];
	}
	else {
		DirectMessage *directMessage = [self getDirectMessage:indexPath.row];
		doc = [self getTweetDocument:directMessage width:width];
	}
	CGFloat height = doc.height + 20 + 5 + 8 * 2;
	if (height < 65) {
		height = 65;
	}
	return height;
}


- (UITableViewCell *)tableView:(UITableView *)_tableView 
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSString *filename = [messageFiles objectAtIndex:indexPath.row];
	if ([filename hasSuffix:@".draft.db"]) {
		DirectMessageDraft *draft = [self getDirectMessageDraft:indexPath.row];
		
		static NSString *CellIdentifier = @"MessageDraftCell"; 
		MessageDraftViewCell *cell = (MessageDraftViewCell*)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[MessageDraftViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		[cell setDraft:draft];
		cell.messageTableViewCellDelegate = self;
		cell.messageDraftViewCellDelegate = self;
		return cell;
	}
 	DirectMessage *directMessage = [self getDirectMessage:indexPath.row];
	
	static NSString *CellIdentifier = @"MessageCell";
	
    MessageTableViewCell *cell = (MessageTableViewCell*)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	cell.messageTableViewCellDelegate = self;
    cell.directMessage = directMessage;
    return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[conversationDataSourceDelegate hideKeyboard];
}

- (void)processTweetNode:(TweetNode *)node {
	[conversationDataSourceDelegate processTweetNode:node];
}


@end
