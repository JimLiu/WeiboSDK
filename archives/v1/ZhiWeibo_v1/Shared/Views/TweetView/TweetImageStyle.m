//
//  TweetImageStyle.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-10-19.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "TweetImageStyle.h"


static TweetImageStyle* tweetStyle = nil;

@implementation TweetImageStyle


+ (TweetImageStyle *)sharedStyle {
	if (!tweetStyle) {
		tweetStyle = [[TweetImageStyle alloc]init];
	}
	return tweetStyle;
}

- (ImageCache*)getStyledImageCache:(NSString *)className {
	NSString *styledCacheName = [NSString stringWithFormat:@"styledImages/%@"
								 , className];
	return [ImageCache cacheWithName:styledCacheName];
}


- (UIImage *)processWithClassName:(NSString*)className 
				 forImage:(UIImage *)image {
	SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%@:", className]);
	UIImage * result = image;
	if ([self respondsToSelector:sel]) {
		result = [self performSelector:sel withObject:image];
	}
	return result;
}

- (UIImage *)getImageFromCacheByClassName:(NSString *)className 
						 withUrl:(NSString *)url {
	ImageCache *imageCache = [self getStyledImageCache:className];
	return [imageCache imageForURL:url];
	
}

/////////STYLE/////////

- (UIImage *)profileImageSmall:(UIImage*)image {
	if (!image) {
		return nil;
	}	
	UIImage *resultImage = image;
	resultImage = [resultImage resizeImageWithNewSize:CGSizeMake(24, 24)];
	resultImage = [resultImage imageWithRadius:2
										 width:24
										height:24];
	/*
	resultImage = [resultImage imageWithShadow:[UIColor grayColor]
									shadowSize:CGSizeZero
										  blur:2];
	 */
	return resultImage;
}

- (UIImage *)profileImageMiddle:(UIImage*)image {
	if (!image) {
		return nil;
	}	
	UIImage *resultImage = image;
	resultImage = [resultImage resizeImageWithNewSize:CGSizeMake(48, 48)];
	resultImage = [resultImage imageWithRadius:4
										 width:48
										height:48];
	resultImage = [resultImage imageWithShadow:[UIColor grayColor]
									shadowSize:CGSizeZero
										  blur:2];
	//[imageCache storeImage:resultImage forURL:url];
	return resultImage;
}

- (UIImage *)profileImageLarge:(UIImage*)image {
	if (!image) {
		return nil;
	}
	UIImage *resultImage = image;
	resultImage = [resultImage resizeImageWithNewSize:CGSizeMake(73, 73)];
	resultImage = [resultImage imageWithRadius:4
										 width:73
										height:73];
	return resultImage;
}

- (UIImage *)tweetImageSmall:(UIImage*)image {
	if (!image) {
		return nil;
	}
	UIImage *resultImage = image;
	resultImage = [resultImage thumbnailImage:60 interpolationQuality:kCGInterpolationDefault];
	resultImage = [resultImage imageWithRadius:4
										 width:60
										height:60];
	return resultImage;
}


@end
