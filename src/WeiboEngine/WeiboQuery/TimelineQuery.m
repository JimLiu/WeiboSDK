//
//  StatusesQuery.m
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-9-5.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "TimelineQuery.h"
#import "NSDictionaryAdditions.h"

@implementation TimelineQuery
@synthesize completionBlock = _completionBlock;


- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


+ (TimelineQuery *)query {
    return [[[TimelineQuery alloc]init]autorelease];
}

- (void)dealloc {
    [_completionBlock release];
    [super dealloc];
}


- (void)queryFriendsTimelineFrom:(long long)sinceId maxId:(long long)maxId count:(int)count {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [NSString stringWithFormat:@"%lld", sinceId], @"since_id",
                                   [NSString stringWithFormat:@"%lld", maxId], @"max_id",
                                   [NSString stringWithFormat:@"%d", count], @"count"
                                   , nil];
    [super getWithAPIPath:@"statuses/friends_timeline.json"
                   params:params];
}

- (void)queryFriendsTimelineFrom:(long long)sinceId count:(int)count {
    [self queryFriendsTimelineFrom:sinceId maxId:0 count:count];
}

- (void)queryFriendsTimelineToMaxId:(long long)maxId count:(int)count {
    [self queryFriendsTimelineFrom:0 maxId:maxId count:count];
}

- (void)queryFriendsTimelineWithCount:(int)cout {
    [self queryFriendsTimelineFrom:0 maxId:0 count:cout];
}


- (void)requestFailedWithError:(NSError *)error {
    if (_completionBlock) {
        _completionBlock(_request, nil, error);
    }
}

- (void)responseToDelegate:(NSMutableArray *)status {
    if (_completionBlock) {
        _completionBlock(_request, status, nil);
    }
}

- (void)handleResponseObject:(id)object {
    NSMutableArray *statuses = [NSMutableArray array];
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)object;
        NSArray *statusesArray = [dic arrayValueForKey:@"statuses"];
        for (NSDictionary *statusDic in statusesArray) {
            Status *status = [Status statusWithJsonDictionary:statusDic];
            [statuses addObject:status];
        }
    }
    [self performSelectorOnMainThread:@selector(responseToDelegate:) withObject:statuses waitUntilDone:NO];
}

- (void)requestFinishedWithObject:(id)object {
    [self performSelectorInBackground:@selector(handleResponseObject:) withObject:object];
}

@end
