//
//  ImageDownloadReceiver.m
//  iPlus
//
//  Created by junmin liu on 11-7-26.
//  Copyright 2011年 Openlab. All rights reserved.
//

#import "ImageDownloadReceiver.h"


@implementation ImageDownloadReceiver

@synthesize failedCount;
@synthesize completionBlock = _completionBlock;
@synthesize progressBlock = _progressBlock;

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    [_completionBlock release];
    [_progressBlock release];
    [super dealloc];
}

- (void)imageDidDownload:(NSData*)imageData url:(NSString *)url
{
    if (_completionBlock) {
        _completionBlock(imageData, url, nil);
    }
}

- (void)imageDownloadFailed:(NSError *)error url:(NSString *)url {
	failedCount++;
    if (_completionBlock) {
        _completionBlock(nil, url, error);
    }
}

- (void)updateProgress:(NSNumber*)totalBytesReadNumber 
               ofTotal:(NSNumber*)totalSizeNumber {
    if (_progressBlock) {
        _progressBlock([totalSizeNumber floatValue], [totalBytesReadNumber floatValue]);
    }
}

- (void)setProgress:(NSNumber*)progressNumber {
	float _progress = [progressNumber floatValue];
	if (progress != _progress) {
		progress = _progress;		
	}
}


@end
