//
//  PullRefreshTableView.m
//  Weibo
//
//  Created by junmin liu on 10-10-11.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "PullRefreshTableView.h"
#import "RefreshTableHeaderView.h"


@interface PullRefreshTableView (Private)

- (void)dataSourceDidFinishLoadingNewData;

@end

@implementation PullRefreshTableView
@synthesize refreshHeaderView;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
	if (self = [super initWithFrame:frame style:style]) {
		refreshHeaderView = [[RefreshTableHeaderView alloc] 
							 initWithFrame:CGRectMake(0.0f, 0.0f - frame.size.height, frame.size.width, frame.size.height)];
		refreshHeaderView.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
		[self addSubview:refreshHeaderView];
		self.showsVerticalScrollIndicator = YES;
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		CGRect frame = self.frame;
		refreshHeaderView = [[RefreshTableHeaderView alloc] 
							 initWithFrame:CGRectMake(0.0f, 0.0f - frame.size.height, frame.size.width, frame.size.height)];
		refreshHeaderView.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
		[self addSubview:refreshHeaderView];
		self.showsVerticalScrollIndicator = YES;		
	}
	return self;
}

- (void)dealloc {
	[refreshHeaderView release];
	refreshHeaderView = nil;
    [super dealloc];
}




@end

