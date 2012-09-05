//
//  TweetNode.m
//  TweetViewDemo
//
//  Created by junmin liu on 10-10-13.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "TweetNode.h"
#import "TweetLayout.h"

@implementation TweetNode
@synthesize layout;
@synthesize nextSibling;
@synthesize margin		  = _margin;
@synthesize className	  = _className;
@synthesize state;
@synthesize highlighted;
@synthesize hideOnHighlighted;
@synthesize verticalAlign;
@synthesize selectable;

- (id)initWithLayout:(TweetLayout*)_layout {
	if (self = [super init]) {
		layout = _layout;
		verticalAlign = layout.verticalAlign;
		_className = nil;
		highlighted = _layout.highlighted;
		selectable = YES;
	}
	return self;
}

- (NSArray *)frames {

	NSMutableArray *arr = [NSMutableArray array];
	for (TweetFrame *frame in layout.frames) {
		if (frame.node == self) {
			[arr addObject:frame];
		}
	}
	return arr;
	
}

- (void)setNeedsDisplay {
	for (TweetFrame *frame in layout.frames) {
		if (frame.node == self) {
			[layout setNeedsDisplayInRect:frame.frame];
		}
	}
}

- (NSString *)html {
	return nil;
}

- (void)dealloc {
	[_className release];
	[super dealloc];
}

@end
