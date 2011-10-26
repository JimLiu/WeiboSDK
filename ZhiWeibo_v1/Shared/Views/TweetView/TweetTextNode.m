//
//  TweetTextNode.m
//  TweetViewDemo
//
//  Created by junmin liu on 10-10-13.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "TweetTextNode.h"
#import "TweetLayout.h"

@implementation TweetTextNode
@synthesize text;
@synthesize textColor;
@synthesize highlightedTextColor;
@synthesize font;

- (id)initWithText:(NSString *)_text layout:(TweetLayout*)_layout {
	if (self = [super initWithLayout:_layout]) {
		text = [_text copy];
		self.font = _layout.font;
	}
	return self;
}

+(TweetTextNode *)withText:(NSString *)_text layout:(TweetLayout*)_layout {
	return [[[TweetTextNode alloc] initWithText:_text layout:_layout] autorelease];
}

- (NSString *)html {
	return text;
}

- (void)dealloc {
	[text release];
	[textColor release];
	[highlightedTextColor release];
	[font release];
	[super dealloc];
}


@end
