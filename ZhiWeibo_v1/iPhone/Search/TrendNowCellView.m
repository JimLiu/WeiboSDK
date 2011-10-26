//
//  TrendNowCellView.m
//  ZhiWeibo
//
//  Created by Zhang Jason on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TrendNowCellView.h"


@implementation TrendNowCellView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = [[[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"searches-header.png"]stretchableImageWithLeftCapWidth:28 topCapHeight:20]] autorelease];
		UIView *background = [[UIView alloc] initWithFrame:CGRectMake(20, 10, 280, 76)];
		background.backgroundColor = [UIColor whiteColor];
		background.clipsToBounds = YES;
		scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 250, 76)];
		scrollView.backgroundColor = [UIColor clearColor];
		scrollView.pagingEnabled = YES;
		scrollView.showsHorizontalScrollIndicator = NO;
		scrollView.clipsToBounds = NO;
		hotStatusesDataSource = [[HotStatusesDataSource alloc] initWithScrollView:scrollView];
		[background addSubview:scrollView];
		[self addSubview:background];
		[background release];
		UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectMake(16, 92, 200, 20)] autorelease];
		lbl.backgroundColor = [UIColor clearColor];
		lbl.text = @"热门话题";
		lbl.font = [UIFont boldSystemFontOfSize:16];
		lbl.textColor = [UIColor colorWithRed:0.5176 green:0.5607 blue:0.6078 alpha:1];
		[self addSubview:lbl];
	}
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
	
}

- (void)loadHotStatues {
	[hotStatusesDataSource loadHotStatues];
}

- (void)dealloc {
	[scrollView release];
    [super dealloc];
}


@end
