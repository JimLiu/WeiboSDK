//
//  EmoticonsPopupView.m
//  ZhiWeibo
//
//  Created by junmin liu on 11-1-14.
//  Copyright 2011 Openlab. All rights reserved.
//

#import "EmoticonsPopupView.h"


@implementation EmoticonsPopupView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {

		self.backgroundColor = [UIColor colorWithWhite:0xE1/255.0F alpha:1];
		
		emoticonsScrollView = [[EmoticonsScrollView alloc]initWithFrame:CGRectZero];
		emoticonsToolbarView = [[EmoticonsToolbarView alloc]initWithFrame:CGRectMake(0, 162, 320, 54)];
		emoticonsToolbarView.toolbarDelegate = self;
		[self addSubview:emoticonsScrollView];
		[self addSubview:emoticonsToolbarView];
		
		currentEmoticonsType = EmoticonsTypeSinaWeibo;
		//emoticonsScrollView.emoticonNodes = [EmojiDataSource getEmojiNodes:@"t1"];
		currentEmoticonsIndex = 1;
		[self setEmoticonNodes:currentEmoticonsIndex];
    }
    return self;
}

- (void)layoutSubviews {
	if (self.frame.size.width == 320) {
		emoticonsScrollView.frame = CGRectMake(0, 1, 320, 160);
		emoticonsToolbarView.frame = CGRectMake(0, self.frame.size.height - 54, 320, 54);
	}
	else if	(self.frame.size.width == 480) {
		emoticonsScrollView.frame = CGRectMake(0, 1, 480, 120);
		emoticonsToolbarView.frame = CGRectMake(0, self.frame.size.height - 40, 480, 40);
	}
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	//CGContextClearRect(context, rect);
    CGContextSetLineWidth(context, 1);
	CGContextSetAllowsAntialiasing(context, false);
	CGContextSetRGBStrokeColor(context, 0x3B/255.F, 0x3B/255.F, 0x3B/255.F, 1.0);
	CGPoint points[2] = {
		{0, 0}, {480, 0}
	};
	CGContextStrokeLineSegments(context, points, 2);
	
	CGContextSetRGBStrokeColor(context, 0x9A/255.F, 0x9A/255.F, 0x9A/255.F, 1.0);
	CGPoint points1[2] = {
		{0, 1}, {480, 1}
	};
	CGContextStrokeLineSegments(context, points1, 2);
	
	CGContextSetRGBStrokeColor(context, 0xFF/255.F, 0xFF/255.F, 0xFF/255.F, 1.0);
	CGPoint points2[2] = {
		{0, 2}, {480, 2}
	};
	CGContextStrokeLineSegments(context, points2, 2);
}

- (void)dealloc {
	[emoticonsScrollView release];
	[super dealloc];
}

- (void)changeEmoticonsType {
	if (currentEmoticonsType == EmoticonsTypeSinaWeibo) {
		currentEmoticonsType = EmoticonsTypeEmoji;
	}
	else {
		currentEmoticonsType = EmoticonsTypeSinaWeibo;
	}
	[self setEmoticonNodes:currentEmoticonsIndex];
}

- (void)deleteChar {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"deleteStatusChar" 
														object:nil];

}


- (void)emoticonsCategoryChanged:(int)index {
	[self setEmoticonNodes:index];
}

- (void)setEmoticonNodes:(int)index {
	NSString *type = @"";
	if (index > 0)
	{
		type = [NSString stringWithFormat:@"t%d", index];
		if (currentEmoticonsType == EmoticonsTypeSinaWeibo) {
			emoticonsScrollView.emoticonNodes = [EmoticonDataSource getEmoticonNodes:type];
		}
		else {
			emoticonsScrollView.emoticonNodes = [EmojiDataSource getEmojiNodes:type];
		}
	}
	else {
		if (currentEmoticonsType == EmoticonsTypeSinaWeibo) {
			emoticonsScrollView.emoticonNodes = [EmoticonDataSource loadRecentEmoticonNodes];
		}
		else {
			emoticonsScrollView.emoticonNodes = [EmojiDataSource loadRecentEmojiNodes];
		}
	}

	currentEmoticonsIndex = index;
}

@end
