//
//  ConversationTableViewCell.h
//  ZhiWeibo
//
//  Created by junmin liu on 11-1-3.
//  Copyright 2011 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserABTableViewCell.h"
#import "Conversation.h"

@interface ConversationTableViewCell : UserABTableViewCell {
	Conversation *conversation;
}

@property (nonatomic, retain) Conversation *conversation;

@end
