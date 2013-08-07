//
//  TimelineQuery.h
//  WeiboSDK
//
//  Created by Liu Jim on 8/4/13.
//  Copyright (c) 2013 openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboQuery.h"
#import "WeiboRequest.h"
#import "User.h"
#import "Status.h"
#import "WeiboConfig.h"

typedef enum {
    StatusTimelineFriends = 0,
    StatusTimelineMentions = 1,
} StatusTimeline;

typedef void(^WeiboQueryCompletionBlock)(WeiboRequest *request, NSMutableArray *statuses, NSError *error);

@interface TimelineQuery : WeiboQuery

- (id)initWithCompletionBlock:(WeiboQueryCompletionBlock)completionBlock;

@property (copy) WeiboQueryCompletionBlock completionBlock;

- (void)queryPublicTimelineWithCount:(int)count;

- (void)queryTimeline:(StatusTimeline)timeline sinceId:(long long)sinceId
                maxId:(long long)maxId count:(int)count;
- (void)queryTimeline:(StatusTimeline)timeline sinceId:(long long)sinceId
                count:(int)count;
- (void)queryTimeline:(StatusTimeline)timeline maxId:(long long)maxId
                count:(int)count;
- (void)queryTimeline:(StatusTimeline)timeline count:(int)cout;

@end
