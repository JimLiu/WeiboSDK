//
//  MessageTableViewCell.h
//  ZhiWeibo
//
//  Created by junmin liu on 11-1-3.
//  Copyright 2011 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserABTableViewCell.h"
#import "DirectMessage.h"
#import "TweetDocument.h"
#import "WeiboEngine.h"

@protocol MessageTableViewCellDelegate

-(void)processTweetNode:(TweetNode*)node;

@end


@interface MessageTableViewCell : UserABTableViewCell {
	DirectMessage *directMessage;
	TweetDocument *tweetDoc;
	UIImage *bubbleImage;
	
	CGRect bubbleImageRect;
	CGPoint textLocation;
	
	id<MessageTableViewCellDelegate> messageTableViewCellDelegate;
}

@property (nonatomic, retain) DirectMessage *directMessage;
@property (nonatomic, assign) id<MessageTableViewCellDelegate> messageTableViewCellDelegate;

@end
