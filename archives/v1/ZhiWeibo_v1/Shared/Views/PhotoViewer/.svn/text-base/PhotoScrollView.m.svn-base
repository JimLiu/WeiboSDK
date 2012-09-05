//
//  PhotoScrollView.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-5.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "PhotoScrollView.h"
#import "PhotoImageView.h"

@implementation PhotoScrollView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
		self.scrollEnabled = YES;
		self.pagingEnabled = NO;
		self.clipsToBounds = NO;
		self.maximumZoomScale = 5.0f;
		self.minimumZoomScale = 1.0f;
		self.showsVerticalScrollIndicator = NO;
		self.showsHorizontalScrollIndicator = NO;
		self.alwaysBounceVertical = NO;
		self.alwaysBounceHorizontal = NO;
		self.bouncesZoom = YES;
		self.bounces = YES;
		self.scrollsToTop = NO;
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
		self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
		self.decelerationRate = UIScrollViewDecelerationRateFast;
		
    }
    return self;
}

- (void)zoomRectWithCenter:(CGPoint)center{
	
	if (self.zoomScale > 1.0f) {
		
		[((PhotoImageView*)self.superview) killScrollViewZoom];
		
		return;
	}
	
	CGRect rect;
	rect.size = CGSizeMake(self.frame.size.width / EGOPV_ZOOM_SCALE, self.frame.size.height / EGOPV_ZOOM_SCALE);
	rect.origin.x = MAX((center.x - (rect.size.width / 2.0f)), 0.0f);		
	rect.origin.y = MAX((center.y - (rect.size.height / 2.0f)), 0.0f);
	
	CGRect frame = [self.superview convertRect:self.frame toView:self.superview];
	CGFloat borderX = frame.origin.x;
	CGFloat borderY = frame.origin.y;
	
	if (borderX > 0.0f && (center.x < borderX || center.x > self.frame.size.width - borderX)) {
		
		if (center.x < (self.frame.size.width / 2.0f)) {
			
			rect.origin.x += (borderX/EGOPV_ZOOM_SCALE);
			
		} else {
			
			rect.origin.x -= ((borderX/EGOPV_ZOOM_SCALE) + rect.size.width);
			
		}	
	}
	
	if (borderY > 0.0f && (center.y < borderY || center.y > self.frame.size.height - borderY)) {
		
		if (center.y < (self.frame.size.height / 2.0f)) {
			
			rect.origin.y += (borderY/EGOPV_ZOOM_SCALE);
			
		} else {
			
			rect.origin.y -= ((borderY/EGOPV_ZOOM_SCALE) + rect.size.height);
			
		}
		
	}
	
	[self zoomToRect:rect animated:YES];	
	
}

- (void)toggleBars{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ZhiWeiboPhotoViewToggleBars" object:nil];
}


#pragma mark -
#pragma mark Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesEnded:touches withEvent:event];
	if (self.superview) {
		[self.superview touchesEnded:touches withEvent:event];
	}
	UITouch *touch = [touches anyObject];
	
	if (touch.tapCount == 1) {
		[self performSelector:@selector(toggleBars) withObject:nil afterDelay:.2];
	} else if (touch.tapCount == 2) {
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(toggleBars) object:nil];
		[self zoomRectWithCenter:[[touches anyObject] locationInView:self]];
	}
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
    [super dealloc];
}


@end
