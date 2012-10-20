//
//  ImageCache.m
//  TweetViewDemo
//
//  Created by junmin liu on 10-10-14.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "ImageCache.h"
#import <CommonCrypto/CommonDigest.h>

#define DEFAULT_CACHE_INVALIDATION_AGE (60*60*24)    // 1 day
#define DEFAULT_CACHE_EXPIRATION_DAY   (60*60*24*1)  // 1 day
#define DEFAULT_CACHE_EXPIRATION_3DAYS   (60*60*24*3)  // 3 days
#define DEFAULT_CACHE_EXPIRATION_WEEK   (60*60*24*7)  // 1 week
#define DEFAULT_CACHE_EXPIRATION_2WEEKS   (60*60*24*14)  // 2 weeks
#define DEFAULT_CACHE_EXPIRATION_MONTH   (60*60*24*30)  // 1 month
#define CACHE_EXPIRATION_AGE_NEVER     (1.0 / 0.0)   // inf

static const  CGFloat   kLargeImageSize = 600 * 400;
static        NSString* kDefaultCacheName       = @"imagecache";

static ImageCache*          gSharedCache = nil;
static NSMutableDictionary* gNamedCaches = nil;

@interface ImageCache(Private)



@end

@implementation ImageCache
@synthesize disableDiskCache  = _disableDiskCache;
@synthesize disableImageCache = _disableImageCache;
@synthesize cachePath         = _cachePath;
@synthesize maxPixelCount     = _maxPixelCount;
@synthesize invalidationAge   = _invalidationAge;


- (id)initWithName:(NSString*)name
{
    self = [super init];
	if (self) {
		_name             = [name copy];
		_cachePath        = [[ImageCache cachePathWithName:name] retain];
		_invalidationAge  = DEFAULT_CACHE_INVALIDATION_AGE;
		
		_maxPixelCount = 1000 * 1000;
		_imageCache = [[NSMutableDictionary alloc] init];
		_imageSortedList = [[NSMutableArray alloc] init];
		_disableImageCache = YES;
	}
    return self;
}

- (id)init {
    self = [self initWithName:kDefaultCacheName];
	if (self) {
	}
	
	return self;
}

