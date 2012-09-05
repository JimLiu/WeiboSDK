//
//  TweetView.h
//  TweetViewDemo
//
//  Created by junmin liu on 10-10-13.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetDocument.h"


@protocol TweetViewDelegate

- (void)processLinkTouch:(NSString*)url;

@end

@interface TweetView : UIView {
	TweetDocument *doc;
	id<TweetViewDelegate> statusViewDelegate;
	
	TweetNode*  _highlightedNode;
	TweetFrame* _highlightedFrame;
	TweetNode*  _selectedNode;
	TweetFrame* _selectedFrame;
	
	UIImage* backgroundImage;
	NSTimer *animationTimer;
    NSTimeInterval animationInterval;
}

@property NSTimeInterval animationInterval;
@property (nonatomic, retain) TweetDocument *doc;
@property (nonatomic, assign) id<TweetViewDelegate> statusViewDelegate;

- (void)reset;

@end
