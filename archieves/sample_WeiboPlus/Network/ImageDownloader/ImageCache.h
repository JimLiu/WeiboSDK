//
//  ImageCache.h
//  TweetViewDemo
//
//  Created by junmin liu on 10-10-14.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "NSDataAdditions.h"
//#import "NSStringAdditions.h"
//#import "GlobalCore.h"

@interface ImageCache : NSObject {
	NSString*             _name;
	NSString*             _cachePath;
	NSMutableDictionary*  _imageCache;
	NSMutableArray*       _imageSortedList;
	NSUInteger            _totalPixelCount;
	NSUInteger            _maxPixelCount;
	NSTimeInterval        _invalidationAge;	
	BOOL                  _disableDiskCache;
	BOOL                  _disableImageCache;
}

@property (nonatomic) NSUInteger maxPixelCount;
@property (nonatomic) NSTimeInterval invalidationAge;
@property (nonatomic, copy) NSString* cachePath;
@property (nonatomic) BOOL disableDiskCache;
@property (nonatomic) BOOL disableImageCache;

- (id)initWithName:(NSString*)name;

+ (NSString*)cachePathWithName:(NSString*)name;

+ (ImageCache*)cacheWithName:(NSString*)name;

+ (ImageCache*)sharedCache;

+ (void)removeCachedImages;

+ (void)removeExpiredImages;

+ (void)setSharedCache:(ImageCache*)cache;

- (NSString *)keyForURL:(NSString*)URL;

- (NSString*)cachePathForURL:(NSString*)URL;

- (NSString*)cachePathForKey:(NSString*)key;

- (BOOL)hasImageForURL:(NSString*)URL;

- (BOOL)hasImageForKey:(NSString*)key expires:(NSTimeInterval)expirationAge;

- (NSData*)imageDataForURL:(NSString*)URL;

- (UIImage*)imageForURL:(NSString*)URL;

- (UIImage*)imageForURL:(NSString*)URL expires:(NSTimeInterval)expirationAge
              timestamp:(NSDate**)timestamp;

- (UIImage*)imageForKey:(NSString*)key expires:(NSTimeInterval)expirationAge
              timestamp:(NSDate**)timestamp;

- (void)storeImage:(UIImage*)image forURL:(NSString*)URL;

- (void)storeImage:(UIImage*)image forKey:(NSString*)key;

- (void)storeData:(NSData*)data forURL:(NSString*)URL;

- (void)storeData:(NSData*)data forKey:(NSString*)key;

- (void)asyncStoreData:(NSData*)data forURL:(NSString*)URL;

- (void)asyncStoreData:(NSData*)data forKey:(NSString*)key;

- (void)expireImagesFromDisk:(NSTimeInterval)expirationAge maxDeleteCount:(int)maxDeleteCount;

- (void)removeURL:(NSString*)URL fromDisk:(BOOL)fromDisk;

- (void)removeKey:(NSString*)key;

- (void)removeAll:(BOOL)fromDisk;

- (void)invalidateURL:(NSString*)URL;

- (void)invalidateKey:(NSString*)key;

- (void)invalidateAll;

- (void)logMemoryUsage;

@end
