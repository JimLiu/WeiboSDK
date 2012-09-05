//
//  PhotoImageView.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-5.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "Photo.h"
#import "ImageDownloader.h"
#import "ImageCache.h"
#import "ImageDownloadReceiver.h"
#import "AnimatedGif.h"

@protocol PhotoImageViewDelegate

- (void)touch;
- (void)photoDidFinishLoading:(Photo *)photo;
- (void)photoDidFailToLoad:(Photo *)photo;

@end


@class PhotoScrollView;

@interface PhotoImageView : UIView<UIScrollViewDelegate> {
@private
	PhotoScrollView *_scrollView;
	Photo* _photo;
	UIImageView *_imageView;
	UIActivityIndicatorView *_activityView;
	UIProgressView *_progressView;
	
	id<PhotoImageViewDelegate> photoImageViewDelegate;
	
	BOOL _loading;
	CGRect _currentRect;
	ImageDownloader *downloader;
    ImageDownloadReceiver*     _receiver;
	NSString *photoUrl;
}

@property(nonatomic,retain) Photo* photo;
@property(nonatomic,readonly) UIImageView *imageView;
@property(nonatomic,readonly) PhotoScrollView *scrollView;
@property(nonatomic,assign,getter=isLoading) BOOL loading;
@property (nonatomic, assign)id<PhotoImageViewDelegate> photoImageViewDelegate;

- (void)setPhoto:(Photo*)aPhoto; 
- (void)killScrollViewZoom;
- (void)layoutScrollViewAnimated:(BOOL)animated;
- (void)prepareForReusue;
- (void)rotateToOrientation:(UIInterfaceOrientation)orientation;
- (CGSize)sizeForPopover;
- (void)loadOriginalPhoto;

@end
