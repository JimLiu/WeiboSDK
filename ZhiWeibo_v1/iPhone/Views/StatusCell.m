//
//  StatusCell.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-21.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "StatusCell.h"
#import "UIImage+Alpha.h"

@interface StatusCell (Private)

- (UIImage*)downloadProfileImage;
- (UIImage*)downloadPhotoImage;

@end

static UIImage * gDefaultProfileImage;
static UIImage * gDefaultPhotoImage;
static UIImage * gRetweetBackgroundImage;

@implementation StatusCell
@synthesize status;

+ (UIImage *) defaultProfileImage {
	if (!gDefaultProfileImage) {
		gDefaultProfileImage = [[UIImage imageNamed:@"ProfilePlaceholderOverWhite.png"] retain];
	}
	return gDefaultProfileImage;
}

+ (UIImage *)defaultPhotoImage {
	if (!gDefaultPhotoImage) {
		gDefaultPhotoImage = [[UIImage imageNamed:@"TweetImageloading.png"] retain];
	}
	return gDefaultPhotoImage;
}

+ (UIImage *)retweetBackgroundImage {
	if (!gRetweetBackgroundImage) {
		gRetweetBackgroundImage = [[[UIImage imageNamed:@"retweet_bg.png"] stretchableImageWithLeftCapWidth:32 topCapHeight:16] retain];
	}
	return gRetweetBackgroundImage;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier])) {
        // Initialization code
		
		profileDownloader = [ImageDownloader downloaderWithName:@"profileImages"];
		photoDownloader = [ImageDownloader downloaderWithName:@"tweetImages"]; 
		profileReceiver = [[ImageDownloadReceiver alloc] init];
		profileReceiver.imageContainer = self;
		photoReceiver = [[ImageDownloadReceiver alloc]init];
		photoReceiver.imageContainer = self;
    }
    return self;
}

- (NSString *)getStatusPhotoUrl {
	NSString *photoUrl = status.retweetedStatus ? status.retweetedStatus.thumbnailPic : status.thumbnailPic;
	return photoUrl;
}

- (void)dealloc {
	NSString *photoUrl = [self getStatusPhotoUrl];
	profileReceiver.imageContainer = nil;
	photoReceiver.imageContainer = nil;
    [profileDownloader removeDelegate:profileReceiver forURL:status.user.profileImageUrl];
	[photoDownloader removeDelegate:photoReceiver forURL:photoUrl];
    [profileReceiver release];
	[photoReceiver release];
	[status release];
	[profileImage release];
	profileImage = nil;
	[photoImage release];
	photoImage = nil;
	[super dealloc];
}

- (void)setNeedsDisplay {
	[super setNeedsDisplay];
	[selectedContentView setNeedsDisplay];
	[contentView setNeedsDisplay];
}

- (void)setStatus:(Status*)_status {
	if (status != _status) {
		NSString *photoUrl = [self getStatusPhotoUrl];
		[profileDownloader removeDelegate:profileReceiver forURL:status.user.profileImageUrl];
		[photoDownloader removeDelegate:photoReceiver forURL:photoUrl];
		[status release];
		status = [_status retain];
		[profileImage release];
		profileImage = nil;
		[photoImage release];
		photoImage = nil;
		[self setNeedsDisplay];
	}
}

