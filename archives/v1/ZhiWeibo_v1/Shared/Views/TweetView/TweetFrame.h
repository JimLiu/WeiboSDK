//
//  TweetFrame.h
//  TweetViewDemo
//
//  Created by junmin liu on 10-10-14.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TweetNode.h"

@interface TweetFrame : NSObject {
	CGRect frame;
	CGRect borderFrame;
	TweetNode *node;
}

@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) CGRect borderFrame;
@property (nonatomic, readonly) CGRect drawFrame;
@property (nonatomic, retain) TweetNode *node;

- (id)initWithNode:(TweetNode *)_node frame:(CGRect)_frame;

- (void)draw;

@end
