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

- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
		statusId = [decoder decodeInt64ForKey:@"statusId"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeInt64:statusId forKey:@"statusId"];
}

- (void)dealloc {
	cell = nil;
	[super dealloc];
}

@end
