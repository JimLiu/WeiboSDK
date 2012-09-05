//
//  CheckBoxView.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-6.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "CheckBoxView.h"
#import "UIImage+Alpha.h"

@implementation CheckBoxView
@synthesize text;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.backgroundColor = [UIColor clearColor];
		titleFontSize = 20;
		self.titleLabel.font = [UIFont systemFontOfSize:titleFontSize];
		self.titleLabel.textColor = [UIColor whiteColor];
		self.titleLabel.shadowColor = [UIColor blackColor];
		self.titleLabel.shadowOffset = CGSizeMake(1, 1);
		checkedImage = [[UIImage imageNamed:@"checkedSmall.png"] retain];
		uncheckedImage = [[UIImage imageNamed:@"uncheckedSmall.png"] retain];
		[self setImage:checkedImage forState:UIControlStateSelected];
		[self setImage:uncheckedImage forState:UIControlStateNormal];
		[self addTarget:self
							action:@selector(checkboxButtonTouch:)
				  forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)checkboxButtonTouch:(id)sender {
	self.isChecked = !self.isChecked;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (BOOL)isChecked {
	return self.selected;
}

- (void)setText:(NSString *)_text {
	if (_text != text) {
		[text release];
		text = [_text copy];
		[self setTitle:text forState:UIControlStateNormal];
	}
}

- (CGRect)backgroundRectForBounds:(CGRect)bounds {
	return self.frame;
}

- (CGRect)contentRectForBounds:(CGRect)bounds {
	return self.frame;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
	CGRect rect = contentRect;
	rect.origin.x = 0;
	rect.origin.y = 0;
	rect.size.width = 26;
	rect.size.height = 26;
	return rect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
	CGRect rect = contentRect;
	rect.origin.x = 30;
	rect.origin.y = (rect.size.height - titleFontSize) / 2;
	rect.size.width = rect.size.width - 30;
	rect.size.height = titleFontSize;
	return rect;	
}

- (void)setIsChecked:(BOOL)isChecked {
	self.selected = isChecked;
}

- (void)dealloc {
	[checkedImage release];
	[uncheckedImage release];
	[text release];
    [super dealloc];
}



@end
