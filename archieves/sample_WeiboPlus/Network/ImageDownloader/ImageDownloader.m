//
//  ImageDownloader.m
//  TweetViewDemo
//
//  Created by junmin liu on 10-10-14.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "ImageDownloader.h"
#import "ASIHTTPRequest.h"

#define MAX_CONNECTION 4

static ImageDownloader*          gSharedDownloader = nil;
static NSMutableDictionary* gNamedDownloaders = nil;

@implementation ImageDownloader
@synthesize imageCache;

- (id)initWithImageCache:(ImageCache *)_imageCache
{
    self = [super init];
	if (self) {
		imageCache    = _imageCache;
		requests = [[NSMutableDictionary alloc] init];
        pendingRequests = [[NSMutableArray alloc] init];
        activeRequests = [[NSMutableArray alloc] init];
        deactiveRequests = [[NSMutableArray alloc] init];
	}
    return self;
}

- (id)init {
    self = [self initWithImageCache:[ImageCache sharedCache]];
	if (self) {
		
	}
	return self;
}

- (void)dealloc
{
    [requests release];
    [pendingRequests release];
    [activeRequests release];
    [deactiveRequests release];
    imageCache = nil;
	[super dealloc];
}


+ (ImageDownloader*)profileImagesDownloader {
    return [ImageDownloader downloaderWithName:@"profileImages"];
}

+ (ImageDownloader*)thumbnailsDownloader {
    return [ImageDownloader downloaderWithName:@"thumbnails"];
}

+ (ImageDownloader*)faviconsDownloader {
    return [ImageDownloader downloaderWithName:@"favicons"];
}

+ (ImageDownloader*)photosDownloader {
    return [ImageDownloader downloaderWithName:@"photos"];
}

