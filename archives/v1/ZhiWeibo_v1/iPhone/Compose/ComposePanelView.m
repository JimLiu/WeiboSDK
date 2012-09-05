//
//  ComposePanelView.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-23.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "ComposePanelView.h"
#import "UIImage+Alpha.h"
#import "LocationManager.h"

@implementation ComposePanelView
@synthesize isCommentMode;

- (UIImage *)maskImage:(UIImage *)image {
	return [image maskWithColor:[UIColor colorWithWhite:0xFF/255.0F alpha:1] shadowColor:[UIColor blackColor]
				   shadowOffset:CGSizeMake(0, 1)
					 shadowBlur:2];
}

- (UIImage *)maskHighlightImage:(UIImage *)image {
	return [image maskWithColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"geotag-background.png"]] shadowColor:[UIColor blackColor]
				   shadowOffset:CGSizeMake(0, 1)
					 shadowBlur:2];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dotted-pattern.png"]];
		
		innerShadowImage = [[[UIImage imageNamed:@"inner-shadow.png"] stretchableImageWithLeftCapWidth:16 topCapHeight:16] retain];
		
    }
    return self;
}

- (void)dealloc {
	[innerShadowImage release];
    [super dealloc];
}

- (void)setIsCommentMode:(BOOL)_isCommentMode {
	if (isCommentMode != _isCommentMode) {
		isCommentMode = _isCommentMode;
		[self setNeedsDisplay];
	}
}

- (void)drawRect:(CGRect)rect {
    // Drawing background
	[innerShadowImage drawInRect:rect];

	CGContextRef context = UIGraphicsGetCurrentContext();
	//CGContextClearRect(context, rect);
    CGContextSetLineWidth(context, 1);
	CGContextSetAllowsAntialiasing(context, false);
	CGContextSetRGBStrokeColor(context, 0, 0, 0, 0.2);
	
	CGFloat width = rect.size.width;
	CGFloat height = rect.size.height;
	
	if (isCommentMode) {
		CGFloat blockWidth = (width - 4) / 3;
		CGFloat blockHeight = (height - 2 - 1) / 2;
		
		CGPoint points1[6] = {
			{0, blockHeight + 1}, {rect.size.width, blockHeight + 1},
			{blockWidth, blockHeight + 3}, {blockWidth, rect.size.height},
			{blockWidth * 2 + 2, blockHeight + 3}, {blockWidth * 2 + 2, rect.size.height},
		};
		CGContextStrokeLineSegments(context, points1, 6);
		
		CGContextSetRGBStrokeColor(context, 1, 1, 1, 0.1);
		CGPoint points2[6] = {
			{0, blockHeight + 2}, {rect.size.width, blockHeight + 2},
			{blockWidth + 1, blockHeight + 3}, {blockWidth + 1, rect.size.height},
			{blockWidth * 2 + 3, blockHeight + 3}, {blockWidth * 2 + 3, rect.size.height},
		};
		CGContextStrokeLineSegments(context, points2, 6);		
	}
	else {
		CGFloat blockWidth = (width - 4) / 3;
		CGFloat blockHeight = (height - 2 - 1) / 2;
		
		CGPoint points1[6] = {
			{0, blockHeight + 1}, {rect.size.width, blockHeight + 1},
			{blockWidth, 0}, {blockWidth, rect.size.height},
			{blockWidth * 2 + 2, 0}, {blockWidth * 2 + 2, rect.size.height},
		};
		CGContextStrokeLineSegments(context, points1, 6);
		
		CGContextSetRGBStrokeColor(context, 1, 1, 1, 0.1);
		CGPoint points2[6] = {
			{0, blockHeight + 2}, {rect.size.width, blockHeight + 2},
			{blockWidth + 1, 0}, {blockWidth + 1, rect.size.height},
			{blockWidth * 2 + 3, 0}, {blockWidth * 2 + 3, rect.size.height},
		};
		CGContextStrokeLineSegments(context, points2, 6);	
	}
	
}



@end
