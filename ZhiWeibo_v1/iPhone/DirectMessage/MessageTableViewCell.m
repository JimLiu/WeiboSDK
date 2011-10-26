//
//  MessageTableViewCell.m
//  ZhiWeibo
//
//  Created by junmin liu on 11-1-3.
//  Copyright 2011 Openlab. All rights reserved.
//

#import "MessageTableViewCell.h"

static UIImage *bubbleImageLeft;
static UIImage *bubbleImageRight;


@implementation MessageTableViewCell
@synthesize directMessage;
@synthesize messageTableViewCellDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style 
	reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleSubtitle 
					 reuseIdentifier:reuseIdentifier])) {
		if (!bubbleImageLeft) {
			bubbleImageLeft = [[[UIImage imageNamed:@"sms-left.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:15]retain];
		}
		if (!bubbleImageRight) {
			bubbleImageRight = [[[UIImage imageNamed:@"sms-right.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:15]retain];
		}
		/*
		UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showCopyMenu:)];
		//longPressGesture.delegate = self;
		[self addGestureRecognizer:longPressGesture];
		[longPressGesture release];
		*/
	}
	return self;
}


- (void)setDirectMessage:(DirectMessage *)_message {
	if (directMessage != _message) {
		[directMessage release];
		directMessage = [_message retain];
		self.user = directMessage.sender;
		[tweetDoc release];
		tweetDoc = nil;
		
		[tweetDoc release];
		tweetDoc = [[TweetDocument alloc]init];
		CGFloat width = self.frame.size.width - 80 - 16 - 20; // padding-left:66;padding-right:14;margin:8;draft state:20;
		TweetLayout *statusLayout = [tweetDoc addLayoutForStatus:directMessage.text
													frame:CGRectMake(0, 0, width, 1)];
		statusLayout.linkFont = [UIFont boldSystemFontOfSize:15];
		statusLayout.linkTextColor = [UIColor colorWithRed:0x23/255.0F green:0x6E/255.0F blue:0xD8/255.0F alpha:1];
		statusLayout.font = [UIFont systemFontOfSize:15];
		CGFloat actualWidth = statusLayout.actualWidth + 6;
		if (actualWidth < 40) {
			actualWidth = 40;
		}
		else if (width - actualWidth < 10) {
			actualWidth = width;
		}
		
		if (directMessage.sender.userId == [WeiboEngine getCurrentUser].userId) {
			profileImageRect = CGRectMake(self.frame.size.width - 52 - 6, 6, 52, 52);
			bubbleImage = bubbleImageRight;
			bubbleImageRect = CGRectMake(self.frame.size.width - 66 - 8 * 2 - actualWidth, 
										 20, 8 * 2 + actualWidth + 6, 
										 statusLayout.frame.size.height + 8 * 2);
			textLocation = CGPointMake(self.frame.size.width - 66 - 8 - actualWidth, 20 + 8);
		}
		else {
			profileImageRect = CGRectMake(6, 6, 52, 52);
			bubbleImage = bubbleImageLeft;
			bubbleImageRect = CGRectMake(60, 20, 8 * 2 + actualWidth, statusLayout.frame.size.height + 8 * 2);
			textLocation = CGPointMake(66 + 8, 20 + 8);
		}
	}
}

- (void)dealloc {
	[directMessage release];
	[tweetDoc release];
	bubbleImage = nil;
	[super dealloc];
}

- (void)drawContentView:(CGRect)rect highlighted:(BOOL)highlighted {
	//e2e7ed
	UIColor *backgroundColor = [UIColor colorWithRed:0xE2/255.F green:0xE7/255.F blue:0xED/255.f alpha:1.0];
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextClearRect(context, rect);
	[backgroundColor set];
	CGContextFillRect(context, rect);

	[super drawContentView:rect highlighted:highlighted];
	[bubbleImage drawInRect:bubbleImageRect];
	[tweetDoc drawAtPoint:textLocation];
	
	static UIFont *timestampFont;
	if (!timestampFont) {
		timestampFont = [[UIFont boldSystemFontOfSize:12] retain];
	}
	UIColor* timestampColor;
	//if (highlighted) {
	//	timestampColor  = [UIColor whiteColor];
	//}
	//else {
		timestampColor  = [UIColor colorWithRed:0x99/255.0F green:0xa1/255.0F blue:0xa8/255.0F alpha:1];
	//}
	CGRect timestampRect = CGRectMake(0, 4, self.frame.size.width, 14);
	[timestampColor set];
	[[directMessage timeString] drawInRect:timestampRect
										   withFont:timestampFont
									  lineBreakMode:UILineBreakModeWordWrap 
										  alignment:UITextAlignmentCenter];
	
}
- (void)setSelected:(BOOL)selected {
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
}

- (void)setHighlighted:(BOOL)highlighted {
	
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
	
}

- (void)processNodeTouch:(TweetNode*)_node {
	if ([_node isKindOfClass:[TweetLinkNode class]]) {
		TweetLinkNode *linkNode = (TweetLinkNode *)_node;
		[messageTableViewCellDelegate processTweetNode:linkNode];
	}
}

- (void)showMenu {
	[self becomeFirstResponder];
	UIMenuController *menuCont = [UIMenuController sharedMenuController];
	[menuCont setTargetRect:CGRectMake(bubbleImageRect.origin.x, self.frame.origin.y + 25, bubbleImageRect.size.width, self.frame.size.height) inView:self.superview];
	menuCont.arrowDirection = UIMenuControllerArrowDown;
	[menuCont setMenuVisible:YES animated:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	//NSLog(@"%e , %e",[[NSProcessInfo processInfo] systemUptime],[[touches anyObject] timestamp]);
	
	[self becomeFirstResponder];
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self];
	if(CGRectContainsPoint(profileImageRect, point)){
		TweetLinkNode *node = [[[TweetLinkNode alloc] init] autorelease];
		node.url = [NSString stringWithFormat:@"@%@",directMessage.sender.screenName];
		[self processNodeTouch:node];
	}
	else {
		TweetFrame* frame = [tweetDoc hitTest:CGPointMake(point.x - textLocation.x, point.y - textLocation.y)];
		if ([frame.node isKindOfClass:[TweetLinkNode class]]) {
			if ([[NSProcessInfo processInfo] systemUptime] - [[touches anyObject] timestamp] > 0.5) {
				if(CGRectContainsPoint(bubbleImageRect,point)) {
					[self showMenu];
				}
			}
			else {
				[self processNodeTouch:frame.node];
			}
		}
		else {
			if(CGRectContainsPoint(bubbleImageRect,point)) {
				[self showMenu];
			}
		}

		/*
		else if ([[NSProcessInfo processInfo] systemUptime] - [[touches anyObject] timestamp] > 0.5) {
			if(CGRectContainsPoint(bubbleImageRect,point)) {
				[self becomeFirstResponder];
				UIMenuController *menuCont = [UIMenuController sharedMenuController];
				[menuCont setTargetRect:CGRectMake(self.frame.origin.x, self.frame.origin.y + 25, self.frame.size.width, self.frame.size.height) inView:self.superview];
				menuCont.arrowDirection = UIMenuControllerArrowDown;
				[menuCont setMenuVisible:YES animated:YES];
			}
		}
		 */
	}
	[super touchesEnded:touches withEvent:event];
}
/*
- (void)showCopyMenu:(UILongPressGestureRecognizer *)gestureRecognizer {
	CGPoint point = [gestureRecognizer locationInView:self];
	NSLog(@"%@",gestureRecognizer);
	if(CGRectContainsPoint(bubbleImageRect,point)) {
		[self becomeFirstResponder];
		UIMenuController *menuCont = [UIMenuController sharedMenuController];
		[menuCont setTargetRect:CGRectMake(self.frame.origin.x, self.frame.origin.y + 25, self.frame.size.width, self.frame.size.height) inView:self.superview];
		menuCont.arrowDirection = UIMenuControllerArrowDown;
		[menuCont setMenuVisible:YES animated:YES];
	}
}
 */

- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
	if (action == @selector(copy:)) {
		return YES;
	}
	return NO;
}

- (void)copy:(id)sender {
	UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
	pasteBoard.string = directMessage.text;
}

@end
