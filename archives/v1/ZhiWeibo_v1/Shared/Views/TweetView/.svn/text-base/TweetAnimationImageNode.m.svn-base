//
//  TweetAnimationImageNode.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-10-18.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "TweetAnimationImageNode.h"


@implementation TweetAnimationImageNode
@synthesize delays;
@synthesize imageUrls;
@synthesize currentFrame;
@synthesize gifUrl;


- (int)currentDelay {
	if (currentFrame < delays.count) {
		return [[delays objectAtIndex:currentFrame] intValue];
	}
	return 0;
}

- (NSString*)currentImageUrl {
	if (currentFrame < delays.count) {
		return [imageUrls objectAtIndex:currentFrame];
	}
	return nil;
}

- (NSString *)html {
	return [NSString stringWithFormat:@"<img src=\"%@\" />", gifUrl];
}

- (void)dealloc {
	[delays release];
	[imageUrls release];
	[gifUrl release];
	[super dealloc];
}
@end
