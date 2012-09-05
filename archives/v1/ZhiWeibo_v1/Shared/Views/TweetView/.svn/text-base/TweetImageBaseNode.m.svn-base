//
//  TweetImageBaseNode.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-10-18.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "TweetImageBaseNode.h"


@implementation TweetImageBaseNode
@synthesize width         = _width;
@synthesize height        = _height;
@synthesize imageWidth    = _imageWidth;
@synthesize imageHeight   = _imageHeight;
@synthesize maxWidth	  = _maxWidth;
@synthesize maxHeight     = _maxHeight;
@synthesize cacheName;

- (NSString *)cacheName {
	if (!cacheName) {
		return @"tweetImages";
	}
	return cacheName;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
	[cacheName release];
	[super dealloc];
}
@end
