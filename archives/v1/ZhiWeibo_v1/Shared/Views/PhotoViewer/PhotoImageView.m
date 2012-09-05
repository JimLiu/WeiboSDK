//
//  PhotoImageView.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-5.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "PhotoImageView.h"
#import "PhotoScrollView.h"
#import "ZhiWeiboAppDelegate.h"

#define ZOOM_VIEW_TAG 101
#define EGOPV_MAX_POPOVER_SIZE CGSizeMake(480.0f, 480.0f)
#define EGOPV_MIN_POPOVER_SIZE CGSizeMake(320.0f, 320.0f)

@interface PhotoImageView (Private)
- (void)layoutScrollViewAnimated:(BOOL)animated;
- (CABasicAnimation*)fadeAnimation;
@end

@implementation PhotoImageView
@synthesize photo=_photo;
@synthesize imageView=_imageView;
@synthesize scrollView=_scrollView;
@synthesize loading=_loading;
@synthesize photoImageViewDelegate;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
		self.backgroundColor = [UIColor colorWithWhite:0xF5/255.0F alpha:1];//[UIColor blackColor];
		self.userInteractionEnabled = NO; // this will get set when the image is loaded/set
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.clipsToBounds = YES;
		_scrollView = [[PhotoScrollView alloc] initWithFrame:self.bounds];
		//_scrollView.backgroundColor = [UIColor blackColor];
		_scrollView.delegate = self;
		[self addSubview:_scrollView];
		
		_imageView = [[UIImageView alloc] initWithFrame:self.bounds];
		_imageView.contentMode = UIViewContentModeScaleAspectFit;
		_imageView.tag = ZOOM_VIEW_TAG;
		[_scrollView addSubview:_imageView];
		
		_activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		
		_progressView = [[UIProgressView alloc]initWithFrame:CGRectMake((self.frame.size.width - 225.0F) / 2.0F, self.frame.size.height - 120.0f, 225.0f, 90.0f)];
		[_progressView setProgressViewStyle: UIProgressViewStyleBar];
		[self addSubview:_progressView];
		[_progressView release];
		_progressView.hidden = YES;
		
		CGFloat offset = 80.0f;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			offset=120.0f;
		}
#endif
		_activityView.center = CGPointMake(self.frame.size.width / 2.0F, self.frame.size.height / 2.0F);
		//_activityView.frame = CGRectMake((CGRectGetWidth(self.frame) / 2) - 11.0f, (CGRectGetHeight(self.frame) / 2) + offset , 22.0f, 22.0f);
		//_activityView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
		[self addSubview:_activityView];
		[_activityView release];
		
		downloader = [ImageDownloader downloaderWithName:@"tweetImages"];		
	}
    return self;
}

- (void)layoutSubviews{
	[super layoutSubviews];
	_activityView.center = CGPointMake(self.frame.size.width / 2.0F, self.frame.size.height / 2.0F);
	_progressView.frame = CGRectMake((self.frame.size.width - 225.0F) / 2.0F, self.frame.size.height - 120.0f, 225.0f, 90.0f);
	if (_scrollView.zoomScale == 1.0f) {
		[self layoutScrollViewAnimated:YES];
	}
	
}

- (BOOL)isGif {
	return [photoUrl hasSuffix:@".gif"];
}

- (void)loadImageView {
	BOOL isLoading = NO;
	[self.imageView setAnimationImages:nil];
	if (self.photo.image) {
		self.imageView.image = self.photo.image;
	} 
	else {
		UIImage *_image = [downloader getImage:photoUrl delegate:_receiver];
		if (_image) {
			self.imageView.image = _image;
			if ([self isGif]) {
				NSData *imageData = [downloader getImageData:photoUrl];
				if (imageData) {
					AnimatedGif *gif = [[AnimatedGif alloc]init];
					[gif decodeGIF:imageData];
					[gif setAnimationImageView:_imageView];
					[gif release];
				}
			}
		}
		else {
			isLoading = YES;
		}

	}
	
	if (!isLoading) {
		
		[_activityView stopAnimating];
		self.userInteractionEnabled = YES;
		_progressView.hidden = YES;
		
		_loading=NO;
	} else {
		
		_loading = YES;
		[_activityView startAnimating];
		self.userInteractionEnabled= NO;
		_progressView.hidden = NO;
		//self.imageView.image = nil;
	}
	
	[self layoutScrollViewAnimated:NO];
}

