//
//  KeyValueDataManager.m
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-9-7.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "WeiboDataManager.h"

@implementation WeiboDataManager


- (id)initWithStatusTimeline:(StatusTimeline)timeline {
    self = [super init];
    if (self) {
        _timeline = timeline;
        _storage = [[TimelineStorage alloc] initWithStatusTimeline:timeline];        
    }
    return self;
}

- (void)dealloc {
    [self cancelQuery];
    [_storage release];
    [super dealloc];
}

- (void)cancelQuery {
    [_query cancel];
    _query = nil;
}

- (void)loadRecentStatus:(int)count {
    if (_query) {
        [self cancelQuery];
    }
    _query = [TimelineQuery query];
}

@end
