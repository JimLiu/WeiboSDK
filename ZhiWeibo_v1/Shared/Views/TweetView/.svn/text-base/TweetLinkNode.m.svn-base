//
//  TweetLinkNode.m
//  TweetViewDemo
//
//  Created by junmin liu on 10-10-13.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "TweetLinkNode.h"
#import "TweetLayout.h"


@implementation TweetLinkNode
@synthesize url;

- (id)initWithUrl:(NSString *)_url text:(NSString *)_text layout:(TweetLayout*)_layout {
	if (self = [super initWithText:_text layout:_layout]) {
		url = [_url copy];
		self.font = _layout.linkFont;
	}
	return self;
}

+ (TweetLinkNode *)withUrl:(NSString *)_url layout:(TweetLayout*)_layout {
	return [[[TweetLinkNode alloc] initWithUrl:_url text:_url layout:_layout] autorelease];
}

+ (TweetLinkNode *)withUrl:(NSString *)_url text:(NSString *)_text layout:(TweetLayout*)_layout {
	return [[[TweetLinkNode alloc] initWithUrl:_url text:_text layout:_layout] autorelease];
}

- (NSString *)html {
	return [NSString stringWithFormat:@"<a href=\"%@\">%@</a>", url, text];
}

- (void)dealloc {
	[url release];
	[super dealloc];
}
@end