- (void)setPhoto:(Photo*)aPhoto{
	
	if (!aPhoto) 
		return; 
	if ([aPhoto isEqual:self.photo]) return;
	
	if (_photo != nil) {
		[downloader removeDelegate:_receiver forURL:_photo.URL];
		[downloader removeDelegate:_receiver forURL:_photo.originalURL];
		[_receiver release];
		_receiver = nil;
	}
	
	[_photo release], _photo = nil;
	_photo = [aPhoto retain];
	_receiver = [[ImageDownloadReceiver alloc] init];
	_receiver.imageContainer = self;
	
	[photoUrl release];
	photoUrl = [_photo.URL retain];

	[self.imageView setImage:nil];
	[self loadImageView];

}

- (void)loadPhoto {
	[photoUrl release];
	photoUrl = [_photo.URL retain];
	
	[self loadImageView];
}

- (void)loadOriginalPhoto {
	if (photoUrl != _photo.originalURL) {
		if (_photo != nil) {
			[downloader removeDelegate:_receiver forURL:photoUrl];
		}
		
		[photoUrl release];
		photoUrl = [_photo.originalURL retain];
		
		[self loadImageView];		
	}
}

- (void)setupImageViewWithImage:(UIImage*)theImage {	
	
	_loading = NO;
	[_activityView stopAnimating];
	_progressView.hidden = YES;
	self.imageView.image = theImage; 
	[self.imageView setAnimationImages:nil];
	[self layoutScrollViewAnimated:NO]; 
	
	[[self layer] addAnimation:[self fadeAnimation] forKey:@"opacity"];
	self.userInteractionEnabled = YES;
	
}

- (void)prepareForReusue{
	
	//  reset view
	self.tag = -1;
	
}


- (void)setProgress:(NSNumber*)progressNumber {
	float _progress = [progressNumber floatValue];
	if (_progressView.progress != _progress) {
		_progressView.progress = _progress;
		//NSLog(@"set Progress:%f",_progress);
	}
}

#pragma mark -
#pragma mark Touches

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (photoImageViewDelegate) {
		[photoImageViewDelegate touch];
	}
}

#pragma mark -
#pragma mark Layout

- (void)rotateToOrientation:(UIInterfaceOrientation)orientation{
	
	if (self.scrollView.zoomScale > 1.0f) {
		
		CGFloat height, width;
		height = MIN(CGRectGetHeight(self.imageView.frame) + self.imageView.frame.origin.x, CGRectGetHeight(self.bounds));
		width = MIN(CGRectGetWidth(self.imageView.frame) + self.imageView.frame.origin.y, CGRectGetWidth(self.bounds));
		self.scrollView.frame = CGRectMake((self.bounds.size.width / 2) - (width / 2), (self.bounds.size.height / 2) - (height / 2), width, height);
		
	} else {
		[self layoutScrollViewAnimated:NO];
	}
}

