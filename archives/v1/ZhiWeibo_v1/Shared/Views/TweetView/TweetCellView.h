//
//  TweetCellView.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-10-16.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetDocument.h"

@interface TweetCellView : UIView {
	TweetDocument *doc;
	
	TweetLinkNode*  _highlightedNode;
	TweetFrame* _highlightedFrame;
	
	NSTimer *animationTimer;
    NSTimeInterval animationInterval;
}

@property (nonatomic, assign) NSTimeInterval animationInterval;
@property (nonatomic, retain) TweetDocument *doc;

@end
