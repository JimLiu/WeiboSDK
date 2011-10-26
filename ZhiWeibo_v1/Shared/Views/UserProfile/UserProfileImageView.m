//
//  UserProfileImageView.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-26.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "UserProfileImageView.h"

@interface UserProfileImageView (Private)

- (UIImage*)downloadImage;

@end


static UIImage *defaultProfileImage;

@implementation UserProfileImageView
@synthesize user;
@synthesize profileImageRect;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		profileImageRect = CGRectMake(10, 10, 52, 52);
		if (!defaultProfileImage) {
			defaultProfileImage = [[UIImage imageNamed:@"ProfilePlaceholderOverWhite.png"] retain];
		}
		downloader = [ImageDownloader downloaderWithName:@"profileImages"];
        _receiver = [[ImageDownloadReceiver alloc] init];
		_receiver.imageContainer = self;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		profileImageRect = CGRectMake(10, 10, 52, 52);
		if (!defaultProfileImage) {
			defaultProfileImage = [[UIImage imageNamed:@"ProfilePlaceholderOverWhite.png"] retain];
		}
		downloader = [ImageDownloader downloaderWithName:@"profileImages"];
        _receiver = [[ImageDownloadReceiver alloc] init];
		_receiver.imageContainer = self;		
	}
	return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    _receiver.imageContainer = nil;
    [downloader removeDelegate:_receiver forURL:user.profileImageUrl];
    [_receiver release];
	[profileImage release];
	[user release];
    [super dealloc];
}


- (void)setUser:(User *)value {
	if (user != value) {
		if (user)
			[downloader removeDelegate:_receiver forURL:user.profileImageUrl];
		[user release];
		user = [value retain];
		[profileImage release];
		profileImage = [[self downloadImage] retain];
		[self setNeedsDisplay];
	}
}

- (UIImage*)processStyle:(UIImage*)_image {
	if (!_image) {
		return _image;
	}
	
	return [[TweetImageStyle sharedStyle] processWithClassName:@"profileImageMiddle"
													  forImage:_image];
}

- (UIImage *)getImageFromStyledImageCache {
	return [[TweetImageStyle sharedStyle] getImageFromCacheByClassName:@"profileImageMiddle"
															  withUrl:user.profileImageUrl];
}

- (UIImage*)downloadImage {
	
	if (nil != user && user.profileImageUrl && user.profileImageUrl.length > 0) {
		UIImage *cachedImage = [self getImageFromStyledImageCache];
		if (!cachedImage) {
			cachedImage = [[ImageDownloader downloaderWithName:@"profileImages"] 
						   getImage:user.profileImageUrl delegate:_receiver];
			if (cachedImage) {
				//cachedImage = [self processStyle:cachedImage];
				TweetImageStyle *style = [TweetImageStyle sharedStyle];
				ImageCache *styleCache = [style getStyledImageCache:@"profileImageMiddle"];
				UIImage *styledImage = [styleCache imageForURL:user.profileImageUrl];
				if (styledImage) {
					cachedImage = styledImage;
				}
				else {
					cachedImage = [self processStyle:cachedImage];
					[styleCache storeImage:cachedImage forURL:user.profileImageUrl];
				}
			}
		}
		return cachedImage;
	} 
	return nil;
	
}


- (void)updateImage:(UIImage *)image sender:(ImageDownloadReceiver *)receiver {
	[profileImage release];
	profileImage = [image retain];
	[self setNeedsDisplayInRect:self.profileImageRect];
}

- (void)drawRect:(CGRect)rect {
	
	UIImage* image = profileImage;//
	if (!image) {
		image = defaultProfileImage;
	}
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSaveGState(ctx);
	CGContextAddRect(ctx, self.profileImageRect);
	CGContextClip(ctx);
	[image drawInRect:self.profileImageRect];
	CGContextRestoreGState(ctx);
	
}


@end
