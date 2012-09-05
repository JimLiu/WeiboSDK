//
//  EmoticonsView.m
//  ZhiWeibo
//
//  Created by junmin liu on 11-1-10.
//  Copyright 2011 Openlab. All rights reserved.
//

#import "EmoticonsView.h"


@implementation EmoticonsView
@synthesize emoticonNodes;
@synthesize perRowCount;


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)dealloc {
	[emoticonNodes release];
    [super dealloc];
}

- (void)setEmoticonNodes:(NSMutableArray *)_emoticonNodes {
	if (emoticonNodes != _emoticonNodes) {
		[emoticonNodes release];
		emoticonNodes = [_emoticonNodes retain];
		[self setNeedsDisplay];
	}
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    for (EmoticonNode *node in emoticonNodes) {
		[node draw];
	}
}


- (void)setFrame:(CGRect)_frame {
	[super setFrame:_frame];
	if (_frame.size.width == 320) {
		perRowCount = 7;
	}
	else {
		perRowCount = 10;
	}
	
	int size = 45;
	for (int i=0; i<emoticonNodes.count; i++) {
		EmoticonNode *node = [emoticonNodes objectAtIndex:i];
		node.view = self;
		int x = i % perRowCount * size;
		int y = i / perRowCount * size;
		node.bounds = CGRectMake(x, y, size, size);
	}
	
}


- (EmoticonNode*)hitTest:(CGPoint)point {
	for (EmoticonNode *node in emoticonNodes) {
		if (CGRectContainsPoint(node.bounds, point)) {
			return node;		
		}
	}
	return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHighlightedNode:(EmoticonNode*)node {
	if (node != _highlightedNode) {
		if (_highlightedNode) {
			_highlightedNode.isHighlighted = NO;
			[self setNeedsDisplayInRect:_highlightedNode.bounds];
		}
		[_highlightedNode release];
		_highlightedNode = nil;
		if (node) {
			_highlightedNode = [node retain];
			_highlightedNode.isHighlighted = YES;
		} 
		
		[self setNeedsDisplayInRect:_highlightedNode.bounds];

		[[NSNotificationCenter defaultCenter] postNotificationName:@"EmoticonDidHighlighted" 
															object:node];
		
		if ([node isKindOfClass:[EmojiNode class]]) {
			EmojiNode *emojiNode = (EmojiNode *)node;
			[EmojiDataSource addRecentEmojiNodes:emojiNode];
		}
		else if ([node isKindOfClass:[GifEmoticonNode class]]) {
			GifEmoticonNode *gifEmoticonNode = (GifEmoticonNode *)node;
			[EmoticonDataSource addRecentEmoticonNodes:gifEmoticonNode];
		}

	}	
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {	
	[super touchesBegan:touches withEvent:event];
	UITouch* touch = [touches anyObject];
	CGPoint point = [touch locationInView:self];
	
	EmoticonNode* node = [self hitTest:point];
	if (node) {
		[self setHighlightedNode:node];
	}
	
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
	[super touchesMoved:touches withEvent:event];
	UITouch* touch = [touches anyObject];
	CGPoint point = [touch locationInView:self];
	
	EmoticonNode* node = [self hitTest:point];
	//if (node) {
		[self setHighlightedNode:node];
	//}
	UIScrollView *scrollView = (UIScrollView *)[self superview];
	if (scrollView) {
		scrollView.scrollEnabled = NO;
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
	[super touchesEnded:touches withEvent:event];
	if (_highlightedNode) {
		[self setHighlightedNode:nil];
	}
	
	UITouch* touch = [touches anyObject];
	CGPoint point = [touch locationInView:self];
	EmoticonNode* node = [self hitTest:point];
	if (node) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"EmoticonDidPicked" object:node.phrase];
	}
	if (_highlightedNode) {
		[self setHighlightedNode:nil];
	}
	
	UIScrollView *scrollView = (UIScrollView *)[self superview];
	if (scrollView) {
		scrollView.scrollEnabled = YES;
	}
}	

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesCancelled:touches withEvent:event];
	if (_highlightedNode) {
		[self setHighlightedNode:nil];
	}
	
	UIScrollView *scrollView = (UIScrollView *)[self superview];
	if (scrollView) {
		scrollView.scrollEnabled = YES;
	}
	
}


@end
