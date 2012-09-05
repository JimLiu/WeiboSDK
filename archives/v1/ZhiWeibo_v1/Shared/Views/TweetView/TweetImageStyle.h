//
//  TweetImageStyle.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-10-19.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageCache.h"
#import "UIImage+Alpha.h"
#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"

@interface TweetImageStyle : NSObject {

}

+ (TweetImageStyle *)sharedStyle;

- (ImageCache*)getStyledImageCache:(NSString *)className;

- (UIImage *)getImageFromCacheByClassName:(NSString *)className 
						 withUrl:(NSString *)url;

- (UIImage *)processWithClassName:(NSString*)className 
					   forImage:(UIImage *)image;

@end