- (void)dealloc
{
	[_name release];
	[_cachePath release];
    [_imageCache release];
    [_imageSortedList release];
	[super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (ImageCache*)cacheWithName:(NSString*)name {
	if (!gNamedCaches) {
		gNamedCaches = [[NSMutableDictionary alloc] init];
	}
	ImageCache* cache = [gNamedCaches objectForKey:name];
	if (!cache) {
		cache = [[[ImageCache alloc] initWithName:name] autorelease];
		[gNamedCaches setObject:cache forKey:name];
	}
	return cache;
}

+ (void)removeExpiredImages {
    for (NSString *name in [gNamedCaches allKeys]) {
        ImageCache *cache = [gNamedCaches objectForKey:name];
        if (cache) {
            if ([name isEqualToString:@"profileImages"]) {
                [cache expireImagesFromDisk:DEFAULT_CACHE_EXPIRATION_2WEEKS maxDeleteCount:10];
            }
            else if ([name isEqualToString:@"photos"]) {
                [cache expireImagesFromDisk:DEFAULT_CACHE_EXPIRATION_WEEK maxDeleteCount:4];
            }
            else {
                [cache expireImagesFromDisk:DEFAULT_CACHE_EXPIRATION_WEEK maxDeleteCount:10];
            }
        }
    }
}

+ (void)removeCachedImages {
    [ImageCache cacheWithName:@"photos"];
    [ImageCache cacheWithName:@"thumbnails"];
    [ImageCache cacheWithName:@"profileImages"];
    [ImageCache cacheWithName:@"favicons"];
    for (NSString *name in [gNamedCaches allKeys]) {
        ImageCache *cache = [gNamedCaches objectForKey:name];
        if (cache) {
            [cache removeAll:YES];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (ImageCache*)sharedCache {
	if (!gSharedCache) {
		gSharedCache = [[ImageCache alloc] init];
	}
	return gSharedCache;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)setSharedCache:(ImageCache*)cache {
	if (gSharedCache != cache) {
		[gSharedCache release];
		gSharedCache = [cache retain];
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL)createPathIfNecessary:(NSString*)path {
	BOOL succeeded = YES;
	
	NSFileManager* fm = [NSFileManager defaultManager];
	if (![fm fileExistsAtPath:path]) {
		succeeded = [fm createDirectoryAtPath: path
				  withIntermediateDirectories: YES
								   attributes: nil
										error: nil];
	}
	
	return succeeded;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString*)cachePathWithName:(NSString*)name {
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString* cachesPath = [paths objectAtIndex:0];
	NSString* cachePath = [cachesPath stringByAppendingPathComponent:name];
	
	[self createPathIfNecessary:cachesPath];
	[self createPathIfNecessary:cachePath];
	
	return cachePath;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) isBundleURL:(NSString*) URL {
	return [URL hasPrefix:@"bundle://"];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) isDocumentsURL:(NSString*) URL {
	return [URL hasPrefix:@"documents://"];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)expireImagesFromMemory {
	while (_imageSortedList.count) {
		NSString* key = [_imageSortedList objectAtIndex:0];
		UIImage* image = [_imageCache objectForKey:key];
		
		_totalPixelCount -= image.size.width * image.size.height;
		[_imageCache removeObjectForKey:key];
		[_imageSortedList removeObjectAtIndex:0];
		
		if (_totalPixelCount <= _maxPixelCount) {
			break;
		}
	}
}

- (void)expireImagesFromDisk:(NSTimeInterval)expirationAge maxDeleteCount:(int)maxDeleteCount {
	NSFileManager* fm = [NSFileManager defaultManager];
	NSDirectoryEnumerator* e = [fm enumeratorAtPath:_cachePath];
    NSString* fileName = [e nextObject];
    int count = 0;
	while (fileName) {
		NSString* filePath = [_cachePath stringByAppendingPathComponent:fileName];
		NSDictionary* attrs = [fm attributesOfItemAtPath:filePath error:nil];
		NSDate* modified = [attrs objectForKey:NSFileModificationDate];
		NSTimeInterval t = [modified timeIntervalSinceNow];
		if (t < -expirationAge) {
			[fm removeItemAtPath:filePath error:nil];
            NSLog(@"delete file: %@", filePath);
		}
        count++;
        if (maxDeleteCount > 0 && count >= maxDeleteCount) {
            break;
        }
		fileName = [e nextObject];
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)cacheImage:(UIImage*)image forURL:(NSString*)URL force:(BOOL)force {
	if (nil != image && (force || !_disableImageCache)) {
		int pixelCount = image.size.width * image.size.height;
		
		if (force || pixelCount < kLargeImageSize) {
			_totalPixelCount += pixelCount;
			
			if (_totalPixelCount > _maxPixelCount && _maxPixelCount) {
				[self expireImagesFromMemory];
			}
			
			[_imageSortedList addObject:URL];
			[_imageCache setObject:image forKey:URL];
		}
	}
}

- (NSString*) pathForDocumentsResource:(NSString*) relativePath {
	static NSString* documentsPath = nil;
	if (!documentsPath) {
		NSArray* dirs = NSSearchPathForDirectoriesInDomains(
															NSDocumentDirectory, NSUserDomainMask, YES);
		documentsPath = [[dirs objectAtIndex:0] retain];
	}
	return [documentsPath stringByAppendingPathComponent:relativePath];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)imageExistsFromBundle:(NSString*)URL {
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
	NSString* path = [resourcePath stringByAppendingPathComponent:[URL substringFromIndex:9]];
	NSFileManager* fm = [NSFileManager defaultManager];
	return [fm fileExistsAtPath:path];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)imageExistsFromDocuments:(NSString*)URL {
	NSString* path = [self pathForDocumentsResource:[URL substringFromIndex:12]];
	NSFileManager* fm = [NSFileManager defaultManager];
	return [fm fileExistsAtPath:path];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIImage*)loadImageFromBundle:(NSString*)URL {
	NSString* path = [URL substringFromIndex:9];
	return [UIImage imageNamed:path];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIImage*)loadImageFromDocuments:(NSString*)URL {
	NSString* path = [self pathForDocumentsResource:[URL substringFromIndex:12]];
	NSData* data = [NSData dataWithContentsOfFile:path];
	return [UIImage imageWithData:data];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSData*)loadImageDataFromBundle:(NSString*)URL {
	NSString *path = [[[NSBundle mainBundle] resourcePath] 
					  stringByAppendingPathComponent:[URL substringFromIndex:9]];
	return [NSData dataWithContentsOfFile: path];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSData*)loadImageDataFromDocuments:(NSString*)URL {
	NSString* path = [self pathForDocumentsResource:[URL substringFromIndex:12]];
	return [NSData dataWithContentsOfFile:path];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSData*)loadImageDataForKey:(NSString*)key {
	NSString* filePath = [self cachePathForKey:key];
	return [NSData dataWithContentsOfFile: filePath];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSData*)loadImageDataForURL:(NSString*)URL {
	NSString* key = [self keyForURL:URL];
	return [self loadImageDataForKey:key];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)keyForURL:(NSString*)URL {
    
    NSData *keyData = [URL dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5([keyData bytes], [keyData length], result);
	
	NSString* key = [NSString stringWithFormat:
                     @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                     result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
                     result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
                     ];
    
	//NSString* key = [[URL dataUsingEncoding:NSUTF8StringEncoding] md5Hash];
	//NSLog(@"Url:%@ for key:%@", URL, key);
	return key;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)cachePathForURL:(NSString*)URL {
	NSString* key = [self keyForURL:URL];
	return [self cachePathForKey:key];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)cachePathForKey:(NSString*)key {
	return [_cachePath stringByAppendingPathComponent:key];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)hasImageForURL:(NSString*)URL {
	BOOL hasImage = (nil != [_imageCache objectForKey:URL]);
	if (!hasImage) {
		NSString* filePath = [self cachePathForURL:URL];
		NSFileManager* fm = [NSFileManager defaultManager];
		hasImage = [fm fileExistsAtPath:filePath];
	}
	return hasImage;
}

- (NSData*)imageDataForURL:(NSString*)URL {
	NSData *data = nil;
	if ([self isBundleURL:URL]) {
		data = [self loadImageDataFromBundle:URL];				
	} 
	else if ([self isDocumentsURL:URL]) {
		data = [self loadImageDataFromDocuments:URL];
	}
	else {
		data = [self loadImageDataForURL:URL];
	}
    
	return data;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIImage*)imageForURL:(NSString*)URL {
	UIImage* image = [_imageCache objectForKey:URL];
	if (nil != image) 
		return image;
	return [self imageForURL:URL expires:CACHE_EXPIRATION_AGE_NEVER timestamp:nil];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIImage*)imageForURL:(NSString*)URL expires:(NSTimeInterval)expirationAge
              timestamp:(NSDate**)timestamp {
	UIImage *image = nil;
	
	if ([self isBundleURL:URL]) {
		image = [self loadImageFromBundle:URL];				
	} 
	else if ([self isDocumentsURL:URL]) {
		image = [self loadImageFromDocuments:URL];
	}
	if (image) {
		[self storeImage:image forURL:URL];
		return image;
	}
	
	NSString* key = [self keyForURL:URL];
	return [self imageForKey:key expires:expirationAge timestamp:timestamp];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)hasImageForKey:(NSString*)key expires:(NSTimeInterval)expirationAge {
	NSString* filePath = [self cachePathForKey:key];
	NSFileManager* fm = [NSFileManager defaultManager];
	if ([fm fileExistsAtPath:filePath]) {
		NSDictionary* attrs = [fm attributesOfItemAtPath:filePath error:nil];
		NSDate* modified = [attrs objectForKey:NSFileModificationDate];
		if ([modified timeIntervalSinceNow] < -expirationAge) {
			return NO;
		}
		
		return YES;
	}
	
	return NO;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIImage*)imageForKey:(NSString*)key expires:(NSTimeInterval)expirationAge
              timestamp:(NSDate**)timestamp {
	NSString* filePath = [self cachePathForKey:key];
	NSFileManager* fm = [NSFileManager defaultManager];
	if ([fm fileExistsAtPath:filePath]) {
		NSDictionary* attrs = [fm attributesOfItemAtPath:filePath error:nil];
		NSDate* modified = [attrs objectForKey:NSFileModificationDate];
		if ([modified timeIntervalSinceNow] < -expirationAge) {
			return nil;
		}
		if (timestamp) {
			*timestamp = modified;
		}
		
		return [UIImage imageWithContentsOfFile:filePath];
	}
	
	return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)storeImage:(UIImage*)image forURL:(NSString*)URL {
	NSString* key = [self keyForURL:URL];
	[self storeImage:image forKey:key];
	if (!_disableImageCache) {
		[self cacheImage:image forURL:URL force:NO]; // save to memory
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)storeImage:(UIImage*)image forKey:(NSString*)key {
	[self storeData:UIImagePNGRepresentation(image) forKey:key];
}



///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)storeData:(NSData*)data forURL:(NSString*)URL {
	NSString* key = [self keyForURL:URL];
	[self storeData:data forKey:key];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)storeData:(NSData*)data forKey:(NSString*)key {
	if (!_disableDiskCache) {
		NSString* filePath = [self cachePathForKey:key];
		NSFileManager* fm = [NSFileManager defaultManager];
		[fm createFileAtPath:filePath contents:data attributes:nil];
	}
}

- (void)storeData:(NSMutableArray *)args {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
	if (!_disableDiskCache) {
        NSData *data = [args objectAtIndex:0];
        NSString *key = [args objectAtIndex:1];
		NSString* filePath = [self cachePathForKey:key];
		NSFileManager* fm = [NSFileManager defaultManager];
		[fm createFileAtPath:filePath contents:data attributes:nil];
	}
    
	[pool release];
}

- (void)asyncStoreData:(NSData*)data forURL:(NSString*)URL {
    NSString* key = [self keyForURL:URL];
	[self asyncStoreData:data forKey:key];
}

- (void)asyncStoreData:(NSData*)data forKey:(NSString*)key {
    [NSThread detachNewThreadSelector:@selector(storeData:) 
                             toTarget:self 
                           withObject:[NSMutableArray arrayWithObjects:data, key, nil]];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeURL:(NSString*)URL fromDisk:(BOOL)fromDisk {
	[_imageSortedList removeObject:URL];
	[_imageCache removeObjectForKey:URL];
	
	if (fromDisk) {
		NSString* key = [self keyForURL:URL];
		NSString* filePath = [self cachePathForKey:key];
		NSFileManager* fm = [NSFileManager defaultManager];
		if (filePath && [fm fileExistsAtPath:filePath]) {
			[fm removeItemAtPath:filePath error:nil];
		}
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeKey:(NSString*)key {
	NSString* filePath = [self cachePathForKey:key];
	NSFileManager* fm = [NSFileManager defaultManager];
	if (filePath && [fm fileExistsAtPath:filePath]) {
		[fm removeItemAtPath:filePath error:nil];
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeAll:(BOOL)fromDisk {
	[_imageCache removeAllObjects];
	[_imageSortedList removeAllObjects];
	_totalPixelCount = 0;
	
	if (fromDisk) {
		NSFileManager* fm = [NSFileManager defaultManager];
		[fm removeItemAtPath:_cachePath error:nil];
		[ImageCache createPathIfNecessary:_cachePath];
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)invalidateURL:(NSString*)URL {
	NSString* key = [self keyForURL:URL];
	return [self invalidateKey:key];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)invalidateKey:(NSString*)key {
	NSString* filePath = [self cachePathForKey:key];
	NSFileManager* fm = [NSFileManager defaultManager];
	if (filePath && [fm fileExistsAtPath:filePath]) {
		NSDate* invalidDate = [NSDate dateWithTimeIntervalSinceNow:-_invalidationAge];
		NSDictionary* attrs = [NSDictionary dictionaryWithObject:invalidDate
														  forKey:NSFileModificationDate];
		
#if __IPHONE_4_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED
		[fm setAttributes:attrs ofItemAtPath:filePath error:nil];
#else
		[fm changeFileAttributes:attrs atPath:filePath];
#endif
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)invalidateAll {
	NSDate* invalidDate = [NSDate dateWithTimeIntervalSinceNow:-_invalidationAge];
	NSDictionary* attrs = [NSDictionary dictionaryWithObject:invalidDate
													  forKey:NSFileModificationDate];
	
	NSFileManager* fm = [NSFileManager defaultManager];
	NSDirectoryEnumerator* e = [fm enumeratorAtPath:_cachePath];
    NSString* fileName = [e nextObject];
	while (fileName) {
		NSString* filePath = [_cachePath stringByAppendingPathComponent:fileName];
#if __IPHONE_4_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED
		[fm setAttributes:attrs ofItemAtPath:filePath error:nil];
#else
		[fm changeFileAttributes:attrs atPath:filePath];
#endif
        fileName = [e nextObject];
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)logMemoryUsage {
#if TTLOGLEVEL_INFO <= TTMAXLOGLEVEL
	NSLog(@"======= IMAGE CACHE: %d images, %d pixels ========",
		  _imageCache.count, _totalPixelCount);
	NSEnumerator* e = [_imageCache keyEnumerator];
    NSString* key = [e nextObject];
	while (key) {
		UIImage* image = [_imageCache objectForKey:key];
		NSLog(@"  %f x %f %@", image.size.width, image.size.height, key);
        key = [e nextObject];
	}
#endif
}





@end
