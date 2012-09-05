//
//  DummyGapCell.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-10-26.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "DummyGapCell.h"



@interface DummyGapCellView : UIView
@end

@interface DummyGapCellSelectedCellView : UIView
@end

@implementation DummyGapCellView

- (id)initWithFrame:(CGRect)frame {
	if((self = [super initWithFrame:frame])) {
		self.contentMode = UIViewContentModeRedraw;
	}
	
	return self;
}

- (void)drawRect:(CGRect)rect {
	[(DummyGapCell *)[self superview] drawContentView:rect highlighted:NO];
}

@end

@implementation DummyGapCellSelectedCellView

- (id)initWithFrame:(CGRect)frame {
	if((self = [super initWithFrame:frame])) {
		self.contentMode = UIViewContentModeRedraw;
	}
	
	return self;
}

- (void)drawRect:(CGRect)rect {
	[(DummyGapCell *)[self superview] drawContentView:rect highlighted:YES];
}

@end


@implementation DummyGapCell
@synthesize dummyGapStatus, spinner;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		backgroundView = [[DummyGapCellView alloc] initWithFrame:CGRectZero];
		backgroundView.opaque = YES;
		backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"list-gap.png"]];
	
		self.backgroundView = backgroundView;
		[backgroundView release];
		
		selectedBackgroundView = [[DummyGapCellSelectedCellView alloc] initWithFrame:CGRectZero];
		selectedBackgroundView.opaque = YES;
		selectedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"list-gap.png"]];
		self.selectedBackgroundView = selectedBackgroundView;
		[selectedBackgroundView release];
		
		/*
		UIView *contentView = [[UIView alloc]initWithFrame:CGRectZero];
		contentView.contentMode = UIViewContentModeRedraw;
		contentView.opaque = NO;
		contentView.backgroundColor = [UIColor clearColor];
		self.contentView = contentView;
		[contentView release];
		 */
		
		spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		[self.contentView addSubview:spinner];
		self.contentView.backgroundColor = [UIColor clearColor];
		//[spinner startAnimating];
		[spinner release];
		
	}
	return self;
}

- (void)setDummyGapStatus:(DummyGapStatus *)value {
	if (value != dummyGapStatus) {
		[dummyGapStatus release];
		dummyGapStatus = [value retain];
		dummyGapStatus.cell = self;
	}
}

- (void)dealloc {
	spinner = nil;
	dummyGapStatus.cell = nil;
	[dummyGapStatus release];
	[super dealloc];
}

- (void)setSelected:(BOOL)selected {
	[selectedBackgroundView setNeedsDisplay];
	
	if(!selected && self.selected) {
		[backgroundView setNeedsDisplay];
	}
	
	//[super setSelected:selected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[selectedBackgroundView setNeedsDisplay];
	
	if(!selected && self.selected) {
		[backgroundView setNeedsDisplay];
	}
	
	//[super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted {
	[selectedBackgroundView setNeedsDisplay];
	
	if(!highlighted && self.highlighted) {
		[backgroundView setNeedsDisplay];
	}
	
	//[super setHighlighted:highlighted];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
	[selectedBackgroundView setNeedsDisplay];
	
	if(!highlighted && self.highlighted) {
		[backgroundView setNeedsDisplay];
	}
	
	//[super setHighlighted:highlighted animated:animated];
}

- (void)setFrame:(CGRect)f {
	[super setFrame:f];
	CGRect b = [self bounds];
	// b.size.height -= 1; // leave room for the seperator line
	self.contentView.frame = b;
	[backgroundView setFrame:b];
	[selectedBackgroundView setFrame:b];
}

- (void)setNeedsDisplay {
	[super setNeedsDisplay];
	
	if([self isHighlighted] || [self isSelected]) {
		[selectedBackgroundView setNeedsDisplay];
	}
	[backgroundView setNeedsDisplay];
}

- (void)setNeedsDisplayInRect:(CGRect)rect {
	[super setNeedsDisplayInRect:rect];
	[backgroundView setNeedsDisplayInRect:rect];
	
	if([self isHighlighted] || [self isSelected]) {
		[selectedBackgroundView setNeedsDisplayInRect:rect];
	}
}

- (void)layoutSubviews {
	[super layoutSubviews];
	//self.contentView.hidden = YES;
	//[self.contentView removeFromSuperview];
    [super layoutSubviews];
	CGPoint p = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    spinner.center = p;
}

- (void)drawContentView:(CGRect)rect highlighted:(BOOL)highlighted {
	// subclasses should implement this
}



@end
