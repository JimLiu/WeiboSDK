//
//  SimpleTableViewCell.m
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-9-1.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "SimpleTableViewCell.h"


@interface SimpleTableViewCellView : UIView
@end

@implementation SimpleTableViewCellView

- (id)initWithFrame:(CGRect)frame {
	if((self = [super initWithFrame:frame])) {
		self.contentMode = UIViewContentModeRedraw;
	}
    
	return self;
}

- (void)drawRect:(CGRect)rect {
	[(SimpleTableViewCell *)[self superview] drawContentView:rect];
}

@end


@implementation SimpleTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		contentView = [[SimpleTableViewCellView alloc] initWithFrame:CGRectZero];
		contentView.opaque = YES;
        contentView.backgroundColor = [UIColor clearColor];
		self.backgroundView = contentView;
		[contentView release];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    return self;
}


- (void)dealloc {
	[super dealloc];
}

- (void)setSelected:(BOOL)selected {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {    

}

- (void)setHighlighted:(BOOL)highlighted {    

}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {

}

- (void)setFrame:(CGRect)rect {
	[super setFrame:rect];
	[contentView setFrame:[self bounds]];
}

- (void)setNeedsDisplay {
	[super setNeedsDisplay];
	[contentView setNeedsDisplay];
}

- (void)setNeedsDisplayInRect:(CGRect)rect {
	[super setNeedsDisplayInRect:rect];
	[contentView setNeedsDisplayInRect:rect];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.contentView.hidden = YES;
	[self.contentView removeFromSuperview];
}

- (void)drawContentView:(CGRect)rect {
}

@end
