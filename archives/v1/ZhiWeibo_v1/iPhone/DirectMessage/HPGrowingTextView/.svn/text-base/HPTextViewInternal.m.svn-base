//
//  HPTextViewInternal.m
//  Cupido
//
//  Created by Hans Pinckaers on 30-06-10.
//  Copyright 2010 Hans Pinckaers. All rights reserved.
//

#import "HPTextViewInternal.h"


@implementation HPTextViewInternal

-(void)setContentOffset:(CGPoint)s
{
	if(self.tracking || self.decelerating){
		//initiated by user...
		self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
	} else {

		float bottomOffset = (self.contentSize.height - self.frame.size.height + self.contentInset.bottom);
		if(s.y < bottomOffset && self.scrollEnabled){
			self.contentInset = UIEdgeInsetsMake(0, 0, 8, 0); //maybe use scrollRangeToVisible?
		}
		
	}
	
	[super setContentOffset:s];
}

-(void)setContentInset:(UIEdgeInsets)s
{
	UIEdgeInsets insets = s;
	
	if(s.bottom>8) insets.bottom = 0;
	insets.top = 0;

	[super setContentInset:insets];
}


- (void)dealloc {
    [super dealloc];
}


@end
