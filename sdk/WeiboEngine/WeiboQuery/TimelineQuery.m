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

- (NSString *)apiUrl:(StatusTimeline)timeline {
    if (timeline == StatusTimelineMentions) {
        return @"statuses/mentions.json";
    }
    return @"statuses/friends_timeline.json";
}

- (void)queryTimeline:(StatusTimeline)timeline sinceId:(long long)sinceId
                maxId:(long long)maxId count:(int)count {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [NSString stringWithFormat:@"%lld", sinceId], @"since_id",
                                   [NSString stringWithFormat:@"%lld", maxId], @"max_id",
                                   [NSString stringWithFormat:@"%d", count], @"count"
                                   , nil];
    [super getWithAPIPath:[self apiUrl:timeline]
                   params:params];
}

- (void)queryTimeline:(StatusTimeline)timeline sinceId:(long long)sinceId
                count:(int)count {
    [self queryTimeline:timeline sinceId:sinceId maxId:0 count:count];
}

- (void)queryTimeline:(StatusTimeline)timeline maxId:(long long)maxId
                count:(int)count {
    [self queryTimeline:timeline sinceId:0 maxId:maxId count:count];
}

- (void)queryTimeline:(StatusTimeline)timeline count:(int)count {
    [self queryTimeline:timeline sinceId:0 maxId:0 count:count];
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
