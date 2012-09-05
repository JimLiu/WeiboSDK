//
//  TweetImageFrame.h
//  TweetViewDemo
//
//  Created by junmin liu on 10-10-14.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TweetFrame.h"
#import "TweetImageNode.h"
#import "ImageDownloader.h"
#import "ImageCache.h"
#import "TweetImageStyle.h"
#import "ImageDownloadReceiver.h"

@interface TweetImageFrame : TweetFrame {
	TweetImageNode *imageNode;
    ImageDownloadReceiver*     _receiver;
}

@property (nonatomic, assign) TweetImageNode *imageNode;

- (id)initWithNode:(TweetImageNode *)_node frame:(CGRect)_frame;

- (UIImage*)downloadImage;
- (void)sizeFit:(UIImage *)image;

@end
