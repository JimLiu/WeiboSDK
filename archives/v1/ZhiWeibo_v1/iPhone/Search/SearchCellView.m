//
//  SearchCellView.m
//  ZhiWeibo
//
//  Created by Zhang Jason on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchCellView.h"


@implementation SearchCellView


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = [[[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"searches-header-single.png"]stretchableImageWithLeftCapWidth:28 topCapHeight:20]] autorelease];
		UIImageView *back = [[[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"searches-field.png"]stretchableImageWithLeftCapWidth:28 topCapHeight:20]] autorelease];
		back.frame = CGRectMake(16, 2, 288, 42);
		[self addSubview:back];
		UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectMake(46, 13, 150, 20)] autorelease];
		lbl.backgroundColor = [UIColor clearColor];
		lbl.text = @"搜索用户或微博";
		lbl.font = [UIFont systemFontOfSize:14];
		lbl.textColor = [UIColor lightGrayColor];
		[self addSubview:lbl];
	}
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
	
}


- (void)dealloc {
	[super dealloc];
}


@end
