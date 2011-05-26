//
//  DummyGapStatus.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-10-26.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "DummyGapStatus.h"


@implementation DummyGapStatus
@synthesize cell, statusId;

- (id)initWithStatusId:(long long)_statusId {
	if (self = [super init]) {
		statusId = _statusId;
	}
	return self;
}

- (void)dealloc {
	cell = nil;
	[super dealloc];
}

@end
