//
//  MessageDraftViewCell.h
//  ZhiWeibo
//
//  Created by Zhang Jason on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageTableViewCell.h"
#import "DirectMessageDraft.h"

@protocol MessageDraftViewCellDelegate

- (void)resendDraft:(DirectMessageDraft*)_draft;

@end


@interface MessageDraftViewCell : MessageTableViewCell {
	DirectMessageDraft *draft;
	id<MessageDraftViewCellDelegate> messageDraftViewCellDelegate;
	UIButton *btn;
}

@property (nonatomic, assign)  id<MessageDraftViewCellDelegate> messageDraftViewCellDelegate;

- (void) setDraft:(DirectMessageDraft *)_draft;

@end
