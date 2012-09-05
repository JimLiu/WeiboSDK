//
//  TweetLinkFrame.m
//  TweetViewDemo
//
//  Created by junmin liu on 10-10-14.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "TweetLinkFrame.h"

static UIImage *bubbleBlue = nil;
static UIImage *bubbleGray = nil;
static UIFont *defaultFont = nil;

@implementation TweetLinkFrame
@synthesize linkNode;

- (id)initWithText:(NSString *)_text node:(TweetLinkNode *)_node frame:(CGRect)_frame {
	if (self = [super initWithText:_text node:_node frame:_frame]) {
		linkNode = _node;
		borderFrame = CGRectMake(_frame.origin.x - 6, _frame.origin.y - 6,  _frame.size.width + 12, _frame.size.height + 12);
	}
	return self;
}


- (void)drawGrayBubbleImage {
	if (!bubbleGray) {
		bubbleGray = [[[UIImage imageNamed:@"iPad-selection-bubble.png"]
					   stretchableImageWithLeftCapWidth:8 topCapHeight:8] retain];
	}
	[bubbleGray drawInRect:borderFrame];
}

- (void)drawBlueBubbleImage {
	
	if (!bubbleBlue) {
		bubbleBlue = [[[UIImage imageNamed:@"iPad-blue-selection-bubble.png"]
					   stretchableImageWithLeftCapWidth:8 topCapHeight:8] retain];
	}
	[bubbleBlue drawInRect:borderFrame];
}

- (void)setFrame:(CGRect)_frame {
	frame = _frame;
	borderFrame = CGRectMake(_frame.origin.x - 6, _frame.origin.y - 6,  _frame.size.width + 12, _frame.size.height + 12);
}

- (void)draw {
	if (!defaultFont) {
		defaultFont = [[UIFont fontWithName:@"Helvetica" size:17] retain];
	}
	UIFont *_font = textNode.font ? textNode.font : defaultFont;
	if (linkNode.state == TweetNodeStateSelected) {
		[self drawBlueBubbleImage];
		[textNode.highlightedTextColor setFill];		
		[text drawInRect:frame withFont:_font lineBreakMode:UILineBreakModeClip];
	}
	else if (linkNode.state == TweetNodeStateHighlighted) {
		//[self drawGrayBubbleImage];
		[self drawBlueBubbleImage];
		[textNode.highlightedTextColor setFill];		
		[text drawInRect:frame withFont:_font lineBreakMode:UILineBreakModeClip];
	}
	else {
		[super draw];
	}	
}

- (void)dealloc {
	[super dealloc];
}

@end
