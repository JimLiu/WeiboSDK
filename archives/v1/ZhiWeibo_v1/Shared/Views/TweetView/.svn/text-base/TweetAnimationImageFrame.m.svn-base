//
//  TweetAnimationImageFrame.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-10-18.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "TweetAnimationImageFrame.h"


@implementation TweetAnimationImageFrame
@synthesize imageNode;

- (id)initWithNode:(TweetAnimationImageNode *)_node frame:(CGRect)_frame {
	if (self = [super initWithNode:_node frame:_frame]) {
		imageNode = (TweetAnimationImageNode *)self.node;
		currentFrameValue = 0;
        _receiver = [[ImageDownloadReceiver alloc] init];
		_receiver.imageContainer = self;
	}
	return self;	
}


- (void)performStep:(int)step {
	currentFrameValue += step;
	int delay = [imageNode currentDelay];
	if (currentFrameValue >= delay) {
		currentFrameValue = 0;
		imageNode.currentFrame++;
		if (imageNode.currentFrame >= imageNode.delays.count) {
			imageNode.currentFrame = 0;
		}
		if (delay > 0) {
			[imageNode.layout setNeedsDisplayInRect:self.frame];
		}
	}
}

- (void)sizeFit:(UIImage *)image {
	CGRect rect = self.frame;
	CGFloat imageWidth = imageNode.width ? imageNode.width : image.size.width;
	CGFloat imageHeight = imageNode.height ? imageNode.height : image.size.height;
	if (rect.size.width == 0) {
		rect.size.width = imageWidth;
	}
	if (rect.size.height == 0) {
		rect.size.height = imageHeight;
	}
	if (self.frame.size.width == 0 
		&& self.frame.size.height > 0 && image.size.height > 0) {
		rect.size.width = imageWidth * self.frame.size.height / image.size.height;
		if (imageNode.maxWidth && rect.size.width > imageNode.maxWidth) {
			rect.size.width = imageNode.maxWidth;
			rect.size.height = rect.size.height * rect.size.width / image.size.height;
		}
	}
	if (rect.size.width != self.frame.size.width || rect.size.height != self.frame.size.height) {
		self.frame = rect;
		[imageNode.layout setNeedsLayout];
	}
}


- (UIImage*)downloadImage {
	
	NSString *imgUrl = [imageNode currentImageUrl];
	if (nil != imgUrl && imgUrl.length > 0) {
		UIImage *cachedImage = [[ImageDownloader downloaderWithName:imageNode.cacheName] getImage:imgUrl delegate:_receiver];
		if (cachedImage) {
			[self sizeFit:cachedImage];
			return cachedImage;
		}
	} 
	return nil;
}


- (void)updateImage:(UIImage *)image sender:(ImageDownloadReceiver *)receiver {
	[self sizeFit:image];
	[imageNode.layout setNeedsDisplayInRect:self.frame];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)draw {
	
	UIImage* image = [self downloadImage];//
	
	if (image) {
		CGRect rect = [self drawFrame];
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		CGContextSaveGState(ctx);
		CGContextAddRect(ctx, rect);
		CGContextClip(ctx);
		[image drawInRect:rect];
		CGContextRestoreGState(ctx);
	}
	
}


- (void)dealloc {
    _receiver.imageContainer = nil;
    ImageDownloader *downloader = [ImageDownloader downloaderWithName:imageNode.cacheName];
    [downloader removeDelegate:_receiver forURL:[imageNode currentImageUrl]];
    [_receiver release];
	imageNode = nil;
    [super dealloc];
}


@end
