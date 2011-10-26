//
//  EmojiListView.m
//  ZhiWeibo
//
//  Created by junmin liu on 11-1-13.
//  Copyright 2011 Openlab. All rights reserved.
//

#import "EmojiListView.h"


@implementation EmojiListView
@synthesize emojiNodes;
@synthesize perRowCount;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    for (EmojiNode *emojiNode in emojiNodes) {
		[emojiNode draw];
	}
}


- (void)dealloc {
	[emojiNodes release];
    [super dealloc];
}

- (void)setFrame:(CGRect)_frame {
	if (_frame.size.width == 320) {
		perRowCount = 7;
	}
	else {
		perRowCount = 10;
	}

	for (int i=0; i<emojiNodes.count; i++) {
		EmojiNode *emojiNode = [emojiNodes objectAtIndex:i];
		emojiNode.view = self;
		int x = i % perRowCount * 90;
		int y = i / perRowCount * 90;
		emojiNode.bounds = CGRectMake(x, y, 90, 90);
	}
}

@end