- (void)drawContentView:(CGRect)rect highlighted:(BOOL)highlighted {
	CGFloat width = self.frame.size.width;
	StatusLayout *layout = [StatusLayout layoutWithStatus:status width:width];
	
	if (rect.origin.x == layout.photoImageBounds.origin.x
		&& rect.origin.y == layout.photoImageBounds.origin.y
		&& rect.size.width == layout.photoImageBounds.size.width
		&& rect.size.height == layout.photoImageBounds.size.height) {
		NSString *photoUrl = [self getStatusPhotoUrl];
		if (photoUrl && photoUrl.length > 0) {
			//photoReceiver.displayRect = layout.photoImageBounds;
			if (photoImage != nil) {
				[photoImage drawInRect:layout.photoImageBounds];
			}
		}
	}
	else if (rect.origin.x == layout.profileImageBounds.origin.x
			 && rect.origin.y == layout.profileImageBounds.origin.y
			 && rect.size.width == layout.profileImageBounds.size.width
			 && rect.size.height == layout.profileImageBounds.size.height) {
		if (profileImage != nil) {
			[profileImage drawInRect:layout.profileImageBounds];	
		}
	}
	else {
		UIColor* textColor;
		UIColor* timestampColor;
		
		static UIImage *cellBackgroundImage;
		static UIImage *cellSelectedBackgroundImage;
		
		if (!cellBackgroundImage) {
			cellBackgroundImage = [[UIImage imageNamed:@"cell-shadow.png"] retain];
		}
		if (!cellSelectedBackgroundImage) {
			cellSelectedBackgroundImage = [[UIImage imageNamed:@"TableBlueSelectionGradient.png"] retain];
		}
		
		if (highlighted) {
			textColor       = [UIColor whiteColor];
			timestampColor  = [UIColor lightGrayColor];
			[cellSelectedBackgroundImage drawInRect:rect];
		}
		else {
			textColor       = [UIColor blackColor];
			timestampColor  = [UIColor grayColor];
			[cellBackgroundImage drawInRect:CGRectMake(0, rect.size.height - 20, rect.size.width, 20)];
		}
		
		profileReceiver.displayRect = layout.profileImageBounds;
		if (!profileImage) {
			profileImage = [[self downloadProfileImage] retain];
		}
		if (profileImage == nil) {
			[[StatusCell defaultProfileImage] drawInRect:layout.profileImageBounds];
		}
		else {
			[profileImage drawInRect:layout.profileImageBounds];
		}
		
		float textFontSize = 15;
		[textColor set];
		[status.user.screenName drawInRect:layout.screenNameBounds withFont:[UIFont boldSystemFontOfSize:15]];
		[status.text drawInRect:layout.textBounds withFont:[UIFont systemFontOfSize:textFontSize]];
		
		if (status.retweetedStatus) {
			NSString *text = [NSString stringWithFormat:@"%@: %@", status.retweetedStatus.user.screenName, status.retweetedStatus.text];
			[[StatusCell retweetBackgroundImage] drawInRect:layout.retweetBackgroundBounds];
			[text drawInRect:layout.retweetTextBounds withFont:[UIFont systemFontOfSize:15]];
			//retweetCommentsBounds
			if (status.retweetedStatus.commentsCount >= 0) {
				NSString *retweetedStatusRetweetsCountText = status.retweetedStatus.retweetsCount > 0 ? [NSString stringWithFormat:@"原文转发(%d)", status.retweetedStatus.retweetsCount] : @"原文转发";
				NSString *retweetedStatusCommentsCountText = status.retweetedStatus.commentsCount > 0 ? [NSString stringWithFormat:@"原文评论(%d)", status.retweetedStatus.commentsCount] : @"原文评论";
				NSString *retweetedStatusComments = [NSString stringWithFormat:@"%@  |  %@", retweetedStatusRetweetsCountText, retweetedStatusCommentsCountText];
				[timestampColor set];
				[retweetedStatusComments drawInRect:layout.retweetCommentsBounds withFont:[UIFont systemFontOfSize:13]
									  lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];					
			}
		}
		
		NSString *photoUrl = [self getStatusPhotoUrl];
		if (photoUrl && photoUrl.length > 0) {
			//photoReceiver.displayRect = layout.photoImageBounds;
			if (!photoImage) {
				photoImage = [[self downloadPhotoImage] retain];
			}
			if (photoImage == nil) {
				[[StatusCell defaultPhotoImage] drawInRect:layout.photoImageBounds];
			}
			else {
				[photoImage drawInRect:layout.photoImageBounds];
			}			
		}
		
		[timestampColor set];
		
		[status.timestamp drawInRect:layout.timestampBounds withFont:[UIFont systemFontOfSize:13]
					   lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentRight];
		NSString *source = [NSString stringWithFormat:@"来自 %@", status.source];
		[source drawInRect:layout.sourceBounds withFont:[UIFont systemFontOfSize:13]];
		
		if (status.commentsCount >= 0) {
			NSString *retweetsCountText = status.retweetsCount > 0 ? [NSString stringWithFormat:@"转发(%d)", status.retweetsCount] : @"转发";
			NSString *commentsCountText = status.commentsCount > 0 ? [NSString stringWithFormat:@"评论(%d)", status.commentsCount] : @"评论";
			NSString *comments = [NSString stringWithFormat:@"%@  |  %@", retweetsCountText, commentsCountText];
			
			[comments drawInRect:layout.commentsBounds withFont:[UIFont systemFontOfSize:13]
				   lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentRight];		
		}
	}
}


