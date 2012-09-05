//
//  TweetCellBackgroundView.m
//  ZhiWeibo
//
//  Created by Zhang Jason on 12/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TweetCellBackgroundView.h"


@implementation TweetCellBackgroundView


- (id)initWithFrame:(CGRect)frame {
	if((self = [super initWithFrame:frame])) {
		self.contentMode = UIViewContentModeRedraw;
		backgroundImage = [[UIImage imageNamed:@"cell-shadow.png"] retain];
	}
	
	return self;
}

- (void)drawRect:(CGRect)rect {
	//[backgroundImage drawInRect:rect];
	[backgroundImage drawInRect:CGRectMake(0, rect.size.height - 20, rect.size.width, 20)];
	
	//[(ABTableViewCell *)[self superview] drawContentView:rect highlighted:NO];
}

- (void)dealloc {
	[backgroundImage release];
	[super dealloc];
}

@end
