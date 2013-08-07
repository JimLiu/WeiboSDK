//
//  TweetLayer.h
//  TweetLayerDemo
//
//  Created by junmin liu on 12-10-17.
//  Copyright (c) 2012年 openlab Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>
#import "TweetDocument.h"


@class TweetLayer;
@protocol TweetLayerDelegate <NSObject>

@optional

- (void)tweetLayer:(TweetLayer *)layer didSelectLinkWithTweetLink:(TweetLink *)link;

@end


@interface TweetLayer : CATextLayer {
    TweetDocument *_document;
    id<TweetLayerDelegate> _delegate;
	TweetLink *_activeLink;
    
    NSMutableArray *_activeLinkBackgroundLayers;
}

@property (nonatomic, retain) TweetDocument *document;
@property (nonatomic, assign) id<TweetLayerDelegate> delegate;
@property (nonatomic, retain) TweetLink *activeLink;


- (BOOL)touchesBeganWithLocation:(CGPoint)point;
- (BOOL)touchesMovedWithLocation:(CGPoint)point;
- (BOOL)touchesEndedWithLocation:(CGPoint)point;
- (BOOL)touchesCancelled;

@end
