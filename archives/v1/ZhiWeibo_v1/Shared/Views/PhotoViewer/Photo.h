//
//  Photo.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-5.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Status.h"

@interface Photo : NSObject {
	NSString *URL;
	NSString *originalURL;
	NSString *caption;
	CGSize size;
	UIImage *image;
	BOOL failed;
}

+ (Photo*)photoWithURL:(NSString*)url;

+ (Photo*)photoWithStatus:(Status*)status;

/*
 * URL of the image, varied URL size should set according to display size. 
 */
@property(nonatomic,copy) NSString *URL;

@property(nonatomic,copy) NSString *originalURL;

/*
 * The caption of the image.
 */
@property(nonatomic,copy) NSString *caption;

/*
 * Size of the image, CGRectZero if image is nil.
 */
@property(nonatomic, assign) CGSize size;

/*
 * The image after being loaded, or local.
 */
@property(nonatomic,retain) UIImage *image;

/*
 * Returns true if the image failed to load.
 */
@property(nonatomic,assign) BOOL failed;


@end
