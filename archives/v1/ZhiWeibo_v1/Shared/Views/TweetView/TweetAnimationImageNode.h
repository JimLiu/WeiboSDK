//
//  TweetAnimationImageNode.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-10-18.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TweetImageBaseNode.h"

@interface TweetAnimationImageNode : TweetImageBaseNode {
	NSMutableArray *delays;
	NSMutableArray *imageUrls;
	NSString *gifUrl;
	int currentFrame;
}

@property (nonatomic, assign) 	int currentFrame;
@property (nonatomic, retain) NSMutableArray *delays;
@property (nonatomic, retain) NSMutableArray *imageUrls;
@property (nonatomic, retain) NSString *gifUrl;

@property (nonatomic, readonly) int currentDelay;
@property (nonatomic, readonly) NSString* currentImageUrl;

@end