- (void)layoutScrollViewAnimated:(BOOL)animated{
	
	if (animated) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.0001];
	}
	
	CGFloat hfactor = self.imageView.image.size.width / self.frame.size.width;
	CGFloat vfactor = self.imageView.image.size.height / self.frame.size.height;
	
	CGFloat factor = MAX(hfactor, vfactor);
	if (factor == 0) {
		factor = 1;
	}
	
	CGFloat newWidth = self.imageView.image.size.width / factor;
	CGFloat newHeight = self.imageView.image.size.height / factor;
	
	CGFloat leftOffset = (self.frame.size.width - newWidth) / 2;
	CGFloat topOffset = (self.frame.size.height - newHeight) / 2;
	
	CGRect frame = CGRectMake(leftOffset, topOffset, newWidth, newHeight);
	self.scrollView.frame = frame;
	self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
	self.scrollView.contentOffset = CGPointMake(0.0f, 0.0f);
	self.imageView.frame = self.scrollView.bounds;
	
	if (animated) {
		[UIView commitAnimations];
	}
}

- (CGSize)sizeForPopover{
	
	CGSize popoverSize = EGOPV_MAX_POPOVER_SIZE;
	
	if (!self.imageView.image) {
		return popoverSize;
	}
	
	CGSize imageSize = self.imageView.image.size;
	
	if(imageSize.width > popoverSize.width || imageSize.height > popoverSize.height) {
		
		if(imageSize.width > imageSize.height) {
			popoverSize.height = floorf((popoverSize.width * imageSize.height) / imageSize.width);
		} else {
			popoverSize.width = floorf((popoverSize.height * imageSize.width) / imageSize.height);
		}
		
	} else {
		
		popoverSize = imageSize;
		
	}
	
	if (popoverSize.width < EGOPV_MIN_POPOVER_SIZE.width || popoverSize.height < EGOPV_MIN_POPOVER_SIZE.height) {
		
		CGFloat hfactor = popoverSize.width / EGOPV_MIN_POPOVER_SIZE.width;
		CGFloat vfactor = popoverSize.height / EGOPV_MIN_POPOVER_SIZE.height;
		
		CGFloat factor = MAX(hfactor, vfactor);
		
		CGFloat newWidth = popoverSize.width / factor;
		CGFloat newHeight = popoverSize.height / factor;
		
		popoverSize.width = newWidth;
		popoverSize.height = newHeight;
		
	} 
	
	
	return popoverSize;
	
}


#pragma mark -
#pragma mark Animation

- (CABasicAnimation*)fadeAnimation{
	
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	animation.fromValue = [NSNumber numberWithFloat:0.0f];
	animation.toValue = [NSNumber numberWithFloat:1.0f];
	animation.duration = .3f;
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	
	return animation;
}


#pragma mark -
#pragma mark ImageReceiver Callbacks

- (void)updateImageData:(NSData *)imageData sender:(ImageDownloadReceiver *)receiver {
	if (imageData) {
		if ([self isGif]) {
			AnimatedGif *gif = [[AnimatedGif alloc]init];
			[gif decodeGIF:imageData];
			[gif setAnimationImageView:_imageView];
			[gif release];
		}
	}
}

- (void)updateImage:(UIImage *)image sender:(ImageDownloadReceiver *)receiver {
	if (image) {
		[self setupImageViewWithImage:image];
		if (photoImageViewDelegate) {
			[photoImageViewDelegate photoDidFinishLoading:_photo];
		}
	}
	else {
		self.imageView.image = nil; // Photo Error Placeholder
		self.photo.failed = YES;
		[self layoutScrollViewAnimated:NO];
		self.userInteractionEnabled = NO;
		[_activityView stopAnimating];		
		_progressView.hidden = YES;
		if (photoImageViewDelegate) {
			[photoImageViewDelegate photoDidFailToLoad:_photo];
		}
	}

}

#pragma mark -
#pragma mark UIScrollView Delegate Methods

- (void)reallyKillZoom{
	
	[self.scrollView setZoomScale:1.0f animated:NO];
	self.imageView.frame = self.scrollView.bounds;
	[self layoutScrollViewAnimated:NO];
}

