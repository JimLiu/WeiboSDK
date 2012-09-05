//
//  EmojiNode.m
//  ZhiWeibo
//
//  Created by junmin liu on 11-1-14.
//  Copyright 2011 Openlab. All rights reserved.
//

#import "EmojiNode.h"


@implementation EmojiNode
@synthesize emoji;


- (id)initWithEmoji:(NSString*)_emoji phrase:(NSString *)_phrase {
	if (self = [super init]) {
		emoji = [_emoji copy];
		phrase = [_phrase copy];
		frame = CGRectMake(7, 7, 30, 30);
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super  initWithCoder:decoder]) {
		emoji = [[decoder decodeObjectForKey:@"emoji"] retain];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[super encodeWithCoder:encoder];
	[encoder encodeObject:emoji forKey:@"emoji"];
}

- (void)dealloc {
	[emoji release];
	[super dealloc];
}

- (void)drawInRect:(CGRect)rect {
	[[UIImage imageNamed:[NSString stringWithFormat:@"emoji/%@.png", emoji]] drawInRect:rect];
}

- (void)setPreviewImageView:(UIImageView *)previewImageView  
		 previewPhraseLabel:(UILabel *)previewPhraseLabel{
	previewPhraseLabel.text = @"";
	previewImageView.frame = CGRectMake(25, 25, 30, 30);
	previewImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"emoji/%@.png", emoji]];
	[previewImageView setAnimationImages:nil];
}

@end
