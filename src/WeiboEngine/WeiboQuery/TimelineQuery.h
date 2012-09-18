//
//  StatusesQuery.h
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-9-5.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "WeiboQuery.h"
#import "WeiboRequest.h"
#import "User.h"
#import "Status.h"

@interface TimelineQuery : WeiboQuery {
    void (^_completionBlock)(WeiboRequest *request, NSMutableArray *statuses, NSError *error);
}

@property (copy) void (^completionBlock)(WeiboRequest *request, NSMutableArray *statuses, NSError *error);

+ (TimelineQuery *)query;

- (void)queryFriendsTimelineFrom:(long long)sinceId maxId:(long long)maxId count:(int)count;
- (void)queryFriendsTimelineFrom:(long long)sinceId count:(int)count;
- (void)queryFriendsTimelineToMaxId:(long long)maxId count:(int)count;
- (void)queryFriendsTimelineWithCount:(int)cout;


@end
