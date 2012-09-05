//
//  TweetCellView.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-10-16.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "TweetCellView.h"

@interface TweetCellView (Private)

- (void)setHighlightedFrame:(TweetFrame*)frame;

@end

@implementation TweetCellView
@synthesize doc, animationInterval;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		animationInterval = 1.0 / 100.0;
		animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationInterval 
															   target:self selector:@selector(drawAnimationImages) 
															 userInfo:nil repeats:YES];
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
    }
    return self;
}

- (void)drawAnimationImages {
	if (doc) {
		[doc performStep:1];
	}
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    if (doc) {
		[doc drawAtPoint:CGPointZero];
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
	UITouch* touch = [touches anyObject];
	CGPoint point = [touch locationInView:self];
	
	TweetFrame* frame = [doc hitTest:point];
	if (frame) {
		//[self setHighlightedFrame:frame];
	}
	
	[super touchesBegan:touches withEvent:event];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
	[super touchesMoved:touches withEvent:event];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
	if (_highlightedNode) {
		//[self setHighlightedFrame:nil];
	}
	
	// We definitely don't want to call this if the label is inside a TTTableView, because
	// it winds up calling touchesEnded on the table twice, triggering the link twice
	[super touchesEnded:touches withEvent:event];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event {
	[super touchesCancelled:touches withEvent:event];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHighlightedFrame:(TweetFrame*)frame {
	if (frame != _highlightedFrame) {
		if (frame) {
			if ([frame.node isKindOfClass:[TweetLinkNode class]]) {
				TweetLinkNode *linkNode = (TweetLinkNode *)frame.node;
				linkNode.state = TweetNodeStateSelected;
				[_highlightedFrame release];
				_highlightedFrame = [frame retain];
				if (_highlightedNode) 
					_highlightedNode.state = TweetNodeStateNormal;
				[_highlightedNode release];
				_highlightedNode = [linkNode retain];
			}
		} 
		else {
			if (_highlightedNode) {
				_highlightedNode.state = TweetNodeStateNormal;
				[_highlightedNode release];
				_highlightedNode = nil;
				[_highlightedFrame release];
				_highlightedFrame = nil;
			}
		}
		
		[self setNeedsDisplay];
		
	}	
}

- (void)dealloc {
	animationTimer = nil;
	doc.view = nil;
	[doc release];
	[_highlightedNode release];
	[_highlightedFrame release];
    [super dealloc];
}



@end
