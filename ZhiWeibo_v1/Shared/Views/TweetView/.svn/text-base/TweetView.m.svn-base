//
//  TweetView.m
//  TweetViewDemo
//
//  Created by junmin liu on 10-10-13.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "TweetView.h"

@interface TweetView (Private)

- (void)setHighlightedFrame:(TweetFrame*)frame;
- (TweetNode *)setSelectedFrame:(TweetFrame*)frame;
- (void)processLinkTouch:(NSString*)url;

@end


@implementation TweetView
@synthesize doc, animationInterval;
@synthesize statusViewDelegate;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		backgroundImage = [[[UIImage imageNamed:@"iPad-status-background.png"] 
							stretchableImageWithLeftCapWidth:0 topCapHeight:1] retain];
		animationInterval = 1.0 / 100.0;
		animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationInterval 
														  target:self selector:@selector(drawAnimationImages) 
														userInfo:nil repeats:YES];
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawAnimationImages {
	if (doc) {
		[doc performStep:1];
	}
}

- (void)dealloc {
	doc.view = nil;
	[doc release];
	statusViewDelegate = nil;
	[_highlightedNode release];
	[_highlightedFrame release];
	[backgroundImage release];
    [super dealloc];
}


- (void)reset {
	if (_highlightedNode) {
		_highlightedNode.state = TweetNodeStateNormal;
		[_highlightedNode release];
		_highlightedNode = nil;
		[_highlightedFrame release];
		_highlightedFrame = nil;
	}	
	if (_selectedNode) {
		_selectedNode.state = TweetNodeStateNormal;
		[_selectedNode release];
		_selectedNode = nil;
		[_selectedFrame release];
		_selectedFrame = nil;
	}
}

- (void)setDoc:(TweetDocument *)_doc {
	if (_doc != doc) {
		[doc release];
		doc = [_doc retain];
		doc.view = self;
	}
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {	 
    if (doc) {
		[doc drawAtPoint:CGPointZero];
	}
}

- (void)processLinkTouch:(NSString*)url {
	if (statusViewDelegate) {
		[statusViewDelegate processLinkTouch:url];
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {	
	[super touchesBegan:touches withEvent:event];
	UITouch* touch = [touches anyObject];
	CGPoint point = [touch locationInView:self];
	
	TweetFrame* frame = [doc hitTest:point];
	if (frame) {
		[self setHighlightedFrame:frame];
	}
	
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
	[super touchesMoved:touches withEvent:event];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
	UITouch* touch = [touches anyObject];
	CGPoint point = [touch locationInView:self];
	TweetFrame* frame = [doc hitTest:point];
	if (frame) {
		TweetNode *selectedNode = [self setSelectedFrame:frame];
		if (selectedNode) {
			if ([selectedNode isKindOfClass:[TweetLinkNode class]]) {
				TweetLinkNode *linkNode = (TweetLinkNode *)selectedNode;
				[self processLinkTouch:linkNode.url];
			}
			else if ([selectedNode isKindOfClass:[TweetImageLinkNode class]]) {
				TweetImageLinkNode *linkNode = (TweetImageLinkNode *)selectedNode;
				[self processLinkTouch:linkNode.url];
			}			
		}
	}
	else {
		[self setHighlightedFrame:nil];
	}
	
	
	// We definitely don't want to call this if the label is inside a TTTableView, because
	// it winds up calling touchesEnded on the table twice, triggering the link twice
	[super touchesEnded:touches withEvent:event];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event {
	[self setHighlightedFrame:nil];
	[super touchesCancelled:touches withEvent:event];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHighlightedFrame:(TweetFrame*)frame {
	if (frame && (frame == _highlightedFrame || frame.node == _selectedNode)) {
		return;
	}
	if (frame) {
		if ([frame.node isKindOfClass:[TweetLinkNode class]] 
			|| [frame.node isKindOfClass:[TweetImageLinkNode class]]) {
			[_highlightedFrame release];
			_highlightedFrame = [frame retain];
			_highlightedNode.state = TweetNodeStateNormal;
			[_highlightedNode release];
			_highlightedNode = [frame.node retain];
			_highlightedNode.state = TweetNodeStateHighlighted;
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

///////////////////////////////////////////////////////////////////////////////////////////////////
- (TweetNode *)setSelectedFrame:(TweetFrame*)frame {
	[self setNeedsDisplay];
	if (frame == _selectedFrame || !_highlightedNode 
		|| frame.node != _highlightedNode) {
		[self setHighlightedFrame:nil];
		return nil;
	}	
	[self setHighlightedFrame:nil];
	if (frame) {
		if ([frame.node isKindOfClass:[TweetLinkNode class]] 
			|| [frame.node isKindOfClass:[TweetImageLinkNode class]]) {
			if (frame.node.selectable == YES) {
				[_selectedFrame release];
				_selectedFrame = [frame retain];
				_selectedNode.state = TweetNodeStateNormal;
				[_selectedNode release];
				_selectedNode = [frame.node retain];
				_selectedNode.state = TweetNodeStateSelected;
			}
			return frame.node;
		}
	} 
	else {
		if (_selectedNode) {
			_selectedNode.state = TweetNodeStateNormal;
			[_selectedNode release];
			_selectedNode = nil;
			[_selectedFrame release];
			_selectedFrame = nil;
		}
	}
	return nil;
	
}
@end
