//
//  ImageDownloadReceiver.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-1.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "ImageDownloadReceiver.h"


@implementation ImageDownloadReceiver

@synthesize imageContainer, displayRect;
@synthesize failedCount;
@synthesize progress, max;

- (void)dealloc
{
    imageContainer = nil;
    [super dealloc];
}

- (void)imageDidDownload:(UIImage*)image
{
    if (imageContainer) {
        if ([imageContainer respondsToSelector:@selector(updateImage:sender:)]) {
            [imageContainer performSelector:@selector(updateImage:sender:) withObject:image withObject:self];
        }
    }
}

- (void)imageDidDownloadWithData:(NSData*)imageData {
    if (imageContainer) {
        if ([imageContainer respondsToSelector:@selector(updateImageData:sender:)]) {
            [imageContainer performSelector:@selector(updateImageData:sender:) 
								 withObject:imageData withObject:self];
        }
    } 
}

- (void)imageDownloadFailed:(NSError *)error {
	failedCount++;
    if (imageContainer) {
        if ([imageContainer respondsToSelector:@selector(imageDownloadFailed:sender:)]) {
            [imageContainer performSelector:@selector(imageDownloadFailed:sender:) withObject:error withObject:self];
        }
    }
}

- (void)setProgress:(float)_progress {
	if (progress != _progress) {
		progress = _progress;
		if (imageContainer) {
			if ([imageContainer respondsToSelector:@selector(setProgress:)]) {
				[imageContainer performSelector:@selector(setProgress:) withObject:[NSNumber numberWithFloat:progress]];
			}
		}		
	}
}

@end
