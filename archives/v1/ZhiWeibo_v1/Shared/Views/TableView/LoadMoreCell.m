//
//  LoadingMoreCell.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-10-25.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "LoadMoreCell.h"


@implementation LoadMoreCell
@synthesize spinner;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		//self.backgroundColor = [UIColor colorWithWhite:0xF5/255.0F alpha:1];
		// name label
		label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.backgroundColor = [UIColor colorWithWhite:0xF5/255.0F alpha:1];
		//label.textColor = [UIColor cellLabelColor];
		label.highlightedTextColor = [UIColor whiteColor];
		label.font = [UIFont boldSystemFontOfSize:16];
		label.numberOfLines = 1;
		label.textAlignment = UITextAlignmentCenter;    
		label.frame = CGRectMake(0, 0, 320, 47);
		label.text = @"加载更多...";
		[self.contentView addSubview:label];
		[label release];
		
		spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[self.contentView addSubview:spinner];
		[spinner release];
		
	}
	return self;
}

- (void)dealloc {
	label = nil;
	spinner = nil;
	[super dealloc];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = [label textRectForBounds:CGRectMake(0, 0, self.bounds.size.width, 48) limitedToNumberOfLines:1];
    spinner.frame = CGRectMake(bounds.origin.x + bounds.size.width + 4, (self.frame.size.height / 2) - 8, 16, 16);
    label.frame = CGRectMake(0, 0, self.bounds.size.width, self.frame.size.height - 1);
}


@end