+ (ImageDownloader*)mapImagesDownloader {
    return [ImageDownloader downloaderWithName:@"mapImages"];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (ImageDownloader*)downloaderWithName:(NSString*)name {
	if (!gNamedDownloaders) {
		gNamedDownloaders = [[NSMutableDictionary alloc] init];
	}
	ImageDownloader* downloader = [gNamedDownloaders objectForKey:name];
	if (!downloader) {
		downloader = [[[ImageDownloader alloc] initWithImageCache:[ImageCache cacheWithName:name]] autorelease];
		if ([name isEqualToString:@"emoticons"]) {
			downloader.imageCache.disableImageCache = NO;
		}
		[gNamedDownloaders setObject:downloader forKey:name];
	}
	return downloader;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (ImageDownloader*)sharedDownloader {
	if (!gSharedDownloader) {
		gSharedDownloader = [[ImageDownloader alloc] init];
	}
	return gSharedDownloader;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)setSharedDownloader:(ImageDownloader*)downloader {
	if (gSharedDownloader != downloader) {
		[gSharedDownloader release];
		gSharedDownloader = [downloader retain];
	}
}

- (void)removeRequestFromPendings:(NSString *)url {
    for (int i = 0; i < pendingRequests.count; i++) {
        ImageRequest *r = [pendingRequests objectAtIndex:i];
        if ([r.url isEqualToString:url]) {
            [pendingRequests removeObjectAtIndex:i];
            break;
        }
    }
}

- (void)removeRequestFromActives:(NSString *)url {
    for (int i = 0; i < activeRequests.count; i++) {
        ImageRequest *r = [activeRequests objectAtIndex:i];
        if ([r.url isEqualToString:url]) {
            [activeRequests removeObjectAtIndex:i];
            break;
        }
    }
}

- (void)removeRequestFromDeactives:(NSString *)url {
    for (int i = 0; i < deactiveRequests.count; i++) {
        ImageRequest *r = [deactiveRequests objectAtIndex:i];
        if ([r.url isEqualToString:url]) {
            [deactiveRequests removeObjectAtIndex:i];
            break;
        }
    }
}

- (ImageRequest *)requestImage:(NSString *)url delegate:(id)delegate {
    if (!url) {
        return nil;
    }
    ImageRequest *request = [requests objectForKey:url];
    if (!request) {
        request = [[[ImageRequest alloc]initWithUrl:url]autorelease];
        request.imageRequestDelegate = self;
        request.imageCache = imageCache;
        [requests setObject:request forKey:url];
    }
    [request addDelegate:delegate];
    return request;
}


- (void)notifyDelegate:(NSMutableDictionary*)args {
    id delegate = [args objectForKey:@"delegate"];
    NSString *url = [args objectForKey:@"url"];
    NSData *imageData = [args objectForKey:@"imageData"];
	if (delegate && [delegate respondsToSelector:@selector(imageDidDownload:url:)]) {
        [delegate performSelector:@selector(imageDidDownload:url:) withObject:imageData withObject:url];
    }
}


-(BOOL)backgroundLoadLocalImage:(NSMutableDictionary*)args {
    BOOL result = NO;
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *url = [args objectForKey:@"url"];
    NSData *imageData = [imageCache imageDataForURL:url];
    if (imageData) {
        UIImage *image = [UIImage imageWithData:imageData];
        if (!image) { //delete image which downloaded failed
            [imageCache removeURL:url fromDisk:YES];
        }
        else {
            [args setValue:imageData forKey:@"imageData"];
            [self performSelectorOnMainThread:@selector(notifyDelegate:) withObject:args waitUntilDone:YES];
            result = YES;
        }
    }
    [pool release];
    return result;
}

- (void)activeRequestInBackground:(NSMutableDictionary*)args {
    NSString *url = [args objectForKey:@"url"];
    id delegate = [args objectForKey:@"delegate"];
    if (imageCache && [self backgroundLoadLocalImage:args]) {
        return;
    }

    
    ImageRequest *request = [self requestImage:url delegate:delegate];
    for (ImageRequest *activeRequest in activeRequests) {
        if (activeRequest == request) {
            return; // is downloading
        }
    }
    [self removeRequestFromPendings:url];
    [self removeRequestFromDeactives:url];
    
    
    if ([activeRequests count] >= MAX_CONNECTION) {
        ImageRequest *deactiveRequest = [[activeRequests objectAtIndex:0] retain]; // deactive a request;
        [deactiveRequest cancelDownload];
        [self removeRequestFromActives:deactiveRequest.url];
        [self removeRequestFromDeactives:deactiveRequest.url];
        [self removeRequestFromPendings:deactiveRequest.url];
        [deactiveRequests addObject:deactiveRequest];
        [deactiveRequest release];
    }
    
    [activeRequests addObject:request];
    [request startDownload];
}

- (void)activeRequest:(NSString*)url delegate:(id)delegate {
    if (!url) {
        return;
    }
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    [args setValue:url forKey:@"url"];
    if (delegate) {
        [args setValue:delegate forKey:@"delegate"];
    }
    [self performSelectorInBackground:@selector(activeRequestInBackground:) withObject:args];
}



- (void)queryImageInBackground:(NSMutableDictionary*)args {
    NSString *url = [args objectForKey:@"url"];
    id delegate = [args objectForKey:@"delegate"];
    if (imageCache && [self backgroundLoadLocalImage:args]) {
        return;
    }
    
    ImageRequest *request = [self requestImage:url delegate:delegate];
    for (ImageRequest *activeRequest in activeRequests) {
        if (activeRequest == request) {
            return; // is downloading
        }
    }
    [self removeRequestFromActives:url];
    [self removeRequestFromPendings:url];
    [self removeRequestFromDeactives:url];
    
    
    if ([activeRequests count] < MAX_CONNECTION) {
        [activeRequests addObject:request];
        [request startDownload];
    }
    else {
        [pendingRequests addObject:request];
    }
}


- (void)queueImage:(NSString*)url delegate:(id)delegate {
    if (!url) {
        return;
    }
    
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    [args setValue:url forKey:@"url"];
    if (delegate) {
        [args setValue:delegate forKey:@"delegate"];
    }
    
    [self performSelectorInBackground:@selector(queryImageInBackground:) withObject:args];
    
    
}

- (void)removeRequestQueueByUrl:(NSString *)url {
    [self removeRequestFromPendings:url];
    [self removeRequestFromActives:url];
    [self removeRequestFromDeactives:url];
    
    [requests removeObjectForKey:url]; 
}


- (void)requestPendingImage:(ImageRequest*)request
{
    [self removeRequestQueueByUrl:request.url]; 
    
    ImageRequest *popRequest = nil;
    if (deactiveRequests.count > 0) {
        popRequest = [[deactiveRequests objectAtIndex:0] retain];
        [deactiveRequests removeObjectAtIndex:0];
    }
    if (!popRequest) {
        if (pendingRequests.count > 0) {
            popRequest = [[pendingRequests objectAtIndex:0] retain];
            [pendingRequests removeObjectAtIndex:0];
        }
    }
    if (popRequest) {
        [activeRequests addObject:popRequest];
        [popRequest startDownload];
        [popRequest release];
    }
    
    //NSLog(@"pedding: %d, active: %d, deactive: %d, requests: %d", pendingRequests.count, activeRequests.count, deactiveRequests.count, requests.count);
}

- (void)imageDidDownload:(NSData *)imageData request:(ImageRequest *)request
{
    [self requestPendingImage:request];
	
}

- (void)imageDownloadFailed:(NSError *)error request:(ImageRequest *)request
{	
	[self requestPendingImage:request];
}

- (void)removeDelegate:(id)delegate forURL:(NSString*)url
{
    ImageRequest *request = [requests objectForKey:url];
    if (request) {
        [request removeDelegate:delegate];
    }
}




@end
