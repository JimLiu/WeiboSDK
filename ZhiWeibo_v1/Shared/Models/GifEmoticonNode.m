//
//  GifEmoticonNode.m
//  ZhiWeibo
//
//  Created by junmin liu on 11-1-24.
//  Copyright 2011 Openlab. All rights reserved.
//

#import "GifEmoticonNode.h"


@implementation GifEmoticonNode

- (id)initWithEmoticon:(Emoticon*)_emoticon {
	if (self = [super init]) {
		phrase = [_emoticon.phrase copy];
		emoticon = [_emoticon retain];
		frame = CGRectMake(11, 11, 22, 22);
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super  initWithCoder:decoder]) {
		emoticon = [[decoder decodeObjectForKey:@"emoticon"] retain];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[super encodeWithCoder:encoder];
	[encoder encodeObject:emoticon forKey:@"emoticon"];
}

- (void)dealloc {
	[emoticon release];
	[super dealloc];
}

- (void)drawInRect:(CGRect)rect {
	[[emoticon defaultFrameImage] drawInRect:rect];
}

- (void)setPreviewImageView:(UIImageView *)previewImageView  
		 previewPhraseLabel:(UILabel *)previewPhraseLabel {
	previewPhraseLabel.text = emoticon.phrase;
	AnimatedGif *gif = [[AnimatedGif alloc]init];
	NSString *path = [[[NSBundle mainBundle] resourcePath] 
					  stringByAppendingPathComponent:emoticon.gifUrl];
	NSData *data = [NSData dataWithContentsOfFile: path];
	[gif decodeGIF:data];
	[gif setAnimationImageView:previewImageView];
	[gif release];
	
	UIView *previewView = previewImageView.superview;
	if (previewView) {
		CGRect _frame = previewImageView.frame;
		_frame.origin.y = 20;
		_frame.origin.x = (previewView.frame.size.width - previewImageView.frame.size.width) / 2;
		previewImageView.frame = _frame;
	}
	
}

@end
