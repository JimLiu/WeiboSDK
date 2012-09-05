//
//  TweetImageLinkFrame.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-3.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "TweetImageLinkFrame.h"

static UIImage *bubbleBlue = nil;
static UIImage *bubbleGray = nil;

@implementation TweetImageLinkFrame
@synthesize linkNode;

- (id)initWithNode:(TweetImageLinkNode *)_node frame:(CGRect)_frame {
	if (self = [super initWithNode:_node frame:_frame]) {
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

- (void)draw {
	CGRect rect = [self drawFrame];
	UIImage* image = [self downloadImage];//
	if (!image) {
		image = imageNode.defaultImage;
	}
	else {
		[self sizeFit:image];
		//rect = self.frame;
	}
	borderFrame = CGRectMake(rect.origin.x - 6, rect.origin.y - 6,  rect.size.width + 12, rect.size.height + 12);
	
	if (linkNode.state == TweetNodeStateSelected) {
		[self drawBlueBubbleImage];
	}
	else if(linkNode.state == TweetNodeStateHighlighted) {
		//[self drawGrayBubbleImage];
		[self drawBlueBubbleImage];
	}
	
	if (image) {
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		CGContextSaveGState(ctx);
		CGContextAddRect(ctx, rect);
		CGContextClip(ctx);
		[image drawInRect:rect];
		CGContextRestoreGState(ctx);
	}
}

- (void)dealloc {
	[super dealloc];
}

@end
