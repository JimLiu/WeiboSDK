//
//  HotStatusesView.m
//  ZhiWeibo
//
//  Created by Zhang Jason on 1/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HotStatusesView.h"
#import "TweetImageStyle.h"
#import "ImageDownloader.h"
#import "ImageDownloadReceiver.h"

@interface HotStatusesView (Private)

- (UIImage*)downloadProfileImage;

@end


@implementation HotStatusesView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
		downloader = [ImageDownloader downloaderWithName:@"profileImages"];
		if (!defaultProfileImage) {
			defaultProfileImage = [[UIImage imageNamed:@"ProfilePlaceholderOverWhite.png"] retain];
		}
		_receiver = [[ImageDownloadReceiver alloc] init];
		_receiver.imageContainer = self;
		profileImageRect = CGRectMake(10, 8, 56, 56);
		textRect = CGRectMake(76, 8, 170, 60);
		self.backgroundColor = [UIColor whiteColor];
		
		textFont = [UIFont systemFontOfSize:12];
    }
    return self;
}

- (void)setStatus:(Status *)_status {
	[status release];
	status = _status;
	[profileImage release];
	profileImage = nil;
	[self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
	UIImage* image = profileImage;//
	if (!image) {
		image = [self downloadProfileImage];
		if (!image) {
			image = defaultProfileImage;
		}
	}
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSaveGState(ctx);
	CGContextAddRect(ctx, profileImageRect);
	CGContextClip(ctx);
	[image drawInRect:profileImageRect];
	CGContextRestoreGState(ctx);
	
	CGSize nameSize = [status.user.screenName drawInRect:textRect withFont:[UIFont boldSystemFontOfSize:12]];
	//NSLog(@"%@",NSStringFromCGSize(nameSize));
	CGRect contentRect = CGRectMake(textRect.origin.x, textRect.origin.y + nameSize.height, textRect.size.width, textRect.size.height - nameSize.height);
	CGFloat remainWidth = textRect.size.width - nameSize.width - 10;
	if (remainWidth > 50) {
		NSRange range = NSMakeRange(0, 1);
		while ((range.length < status.text.length) && ([[status.text substringWithRange:range] sizeWithFont:textFont].width <= remainWidth)) {
			range = NSMakeRange(0, (range.length)+1);
		}
		range = NSMakeRange(0, (range.length)-1);
		[[status.text substringWithRange:range] drawInRect:CGRectMake(textRect.origin.x + nameSize.width + 10, textRect.origin.y, remainWidth, nameSize.height) withFont:textFont];
		
		range = NSMakeRange(range.length, 0);
		while ((range.length + range.location < status.text.length) && ([[status.text substringWithRange:range] sizeWithFont:textFont constrainedToSize:CGSizeMake(contentRect.size.width, 1000)].height <= contentRect.size.height)) {
			range = NSMakeRange(range.location, (range.length)+1);
		}
		//NSLog(@"%@",[status.text substringWithRange:range]);
		if (range.location + range.length == status.text.length) {
			[[status.text substringWithRange:range] drawInRect:contentRect withFont:textFont];
		}
		else {
			range = NSMakeRange(range.location, (range.length) - 4);
			[[NSString stringWithFormat:@"%@...",[status.text substringWithRange:range]] drawInRect:contentRect withFont:textFont];
		}

	}
}


- (void)dealloc {
    [super dealloc];
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
															  withUrl:status.user.profileImageUrl];
}

- (UIImage*)downloadProfileImage {
	
	if (nil != status.user && status.user.profileImageUrl && status.user.profileImageUrl.length > 0) {
		UIImage *cachedImage = [self getImageFromStyledImageCache];
		if (!cachedImage) {
			cachedImage = [downloader 
						   getImage:status.user.profileImageUrl delegate:_receiver];
			if (cachedImage) {
				//cachedImage = [self processStyle:cachedImage];
				TweetImageStyle *style = [TweetImageStyle sharedStyle];
				ImageCache *styleCache = [style getStyledImageCache:@"profileImageMiddle"];
				UIImage *styledImage = [styleCache imageForURL:status.user.profileImageUrl];
				if (styledImage) {
					cachedImage = styledImage;
				}
				else {
					cachedImage = [self processStyle:cachedImage];
					[styleCache storeImage:cachedImage forURL:status.user.profileImageUrl];
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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"HotStatusSelected" object:status];
}

@end
