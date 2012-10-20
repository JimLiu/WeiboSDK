//
//  ImageDownloader.h
//  TweetViewDemo
//
//  Created by junmin liu on 10-10-14.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageCache.h"
#import "ImageRequest.h"

@interface ImageDownloader : NSObject {
	ImageCache *imageCache;
    NSMutableDictionary*    requests; // Url和Request对应
    
    NSMutableArray*         pendingRequests;  // 待处理队列
    NSMutableArray*         activeRequests;   // 活动队列，当前正在下载的请求
    NSMutableArray*         deactiveRequests; // 非活动队列，临时停止的下载请求

} 

@property (nonatomic, assign) ImageCache *imageCache;

- (id)initWithImageCache:(ImageCache *)_imageCache;

+ (ImageDownloader*)profileImagesDownloader;
+ (ImageDownloader*)thumbnailsDownloader;
+ (ImageDownloader*)faviconsDownloader;
+ (ImageDownloader*)photosDownloader;
+ (ImageDownloader*)mapImagesDownloader;

+ (ImageDownloader*)downloaderWithName:(NSString*)name;

+ (ImageDownloader*)sharedDownloader;

+ (void)setSharedDownloader:(ImageDownloader*)downloader;

- (void)queueImage:(NSString*)url delegate:(id)delegate ;

- (void)activeRequest:(NSString*)url delegate:(id)delegate;

- (void)removeDelegate:(id)delegate forURL:(NSString*)key;

@end
