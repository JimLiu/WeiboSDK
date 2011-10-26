//
//  UITextViewAdditions.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-8.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "UITextViewAdditions.h"


@implementation UITextView (Addtions)

- (void)deleteChar {
	NSRange range = self.selectedRange; 
	if (range.location != NSNotFound && range.location > 0) {
		NSRange deleteRange;
		if (range.length > 0) {
			deleteRange = range;
			range.length = 0;
		}
		else {
			deleteRange = NSMakeRange(range.location - 1, 1);
			range.location -= 1;
		}
		NSMutableString *text = [NSMutableString stringWithString:self.text];
		[text deleteCharactersInRange:deleteRange]; 
		self.text = text;
		self.selectedRange = range;
	}
}

- (void) insertString: (NSString *) insertingString  
{  
	NSString * firstHalfString;
	NSString * secondHalfString;
    NSRange range = self.selectedRange;  
	if (range.location != NSNotFound) {
		firstHalfString = [self.text substringToIndex:range.location];  
		secondHalfString = [self.text substringFromIndex: range.location + range.length];  
	}
	else {
		firstHalfString = self.text;
		secondHalfString = @"";
	}

    self.scrollEnabled = NO;  // turn off scrolling or you'll get dizzy ... I promise  
	
    self.text = [NSString stringWithFormat: @"%@%@%@",  
					 firstHalfString,  
					 insertingString,  
					 secondHalfString];  
    //range.length = [insertingString length]; 
	if (range.location == NSNotFound) {
		range.location = self.text.length;
	}
	range.length = 0;
	range.location = range.location + [insertingString length]; 

	self.scrollEnabled = YES;  // turn scrolling back on.  
    self.selectedRange = range;  
	
}

@end
