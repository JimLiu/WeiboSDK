//
//  PhotoCaptionView.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-30.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "PhotoCaptionView.h"


@implementation PhotoCaptionView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
		self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		_textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, self.frame.size.width - 40.0f, 40.0f)];
		_textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
		_textLabel.backgroundColor = [UIColor clearColor];
		_textLabel.textAlignment = UITextAlignmentCenter;
		_textLabel.textColor = [UIColor whiteColor];
		_textLabel.shadowColor = [UIColor blackColor];
		_textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		[self addSubview:_textLabel];
		[_textLabel release];
		
    }
    return self;
}

- (void)layoutSubviews{
	
	[self setNeedsDisplay];
	_textLabel.frame = CGRectMake(20.0f, 0.0f, self.frame.size.width - 40.0f, 40.0f);
	
}

- (void)drawRect:(CGRect)rect {
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	[[UIColor colorWithWhite:1.0f alpha:0.8f] setStroke];
	CGContextMoveToPoint(ctx, 0.0f, 0.0f);
	CGContextAddLineToPoint(ctx, self.frame.size.width, 0.0f);
	CGContextStrokePath(ctx);
	
}

- (void)setCaptionText:(NSString*)text hidden:(BOOL)val{
	
	if (text == nil || [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
		
		_textLabel.text = nil;	
		[self setHidden:YES];
		
	} else {
		
		[self setHidden:val];
		_textLabel.text = text;
		
	}
	
	
}

- (void)setCaptionHidden:(BOOL)hidden{
	if (_hidden==hidden) return;
	
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3f];
		self.alpha= hidden ? 0.0f : 1.0f;
		[UIView commitAnimations];
		
		_hidden=hidden;
		
		return;
		
	}
#endif
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.2f];
	
	if (hidden) {
		
		[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
		self.frame = CGRectMake(0.0f, self.superview.frame.size.height, self.frame.size.width, self.frame.size.height);
		
	} else {
		
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		CGFloat toolbarSize;
		toolbarSize = UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ? 32.0f : 44.0f;
		
		self.frame = CGRectMake(0.0f, self.superview.frame.size.height - (toolbarSize + self.frame.size.height), self.frame.size.width, self.frame.size.height);
		
	}
	
	[UIView commitAnimations];
	
	_hidden=hidden;
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	_textLabel=nil;
    [super dealloc];
}


@end
