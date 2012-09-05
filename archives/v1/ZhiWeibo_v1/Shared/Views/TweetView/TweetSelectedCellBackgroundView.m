//
//  TweetSelectedCellBackgroundView.m
//  ZhiWeibo
//
//  Created by Zhang Jason on 12/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TweetSelectedCellBackgroundView.h"


@implementation TweetSelectedCellBackgroundView


- (id)initWithFrame:(CGRect)frame {
	if((self = [super initWithFrame:frame])) {
		self.contentMode = UIViewContentModeRedraw;
		backgroundImage = [[UIImage imageNamed:@"TableBlueSelectionGradient.png"] retain];
	}
	
	return self;
}

- (void)drawRect:(CGRect)rect {
	[backgroundImage drawInRect:rect];
	//[(ABTableViewCell *)[self superview] drawContentView:rect highlighted:YES];
}

- (void)dealloc {
	[backgroundImage release];
	[super dealloc];
}

@end
