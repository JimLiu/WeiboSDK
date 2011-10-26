//
//  ImageConnection.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-4.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ImageRequest;

@protocol ImageRequestDelegate

- (void)imageRequestDidFailWithError:(NSError*)error sender:(ImageRequest*)request;

- (void)imageRequestDidSucceed:(UIImage*)image sender:(ImageRequest*)request;

@end


@interface ImageRequest : NSObject {
    int                 statusCode;
	int contentLength;
	NSURLConnection*    connection;
	NSMutableData*      buf;
	id<ImageRequestDelegate>                  delegate;
    NSString*           requestURL;
}

@property (nonatomic, readonly) NSMutableData* buf;
@property (nonatomic, assign) int statusCode;
@property (nonatomic, copy) NSString* requestURL;

- (id)initWithDelegate:(id<ImageRequestDelegate>)delegate;
- (void)get:(NSString*)URL;



@end
