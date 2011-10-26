//
//  UserABTableViewCell.m
//  ZhiWeibo
//
//  Created by junmin liu on 11-1-3.
//  Copyright 2011 Openlab. All rights reserved.
//

#import "UserABTableViewCell.h"


@interface UserABTableViewCell (Private)

- (UIImage*)downloadProfileImage;

@end

static UIImage *defaultProfileImage;

@implementation UserABTableViewCell
@synthesize user;
@synthesize profileImageRect;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier])) {
        // Initialization code
		profileImageRect = CGRectMake(10, 10, 52, 52);
		downloader = [ImageDownloader downloaderWithName:@"profileImages"];
		if (!defaultProfileImage) {
			defaultProfileImage = [[UIImage imageNamed:@"ProfilePlaceholderOverWhite.png"] retain];
		}
		_receiver = [[ImageDownloadReceiver alloc] init];
		_receiver.imageContainer = self;
    }
    return self;
}

- (void)dealloc {
	_receiver.imageContainer = nil;
    [downloader removeDelegate:_receiver forURL:user.profileImageUrl];
    [_receiver release];
	[user release];
	[profileImage release];
	[super dealloc];
}

- (void)setUser:(User *)value {
	if (user != value) {
		if (user)
			[downloader removeDelegate:_receiver forURL:user.profileImageUrl];
		[user release];
		user = [value retain];
		[profileImage release];
		profileImage = [[self downloadProfileImage] retain];
		if (profileImage == nil) {
			self.imageView.image = defaultProfileImage;
		}
		else {
			self.imageView.image = profileImage;
		}
		self.textLabel.text = user.screenName;
		self.detailTextLabel.text = user.description;
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
	return [[TweetImageStyle sharedStyle]getImageFromCacheByClassName:@"profileImageMiddle"
															  withUrl:user.profileImageUrl];
}

- (UIImage*)downloadProfileImage {
	
	if (nil != user && user.profileImageUrl && user.profileImageUrl.length > 0) {
		UIImage *cachedImage = [self getImageFromStyledImageCache];
		if (!cachedImage) {
			cachedImage = [downloader 
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
	if (!image) {
		return;
	}
	[profileImage release];
	profileImage = [[self processStyle:image] retain];
	[self setNeedsDisplay];
}

- (void)imageDownloadFailed:(NSError *)error sender:(ImageDownloadReceiver *)receiver {
	if (receiver.failedCount < 3) {
		[self downloadProfileImage];
		NSLog(@"retry download profile image:%d", receiver.failedCount);
	}
}

- (void)drawContentView:(CGRect)rect highlighted:(BOOL)highlighted {
	
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
