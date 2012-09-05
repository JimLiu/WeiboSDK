//
//  EmoticonPreviewView.m
//  ZhiWeibo
//
//  Created by junmin liu on 11-1-21.
//  Copyright 2011 Openlab. All rights reserved.
//

#import "EmoticonPreviewView.h"


@implementation EmoticonPreviewView
@synthesize emoticonNode;
@synthesize previewImageView;
@synthesize previewPhraseLabel;

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor clearColor];
		backgroundImage = [[UIImage imageNamed:@"emoticonPreview_background.png"] retain];
		//self.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
		previewImageView = [[UIImageView alloc]initWithFrame:CGRectMake(25, 25, 30, 30)];
		[self addSubview:previewImageView];
		previewImageView.backgroundColor = [UIColor clearColor];
		
		previewPhraseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, 80, 20)];
		previewPhraseLabel.font = [UIFont boldSystemFontOfSize:14];
		previewPhraseLabel.textColor = [UIColor blackColor];
		//previewPhraseLabel.lineBreakMode = UILineBreakModeCharacterWrap;
		//previewPhraseLabel.numberOfLines = 2;
		previewPhraseLabel.textAlignment = UITextAlignmentCenter;
		[self addSubview:previewPhraseLabel];
		previewPhraseLabel.backgroundColor = [UIColor clearColor];
	}
	return self;
}

- (void)setFrame:(CGRect)_frame {
	[super setFrame:_frame];
	[self setNeedsDisplay];
}

- (void)setEmoticonNode:(EmoticonNode *)_node {
	if (emoticonNode != _node) {
		[emoticonNode release];
		emoticonNode = [_node retain];
		//[self setNeedsDisplay];
		[emoticonNode setPreviewImageView:previewImageView
					   previewPhraseLabel:previewPhraseLabel];
	}
}

- (void)dealloc {
	[previewImageView release];
	[backgroundImage release];
	[previewPhraseLabel release];
	[super dealloc];
}

- (void)drawRect:(CGRect)rect {
	[backgroundImage drawInRect:CGRectMake(0, 0, 80, 120)];
	//if (emoticonNode) {
	//	[emoticonNode drawInRect:CGRectMake(25, 25, 30, 30)];
	//}
}


@end
