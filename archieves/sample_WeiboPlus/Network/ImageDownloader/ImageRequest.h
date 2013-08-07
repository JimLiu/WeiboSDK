//
//  ImageRequest.h
//  helloWeibo
//
//  Created by junmin liu on 11-4-20.
//  Copyright 2011年 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ImageCache.h"

@interface ImageRequest : NSObject {
    ASIHTTPRequest *_request;
    NSMutableArray *_delegates;
    NSString *_url;
    NSString *_downloadPath;
    
    float progress;
	float max;
    
    id _imageRequestDelegate;
	ImageCache *_imageCache;
}

@property (nonatomic, retain) NSString *url;
@property (nonatomic, assign) id imageRequestDelegate;
@property (nonatomic, assign) ImageCache *imageCache;

@property (nonatomic, assign) float progress;
@property (nonatomic, assign) float max;

- (BOOL)inProgress;

- (id)initWithUrl:(NSString *)url;

- (void)addDelegate:(id)delegate;

- (void)removeDelegate:(id)delegate;

- (void)startDownload;

- (void)cancelDownload;

- (void)clearDelegates;

@end