- (void)killScrollViewZoom{
	
	if (!self.scrollView.zoomScale > 1.0f) return;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDidStopSelector:@selector(reallyKillZoom)];
	[UIView setAnimationDelegate:self];
	
	CGFloat hfactor = self.imageView.image.size.width / self.frame.size.width;
	CGFloat vfactor = self.imageView.image.size.height / self.frame.size.height;
	
	CGFloat factor = MAX(hfactor, vfactor);
	if (factor == 0) {
		factor = 1;
	}
	
	CGFloat newWidth = self.imageView.image.size.width / factor;
	CGFloat newHeight = self.imageView.image.size.height / factor;
	
	CGFloat leftOffset = (self.frame.size.width - newWidth) / 2;
	CGFloat topOffset = (self.frame.size.height - newHeight) / 2;
	
	self.scrollView.frame = CGRectMake(leftOffset, topOffset, newWidth, newHeight);
	self.imageView.frame = self.scrollView.bounds;
	[UIView commitAnimations];
	
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
	return [self.scrollView viewWithTag:ZOOM_VIEW_TAG];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale{
	
	if (scrollView.zoomScale > 1.0f) {		
		CGFloat height, width, originX, originY;
		height = MIN(CGRectGetHeight(self.imageView.frame) + self.imageView.frame.origin.x, CGRectGetHeight(self.bounds));
		width = MIN(CGRectGetWidth(self.imageView.frame) + self.imageView.frame.origin.y, CGRectGetWidth(self.bounds));
		
		
		if (CGRectGetMaxX(self.imageView.frame) > self.bounds.size.width) {
			width = CGRectGetWidth(self.bounds);
			originX = 0.0f;
		} else {
			width = CGRectGetMaxX(self.imageView.frame);
			
			if (self.imageView.frame.origin.x < 0.0f) {
				originX = 0.0f;
			} else {
				originX = self.imageView.frame.origin.x;
			}	
		}
		
		if (CGRectGetMaxY(self.imageView.frame) > self.bounds.size.height) {
			height = CGRectGetHeight(self.bounds);
			originY = 0.0f;
		} else {
			height = CGRectGetMaxY(self.imageView.frame);
			
			if (self.imageView.frame.origin.y < 0.0f) {
				originY = 0.0f;
			} else {
				originY = self.imageView.frame.origin.y;
			}
		}
		
		CGRect frame = self.scrollView.frame;
		self.scrollView.frame = CGRectMake((self.bounds.size.width / 2) - (width / 2), (self.bounds.size.height / 2) - (height / 2), width, height);
		if (!CGRectEqualToRect(frame, self.scrollView.frame)) {		
			
			CGFloat offsetY, offsetX;
			
			if (frame.origin.y < self.scrollView.frame.origin.y) {
				offsetY = self.scrollView.contentOffset.y - (self.scrollView.frame.origin.y - frame.origin.y);
			} else {				
				offsetY = self.scrollView.contentOffset.y - (frame.origin.y - self.scrollView.frame.origin.y);
			}
			
			if (frame.origin.x < self.scrollView.frame.origin.x) {
				offsetX = self.scrollView.contentOffset.x - (self.scrollView.frame.origin.x - frame.origin.x);
			} else {				
				offsetX = self.scrollView.contentOffset.x - (frame.origin.x - self.scrollView.frame.origin.x);
			}
			
			if (offsetY < 0) offsetY = 0;
			if (offsetX < 0) offsetX = 0;
			
			self.scrollView.contentOffset = CGPointMake(offsetX, offsetY);
		}
		
	} else {
		[self layoutScrollViewAnimated:YES];
	}
}	


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	if (_photo) {
		[downloader removeDelegate:_receiver forURL:self.photo.URL];
		[downloader removeDelegate:_receiver forURL:self.photo.originalURL];
	}
	_receiver.imageContainer = nil;
	[_receiver release];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[_imageView release]; _imageView=nil;
	[_scrollView release]; _scrollView=nil;
	[_photo release]; _photo=nil;
    [super dealloc];
	
}



@end
