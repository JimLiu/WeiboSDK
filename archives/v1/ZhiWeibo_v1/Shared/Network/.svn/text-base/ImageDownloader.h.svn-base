//
//  ImageDownloader.h
//  TweetViewDemo
//
//  Created by junmin liu on 10-10-14.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageCache.h"

@interface ImageDownloader : NSObject {
	ImageCache *imageCache;
	NSMutableDictionary*    delegates;
	NSMutableDictionary*    pending;
} 

@property (nonatomic, assign) ImageCache *imageCache;

- (id)initWithImageCache:(ImageCache *)_imageCache;

+ (ImageDownloader*)downloaderWithName:(NSString*)name;

+ (ImageDownloader*)sharedDownloader;

+ (void)setSharedDownloader:(ImageDownloader*)downloader;

- (UIImage*)getImage:(NSString*)url delegate:(id)delegate;

- (NSData*)getImageData:(NSString*)url;

- (void)removeDelegate:(id)delegate forURL:(NSString*)key;

@end
