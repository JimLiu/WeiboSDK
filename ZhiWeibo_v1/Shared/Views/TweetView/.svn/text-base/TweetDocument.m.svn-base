//
//  TweetDocument.m
//  TweetViewDemo
//
//  Created by junmin liu on 10-10-14.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "TweetDocument.h"
#import "RegexKitLite.h"

@interface TweetDocument (Private)

- (void)layout;

@end


@implementation TweetDocument
@synthesize textColor, linkTextColor;
@synthesize view;
@synthesize highlighted;

- (id)init {
	if (self = [super init]) {
		layouts = [[NSMutableArray alloc] init];
		textColor = [[UIColor blackColor] retain];
		linkTextColor = [[UIColor colorWithWhite:0x69/255.0F alpha:1] retain];
	}
	return self;
}

- (void)dealloc {
	[layouts release];
	[linkTextColor release];
	[textColor release];
	view = nil;
	[super dealloc];
}

- (void)setHighlighted:(BOOL)value {
	if (highlighted != value) {
		highlighted = value;
		for (TweetLayout *layout in layouts) {
			layout.highlighted = highlighted;
		}
		[self setNeedsDisplay];
	}
}

- (void)setNeedsLayout {
	needsLayout = YES;
}

- (void)setNeedsDisplay {
	needsDisplay = YES;
	if (view) { 
		[view setNeedsDisplay];
	}
}

- (void)setNeedsDisplayInRect:(CGRect)rect {
	needsDisplay = YES;
	if (view) {
		[view setNeedsDisplayInRect:rect];
	}
}

- (void)layoutIfNeeded {
	if (needsLayout) {
		[self layout];
		needsLayout = NO;
	}
}

- (void)addLayout:(TweetLayout *)tweetLayout {
	[layouts addObject:tweetLayout];
	[self setNeedsLayout];
}

- (TweetLayout *)addLayoutForStatus:(NSString *)status frame:(CGRect)rect {
	TweetLayout *tweetLayout = [[TweetLayout alloc] initWithFrame:rect doc:self];
	NSMutableArray *nodes = [self parseStatus:status layout:tweetLayout];
	for (TweetNode *node in nodes) {
		[tweetLayout addNode:node];
	}
	[self addLayout:tweetLayout];
	[tweetLayout release];
	return tweetLayout;
}

- (TweetLayout *)addLayoutForText:(NSString *)text_ frame:(CGRect)rect {
	TweetLayout *tweetLayout = [[TweetLayout alloc] initWithFrame:rect doc:self];
	[tweetLayout addNodeForText:text_];
	[self addLayout:tweetLayout];
	[tweetLayout release];
	return tweetLayout;
}

- (TweetLayout *)addLayoutForImageUrl:(NSString *)url 
								imageWidth:(CGFloat)width 
							   imageHeight:(CGFloat)height
							   frame:(CGRect)rect {
	TweetLayout *tweetLayout = [[TweetLayout alloc] initWithFrame:rect doc:self];
	[tweetLayout addNodeForImageUrl:url width:width height:height];
	[self addLayout:tweetLayout];
	[tweetLayout release];
	return tweetLayout;
}


- (void)layout {
	_width = 0;
	_height = 0;
	for (TweetLayout *layout in layouts) {
		[layout layout];
		
		if (layout.frame.origin.x + layout.frame.size.width > _width) {
			_width = layout.frame.origin.x + layout.frame.size.width;
		}
		if (layout.frame.origin.y + layout.frame.size.height > _height) {
			_height = layout.frame.origin.y + layout.frame.size.height;
		}
	}
}

- (CGFloat)width {
	[self layoutIfNeeded];
	return _width;
}

- (CGFloat)height {
	[self layoutIfNeeded];
	return _height;
}

- (void)performStep:(int)step {
	for (TweetLayout *node in layouts) {
		[node performStep:step];
	}
}

- (void)drawAtPoint:(CGPoint)point {
	[self layoutIfNeeded];

	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSaveGState(ctx);
	CGContextTranslateCTM(ctx, point.x, point.y);
	
	for (TweetLayout *node in layouts) {
		[node draw];
	}
	
	CGContextRestoreGState(ctx);
}

- (TweetFrame*)hitTest:(CGPoint)point {
	for (TweetLayout *node in layouts) {
		TweetFrame *frame = [node hitTest:point];
		if (frame != nil) {
			return frame;
		}
	}
	return nil;
}

