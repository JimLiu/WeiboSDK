//
//  EmoticonNode.m
//  ZhiWeibo
//
//  Created by junmin liu on 11-1-14.
//  Copyright 2011 Openlab. All rights reserved.
//

#import "EmoticonNode.h"


@implementation EmoticonNode
@synthesize bounds;
@synthesize view;
@synthesize frame;
@synthesize isHighlighted;
@synthesize phrase;


- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
		bounds = [decoder decodeCGRectForKey:@"bounds"];
		frame = [decoder decodeCGRectForKey:@"frame"];
		phrase = [[decoder decodeObjectForKey:@"phrase"] retain];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeCGRect:bounds forKey:@"bounds"];
	[encoder encodeCGRect:frame forKey:@"frame"];
	[encoder encodeObject:phrase forKey:@"phrase"];
}

- (void)dealloc {
	view = nil;
	[phrase release];
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)draw {
	CGRect rect = CGRectMake(bounds.origin.x + frame.origin.x, bounds.origin.y + frame.origin.y, frame.size.width, frame.size.height);
	[self drawInRect:rect];	
}

- (void)drawInRect:(CGRect)rect {

}

- (void)setPreviewImageView:(UIImageView *)previewImageView  
		 previewPhraseLabel:(UILabel *)previewPhraseLabel {
}


@end
