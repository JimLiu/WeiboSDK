//
//  TweetImageNode.m
//  TweetViewDemo
//
//  Created by junmin liu on 10-10-14.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "TweetImageNode.h"


@implementation TweetImageNode

@synthesize imageUrl           = _imageUrl;
@synthesize defaultImage  = _defaultImage;

- (id)initWithImageUrl:(NSString*)imageUrl 
   cacheName:(NSString *)_cacheName  
		   layout:(TweetLayout*)_layout {
	if (self = [super initWithLayout:_layout]) {
		cacheName = [_cacheName retain];
		self.imageUrl = imageUrl;
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithImageUrl:(NSString*)imageUrl  layout:(TweetLayout*)_layout {
	if (self = [self initWithImageUrl:imageUrl cacheName:@"tweetImages" layout:_layout]) {
	}
	
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setImageUrl:(NSString*)URL {
	if (nil == _imageUrl || ![URL isEqualToString:_imageUrl]) {
		[_imageUrl release];
		_imageUrl = [URL retain];
	}
}

- (NSString *)html {
	return [NSString stringWithFormat:@"<img src=\"%@\" />", _imageUrl];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
	[_imageUrl release];
	[_defaultImage release];
	[super dealloc];
}

@end
