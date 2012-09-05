//
//  TweetImageLinkNode.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-3.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "TweetImageLinkNode.h"


@implementation TweetImageLinkNode
@synthesize url;

- (id)initWithUrl:(NSString *)_url imageUrl:(NSString *)_imgUrl layout:(TweetLayout*)_layout {
	if (self = [super initWithImageUrl:_imgUrl layout:_layout]) {
		url = [_url copy];
	}
	return self;
}

+ (TweetImageLinkNode *)withUrl:(NSString *)_url imageUrl:(NSString *)_imageUrl layout:(TweetLayout*)_layout {
	return [[[TweetImageLinkNode alloc] initWithUrl:_url imageUrl:_imageUrl layout:_layout] autorelease];
}

- (NSString *)html {
	return [NSString stringWithFormat:@"<a href=\"%@\"><img src=\"%@\" border=\"0\" /></a>", url, _imageUrl];
}

- (void)dealloc {
	[url release];
	[super dealloc];
}

@end
