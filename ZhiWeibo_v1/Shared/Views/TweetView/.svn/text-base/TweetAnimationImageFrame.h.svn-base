//
//  TweetAnimationImageFrame.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-10-18.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TweetFrame.h"
#import "TweetImageNode.h"
#import "ImageDownloader.h"
#import "ImageCache.h"
#import "TweetAnimationImageNode.h"
#import "ImageDownloadReceiver.h"

@interface TweetAnimationImageFrame : TweetFrame {
	TweetAnimationImageNode *imageNode;
	int currentFrameValue;
    ImageDownloadReceiver*     _receiver;
}

@property (nonatomic, assign) TweetAnimationImageNode *imageNode;

- (id)initWithNode:(TweetAnimationImageNode *)_node frame:(CGRect)_frame;

- (void)performStep:(int)step;

@end
