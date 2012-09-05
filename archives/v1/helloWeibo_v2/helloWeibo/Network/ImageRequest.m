//
//  ImageRequest.m
//  helloWeibo
//
//  Created by junmin liu on 11-4-20.
//  Copyright 2011年 Openlab. All rights reserved.
//

#import "ImageRequest.h"

@interface ImageRequest (Private) 

 
    
@end

@implementation ImageRequest
@synthesize url = _url;
@synthesize imageRequestDelegate = _imageRequestDelegate;
@synthesize imageCache = _imageCache;
@synthesize progress, max;

- (id)initWithUrl:(NSString *)url {
    self = [super init];
    if (self) {
        _url = [url retain];
        _delegates = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    [_url release];
    [_delegates release];
    [_downloadPath release];
    _imageRequestDelegate = nil;
    _imageCache = nil;
    [super dealloc];
}

- (BOOL)inProgress {
    if (_request && _request.inProgress) {
        return YES;
    }
    return NO;
}

- (void)startDownload
{
    if (!_request) {
        _request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:_url]];
        [_request setDownloadProgressDelegate:self];
        [_request setDelegate:self];
        if (_imageCache) {
            _downloadPath = [[_imageCache cachePathForURL:_url] copy];
            NSString *tempDownloadFilepath = [NSString stringWithFormat:@"%@.download", _downloadPath];
            [_request setDownloadDestinationPath:_downloadPath];
            [_request setTemporaryFileDownloadPath:tempDownloadFilepath];
            [_request setAllowResumeForFileDownloads:YES];
        }
    }
    if (!_request.inProgress) {
        [_request startAsynchronous];        
    }
}

- (void)cancelDownload
{
    if (_request) {
        [_request clearDelegatesAndCancel];
        _request = nil;
        [_downloadPath release];
        _downloadPath = nil;
    }
}


- (void)addDelegate:(id)delegate {
    if (delegate) {
        BOOL delegateExists = NO;
        for (id del in _delegates) {
            if (del == delegate) {
                delegateExists = YES;
                break;
            }
        }
        if (!delegateExists) {
            [_delegates addObject:delegate];
        }
    }

}

- (void)removeDelegate:(id)delegate {
    [_delegates removeObject:delegate];
}

- (void)clearDelegates {
    [_delegates removeAllObjects];
}

- (void)notifyDelegates:(NSData *)imageData {
	UIImage *image = [UIImage imageWithData:imageData];
    
    for (id delegate in _delegates) {
        if (delegate && [delegate respondsToSelector:@selector(imageDidDownload:url:)]) {
            [delegate performSelector:@selector(imageDidDownload:url:) withObject:image withObject:_url];
        }
    }
    [_delegates removeAllObjects];
    
    if (_imageRequestDelegate && [_imageRequestDelegate respondsToSelector:@selector(imageDidDownload:request:)]) {
        [_imageRequestDelegate performSelector:@selector(imageDidDownload:request:) withObject:imageData withObject:self];
    }
}

-(void)backgroundLoadImageFromPath:(NSString*)path {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSData *responseData = [NSData dataWithContentsOfFile:path];;
    [self performSelectorOnMainThread:@selector(notifyDelegates:) withObject:responseData waitUntilDone:YES];
    [pool release];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	NSData *responseData;
    if (_downloadPath) {
        [self performSelectorInBackground:@selector(backgroundLoadImageFromPath:) withObject:_downloadPath];
    }
    else {
        responseData = [request responseData];
        
        [self notifyDelegates:responseData];
    }
    _request = nil;
    [_downloadPath release];
    _downloadPath = nil;

}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
    _request = nil;
    [_downloadPath release];
    _downloadPath = nil;

	for (id delegate in _delegates) {
        if (delegate && [delegate respondsToSelector:@selector(imageDownloadFailed:url:)]) {
            [delegate performSelector:@selector(imageDownloadFailed:url:) withObject:error  withObject:_url];
        }
    }
    [_delegates removeAllObjects];
    
    if (_imageRequestDelegate && [_imageRequestDelegate respondsToSelector:@selector(imageDownloadFailed:request:)]) {
        [_imageRequestDelegate performSelector:@selector(imageDownloadFailed:request:) withObject:error  withObject:self];
    }
    
}


- (void)setProgress:(float)_progress {
	if (progress != _progress) {
		progress = _progress;
        for (id delegate in _delegates) {
            if (delegate && [delegate respondsToSelector:@selector(setProgress:)]) {
                [delegate performSelector:@selector(setProgress:) withObject:[NSNumber numberWithFloat:progress]];
            }
        }
	}
}

@end