- (NSMutableArray *)parseEmoticonNodes:(NSMutableArray *)_nodes
								text:(NSString *)string 
								layout:(TweetLayout*)_layout {
	NSMutableArray *emoticons = [EmoticonDataSource emoticons];
	if (emoticons.count == 0) {
		[_nodes addObject:[TweetTextNode withText:string layout:_layout]];
		return _nodes;
	}
	static NSMutableString * emoticonRex;
	if (!emoticonRex) {
		emoticonRex = [[NSMutableString stringWithString:@""] retain];
		for (int i=0; i<emoticons.count; i++) {
			Emoticon *emoticon = [emoticons objectAtIndex:i];
			[emoticonRex appendString:[[emoticon.phrase stringByReplacingOccurrencesOfString:@"[" withString:@"\\["] stringByReplacingOccurrencesOfString:@"]" withString:@"\\]"]];
			if (i < emoticons.count - 1) {
				[emoticonRex appendString:@"|"];
			}
		}
	}
	
	
	NSInteger stringIndex = 0;
	
	while (stringIndex < string.length) {
		NSRange searchRange = NSMakeRange(stringIndex, string.length - stringIndex);
		NSRange startRang = [string rangeOfRegex:emoticonRex
										 inRange:searchRange];
		
		if (startRang.location != NSNotFound) {
			NSRange beforeRange = NSMakeRange(searchRange.location,
											  startRang.location - searchRange.location);
			if (beforeRange.length) {
				[_nodes addObject:[TweetTextNode withText:[string substringWithRange:beforeRange] layout:_layout]];
			}
			
			NSString *phrase = [string substringWithRange:startRang];
			for (Emoticon *emo in emoticons) {
				if ([phrase isEqualToString:emo.phrase]) {
					TweetAnimationImageNode *gifNode = [[TweetAnimationImageNode alloc]initWithLayout:_layout];
					gifNode.cacheName = @"emoticons";
					gifNode.margin = UIEdgeInsetsMake(2, 2, 2, 2);
					gifNode.delays = emo.delays;
					gifNode.imageUrls = emo.imageUrls;
					gifNode.gifUrl = emo.gifUrl;
					gifNode.width = emo.width;
					gifNode.height = emo.height;
					[_nodes addObject:gifNode];
					[gifNode release];
					break;
				}
			}
			
			stringIndex = startRang.location + startRang.length;
		}
		else {
			[_nodes addObject:[TweetTextNode withText:[string substringWithRange:searchRange] layout:_layout]];
			break;
		}
	}
	
	return _nodes;
}

- (NSMutableArray *)parseStatus:(NSString *)string 
						 layout:(TweetLayout*)_layout {
	NSMutableArray *_nodes = [NSMutableArray array];
	
	NSInteger stringIndex = 0;
	
	while (stringIndex < string.length) {
		NSRange searchRange = NSMakeRange(stringIndex, string.length - stringIndex);
		NSRange startRang = [string rangeOfRegex:@"[a-zA-Z0-9%_.+\\-]+@[a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6}|@[a-zA-Z0-9_\\u4e00-\\u9fa5\\-]+|#[^#]+#|https?://[a-zA-Z0-9\\-.]+(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?"
										 inRange:searchRange];
		
		if (startRang.location != NSNotFound) {
			NSRange beforeRange = NSMakeRange(searchRange.location,
											  startRang.location - searchRange.location);
			if (beforeRange.length) {
				[self parseEmoticonNodes:_nodes text:[string substringWithRange:beforeRange] layout:_layout];
				//[_nodes addObject:[TweetTextNode withText:[string substringWithRange:beforeRange] layout:_layout]];
			}
			
			TweetLinkNode *linkNode = [TweetLinkNode withUrl:[string substringWithRange:startRang] layout:_layout];
			if ([linkNode.url isMatchedByRegex:@"https?://[a-zA-Z0-9\\-.]+(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?"]) {
				linkNode.selectable = NO;
			}
			[_nodes addObject:linkNode];
			
			stringIndex = startRang.location + startRang.length;
		}
		else {
			[self parseEmoticonNodes:_nodes text:[string substringWithRange:searchRange] layout:_layout];
			//[_nodes addObject:[TweetTextNode withText:[string substringWithRange:searchRange] layout:_layout]];
			break;
		}
	}
	
	return _nodes;
}


@end
