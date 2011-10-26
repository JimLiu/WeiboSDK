//
//  TweetImageFrame.m
//  TweetViewDemo
//
//  Created by junmin liu on 10-10-14.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "TweetImageFrame.h"
#import "UIImage+Alpha.h"
#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"

@interface TweetImageFrame (Private)


@end


@implementation TweetImageFrame
@synthesize imageNode;

- (id)initWithNode:(TweetImageNode *)_node frame:(CGRect)_frame {
	if (self = [super initWithNode:_node frame:_frame]) {
		imageNode = (TweetImageNode *)self.node;
        _receiver = [[ImageDownloadReceiver alloc] init];
		_receiver.imageContainer = self;
		//[self downloadImage];
	}
	return self;	
}


- (void)dealloc {
    _receiver.imageContainer = nil;
    ImageDownloader *downloader = [ImageDownloader downloaderWithName:imageNode.cacheName];
    [downloader removeDelegate:_receiver forURL:imageNode.imageUrl];
    [_receiver release];
	imageNode = nil;
    [super dealloc];
}

- (UIImage*)processStyle:(UIImage*)_image {
	if (!_image || !imageNode) {
		return _image;
	}

	if (imageNode.className && imageNode.className.length > 0) {
		return [[TweetImageStyle sharedStyle] processWithClassName:imageNode.className
														forImage:_image];
	}

	return _image;
}

- (UIImage *)getImageFromStyledImageCache {
	if (!imageNode.className || imageNode.className.length == 0) {
		return nil;
	}
	return [[TweetImageStyle sharedStyle]getImageFromCacheByClassName:imageNode.className
													   withUrl:imageNode.imageUrl];
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
			rect.size.height = rect.size.height * imageNode.maxWidth / rect.size.width;
			rect.size.width = imageNode.maxWidth;
		}
	}
	if (rect.size.width != self.frame.size.width || rect.size.height != self.frame.size.height) {
		self.frame = rect;
		self.borderFrame = CGRectMake(frame.origin.x - 6, frame.origin.y - 6,  frame.size.width + 12, frame.size.height + 12);
		//[imageNode.layout setNeedsLayout];
	}
}

- (UIImage*)downloadImage {
	
	if (nil != imageNode.imageUrl && imageNode.imageUrl.length > 0) {
		UIImage *cachedImage = [self getImageFromStyledImageCache];
		if (!cachedImage) {
			cachedImage = [[ImageDownloader downloaderWithName:imageNode.cacheName] getImage:imageNode.imageUrl delegate:_receiver];
			if (cachedImage && imageNode.className && imageNode.className.length > 0) {
				TweetImageStyle *style = [TweetImageStyle sharedStyle];
				ImageCache *styleCache = [style getStyledImageCache:imageNode.className];
				UIImage *styledImage = [styleCache imageForURL:imageNode.imageUrl];
				if (styledImage) {
					cachedImage = styledImage;
				}
				else {
					cachedImage = [self processStyle:cachedImage];
					[styleCache storeImage:cachedImage forURL:imageNode.imageUrl];
				}
			}
		}
		if (cachedImage) {
			imageNode.imageWidth = cachedImage.size.width;
			imageNode.imageHeight = cachedImage.size.height;
			//[self sizeFit:cachedImage];
			return cachedImage;
		}
	} 
	return nil;
}


- (void)updateImage:(UIImage *)image sender:(ImageDownloadReceiver *)receiver {
	image = [self processStyle:image];
	imageNode.imageWidth = image.size.width;
	imageNode.imageHeight = image.size.height;
	//[self sizeFit:image];
	[imageNode.layout setNeedsDisplay];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)draw {
	
	CGRect rect = [self drawFrame];
	UIImage* image = [self downloadImage];//
	if (!image) {
		image = imageNode.defaultImage;
		//rect.size.width = image.size.width;
		//rect.size.height = image.size.height;
	}
	else {
		[self sizeFit:image];
	}

	if (image) {
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		CGContextSaveGState(ctx);
		CGContextAddRect(ctx, rect);
		CGContextClip(ctx);
		[image drawInRect:rect];
		CGContextRestoreGState(ctx);
	}
	
}


@end
