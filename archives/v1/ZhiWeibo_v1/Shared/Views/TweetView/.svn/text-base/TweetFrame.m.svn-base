//
//  TweetFrame.m
//  TweetViewDemo
//
//  Created by junmin liu on 10-10-14.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "TweetFrame.h"


@implementation TweetFrame
@synthesize node, frame, borderFrame;

- (id)initWithNode:(TweetNode *)_node frame:(CGRect)_frame {
	if (self = [super init]) {
		node = [_node retain];
		frame = _frame;
	}
	return self;
}

- (void)draw {
}

- (CGRect)drawFrame {
	return CGRectMake(frame.origin.x + node.margin.left
					  , frame.origin.y + node.margin.top
					  , frame.size.width - node.margin.left - node.margin.right
					  , frame.size.height - node.margin.top - node.margin.bottom);
}

- (CGRect)borderFrame {
	if (borderFrame.origin.x == 0 && borderFrame.origin.y == 0 
		&& borderFrame.size.width == 0 && borderFrame.size.height == 0) {
		return self.drawFrame;
	}
	return borderFrame;
}

- (void)dealloc {
	[node release];
	[super dealloc];
}
@end