- (UIImage*)processProfileImageStyle:(UIImage*)_image {
	if (!_image) {
		return _image;
	}
	
	return [[TweetImageStyle sharedStyle] processWithClassName:@"profileImageSmall"
													  forImage:_image];
}

- (UIImage *)getProfileImageFromStyledImageCache {
	return [[TweetImageStyle sharedStyle]getImageFromCacheByClassName:@"profileImageSmall"
															  withUrl:status.user.profileImageUrl];
}

- (UIImage*)downloadProfileImage {
	User *user = status.user;
	if (nil != user && user.profileImageUrl && user.profileImageUrl.length > 0) {
		UIImage *cachedImage = [self getProfileImageFromStyledImageCache];
		if (!cachedImage) {
			cachedImage = [profileDownloader getImage:user.profileImageUrl delegate:profileReceiver];
			if (cachedImage) {
				//cachedImage = [self processStyle:cachedImage];
				TweetImageStyle *style = [TweetImageStyle sharedStyle];
				ImageCache *styleCache = [style getStyledImageCache:@"profileImageSmall"];
				UIImage *styledImage = [styleCache imageForURL:user.profileImageUrl];
				if (styledImage) {
					cachedImage = styledImage;
				}
				else {
					cachedImage = [self processProfileImageStyle:cachedImage];
					[styleCache storeImage:cachedImage forURL:user.profileImageUrl];
				}
			}
		}
		return cachedImage;
	} 
	return nil;
	
}


- (UIImage*)processPhotoImageStyle:(UIImage*)_image {
	if (!_image) {
		return _image;
	}
	
	return [[TweetImageStyle sharedStyle] processWithClassName:@"tweetImageSmall"
													  forImage:_image];
}

- (UIImage *)getPhotoImageFromStyledImageCache:(NSString *)photoUrl {
	return [[TweetImageStyle sharedStyle]getImageFromCacheByClassName:@"tweetImageSmall"
															  withUrl:photoUrl];
}

- (UIImage*)downloadPhotoImage {
	NSString *photoUrl = [self getStatusPhotoUrl];
	if (photoUrl && photoUrl.length > 0) {
		UIImage *cachedImage = [self getPhotoImageFromStyledImageCache:photoUrl];
		if (!cachedImage) {
			cachedImage = [photoDownloader getImage:photoUrl delegate:photoReceiver];
			if (cachedImage) {
				TweetImageStyle *style = [TweetImageStyle sharedStyle];
				ImageCache *styleCache = [style getStyledImageCache:@"tweetImageSmall"];
				UIImage *styledImage = [styleCache imageForURL:photoUrl];
				if (styledImage) {
					cachedImage = styledImage;
				}
				else {
					cachedImage = [self processPhotoImageStyle:cachedImage];
					[styleCache storeImage:cachedImage forURL:photoUrl];
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
	
	if (receiver == profileReceiver) {
		image = [self processProfileImageStyle:image];
		[profileImage release];
		profileImage = [image retain];
	}
	else if (receiver == photoReceiver) {
		image = [self processPhotoImageStyle:image];
		[photoImage release];
		photoImage = [image retain];
	}

	CGRect rect = receiver.displayRect;
	if (rect.size.width > 0 && rect.size.height > 0) {
		[self setNeedsDisplayInRect:receiver.displayRect];
	}
	else {
		CGFloat width = self.frame.size.width;
		StatusLayout *layout = [StatusLayout layoutWithStatus:status width:width];
		[self setNeedsDisplayInRect:layout.photoImageBounds];
	}
}

- (void)imageDownloadFailed:(NSError *)error sender:(ImageDownloadReceiver *)receiver {
	if (receiver == profileReceiver) {
		if (receiver.failedCount < 3) {
			[self downloadProfileImage];
			NSLog(@"retry download profile image:%d", receiver.failedCount);
		}
	}
	else if (receiver == photoReceiver) {
		if (receiver.failedCount < 3) {
			[self downloadPhotoImage];
			NSLog(@"retry download photo image:%d", receiver.failedCount);
		}	
	}
	
}

@end
