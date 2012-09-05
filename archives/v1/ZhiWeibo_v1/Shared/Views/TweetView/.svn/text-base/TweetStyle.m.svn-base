//
//  TweetStyle.m
//  TweetViewDemo
//
//  Created by junmin liu on 10-10-15.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "TweetStyle.h"

#import "TweetImageFrame.h"
#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"

static TweetStyle* tweetStyle = nil;

@implementation TweetStyle

- (id)init {
	if (self = [super init]) {
	}
	return self;
}


+ (TweetStyle *)sharedStyle {
	if (!tweetStyle) {
		tweetStyle = [[TweetStyle alloc]init];
	}
	return tweetStyle;
}

- (void)dealloc {
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)processWithClassName:(NSString*)className object:(id)sender {
	SEL sel = NSSelectorFromString(className);
	id result = nil;
	if ([self respondsToSelector:sel]) {
		result = [self performSelector:sel withObject:sender];
	}
	return result;
}


- (UIImage*)resizeImage:(UIImage*)image maxResolution:(float)numPixels
{
    // Resize image if needed.
    float width  = image.size.width;
    float height = image.size.height;
    // fail safe
    if (width == 0 || height == 0) return image;
    
    float scale;
	
    if (width > numPixels || height > numPixels) {
        if (width > height) {
            scale = numPixels / height;
            width *= scale;
            height = numPixels;
        }
        else {
            scale = numPixels / width;
            height *= scale;
            width = numPixels;
        }
        UIGraphicsBeginImageContext(CGSizeMake(numPixels, numPixels));
        [image drawInRect:CGRectMake(0 - (width - numPixels) / 2, 0 - (height - numPixels) / 2, width, height)];
		
        UIImage *resized = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //NSData *jpeg = UIImageJPEGRepresentation(image, 0.8);
        return resized;
    }
    return image;
}

- (UIImage*)convertImage:(UIImage*)image 
		   maxResolution:(float)numPixels
				  radius:(float) radius
{
	
	image = [self resizeImage:image maxResolution:numPixels];
    UIGraphicsBeginImageContext(CGSizeMake(numPixels, numPixels));
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(c);
    CGContextMoveToPoint  (c, numPixels, numPixels/2);
    CGContextAddArcToPoint(c, numPixels, numPixels, numPixels/2, numPixels,   radius);
    CGContextAddArcToPoint(c, 0,         numPixels, 0,           numPixels/2, radius);
    CGContextAddArcToPoint(c, 0,         0,         numPixels/2, 0,           radius);
    CGContextAddArcToPoint(c, numPixels, 0,         numPixels,   numPixels/2, radius);
    CGContextClosePath(c);
    
    CGContextClip(c);
	
    [image drawAtPoint:CGPointZero];
    UIImage *converted = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return converted;
}

-(UIImage *)processProfileImage:(UIImage *)pImage {
	UIImage *_image = [self resizeImage:pImage maxResolution:48];
	_image = [self convertImage:_image maxResolution:48 radius:6];

	CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef shadowContext = CGBitmapContextCreate(NULL, _image.size.width + 4, _image.size.height + 4, CGImageGetBitsPerComponent(_image.CGImage), 0, 
													   colourSpace, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colourSpace);
	
    CGContextSetShadowWithColor(shadowContext, CGSizeMake(0, 0), 4, [UIColor grayColor].CGColor);
    CGContextDrawImage(shadowContext, CGRectMake(2, 2, _image.size.width, _image.size.height), _image.CGImage);
	
    CGImageRef shadowedCGImage = CGBitmapContextCreateImage(shadowContext);
    CGContextRelease(shadowContext);
	
    UIImage * shadowedImage = [UIImage imageWithCGImage:shadowedCGImage];
    CGImageRelease(shadowedCGImage);
	
    return shadowedImage;	
}

-(UIImage *)profileImage:(UIImage*)image {
	UIImage* _image = [self processProfileImage:image]; // node.image;
	return _image;
}

@end
