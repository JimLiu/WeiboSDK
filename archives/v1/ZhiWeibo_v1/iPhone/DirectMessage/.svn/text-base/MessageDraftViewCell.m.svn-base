//
//  MessageDraftViewCell.m
//  ZhiWeibo
//
//  Created by Zhang Jason on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MessageDraftViewCell.h"
#import "WeiboEngine.h"

@implementation MessageDraftViewCell

@synthesize messageDraftViewCellDelegate;

/*
- (void)setHighlighted:(BOOL)highlighted {
	btn.selected = NO;
	btn.highlighted = NO;
}

- (void)setSelected:(BOOL)selected {
	btn.selected = NO;
	btn.highlighted = NO;
}
 */

- (void) setDraft:(DirectMessageDraft *)_draft {
	if (draft == _draft) {
		return;
	}
	[draft release];
	draft = [_draft retain];
	DirectMessage *message = [[DirectMessage alloc] init];
	message.senderId = draft.senderId;
	message.recipientId = draft.recipientId;
	message.sender = [WeiboEngine getCurrentUser];
	message.text = draft.text;
	message.createdAt = draft.createdAt;
	message.directMessageId = draft.draftId;
	[self setDirectMessage:message];
	[message release];
	[btn removeFromSuperview];
	btn = [UIButton buttonWithType:UIButtonTypeCustom];
	btn.frame = CGRectMake(bubbleImageRect.origin.x - 30, bubbleImageRect.origin.y, 24, 24);
	switch (draft.directMessageDraftState) {
		case DirectMessageDraftStateSending:
		{
			[btn setImage:[UIImage imageNamed:@"conversation_sending.png"] forState:UIControlStateNormal];
			//[btn setImage:[UIImage imageNamed:@"conversation_sending.png"] forState:UIControlStateHighlighted];
			break;
		}
		case DirectMessageDraftStateFault:
		{
			[btn setImage:[UIImage imageNamed:@"conversation_fault.png"] forState:UIControlStateNormal];
			//[btn setImage:[UIImage imageNamed:@"conversation_fault.png"] forState:UIControlStateHighlighted];
			[btn addTarget:self action:@selector(resend:) forControlEvents:UIControlEventTouchUpInside];
			break;
		}
		case DirectMessageDraftStateSent:
		{
			[btn setImage:[UIImage imageNamed:@"conversation_sent.png"] forState:UIControlStateNormal];
			//[btn setImage:[UIImage imageNamed:@"conversation_sent.png"] forState:UIControlStateHighlighted];
			break;
		}
		default:
			break;
	}
	[self addSubview:btn];
}

- (void)dealloc {
	[draft release];
	[super dealloc];
}
/*
- (void)drawContentView:(CGRect)rect highlighted:(BOOL)highlighted {
	[super drawContentView:rect highlighted:highlighted];
	UIImage *_image;
	if (draft.directMessageDraftState == DirectMessageDraftStateSending) {
		//NSLog(@"%@",[[NSBundle mainBundle] pathForResource:@"images/Conversation_Sending.png" ofType:nil]);
		//_image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"images/Conversation_Sending.png" ofType:nil]];
		_image = [UIImage imageNamed:@"conversation_sending.png"];
	}
	else if(draft.directMessageDraftState == DirectMessageDraftStateSent) {
		_image = [UIImage imageNamed:@"conversation_sent.png"];
	}
	else if(draft.directMessageDraftState == DirectMessageDraftStateFault) {
		_image = [UIImage imageNamed:@"conversation_fault.png"];
	}
	[_image drawInRect:CGRectMake(bubbleImageRect.origin.x - 30, bubbleImageRect.origin.y, 24, 24)];
}
 */
/*
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self becomeFirstResponder];
	UIMenuItem *menuItem = [[UIMenuItem alloc] initWithTitle:@"重发" action:@selector(resend:)];
	UIMenuController *menuCont = [UIMenuController sharedMenuController];
	[menuCont setTargetRect:CGRectMake(self.frame.origin.x, self.frame.origin.y + 25, self.frame.size.width, self.frame.size.height) inView:self.superview];
	menuCont.arrowDirection = UIMenuControllerArrowDown;
	menuCont.menuItems = [NSArray arrayWithObject:menuItem];
	[menuCont setMenuVisible:YES animated:YES];
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
	if (action == @selector(resend:)) {
		return YES;
	}
	return NO;
}
*/

- (void)resend:(id)obj {
	[messageDraftViewCellDelegate resendDraft:draft];
}

@end
