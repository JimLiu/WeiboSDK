//
//  TweetFrame.m
//  TweetViewDemo
//
//  Created by junmin liu on 10-10-13.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "TweetTextFrame.h"

@implementation TweetTextFrame
@synthesize text, textNode;


- (id)initWithText:(NSString *)_text 
			  node:(TweetTextNode *)_node 
			frame:(CGRect)_frame {
	if (self = [super initWithNode:_node frame:_frame]) {
		text = [_text copy];
		textNode = _node;
	}
	return self;
}

- (void)draw {

	UIColor *_textColor;
	if (textNode.highlighted) {
		if (!textNode.highlightedTextColor) {
			_textColor = [UIColor whiteColor];
		}
		else {
			_textColor = textNode.highlightedTextColor;
		}
	}
	else {
		if (!textNode.textColor) {
			_textColor = [UIColor blackColor];
		}
		else {
			_textColor = textNode.textColor;
		}
	}
	UIFont *_font = textNode.font ? textNode.font : [UIFont fontWithName:@"Helvetica" size:17];

	[_textColor setFill];		
	[text drawInRect:frame withFont:_font lineBreakMode:UILineBreakModeClip];
}

- (void)dealloc {
	[text release];
	[super dealloc];
}

@end
