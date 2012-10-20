//
//  TimelineStorage.h
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-9-11.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimelineQuery.h"
#import "DBAccess.h"


@interface TimelineStorage : NSObject {
    StatusTimeline _timeline;
    NSMutableArray *_statusIds;
    DBAccess *_dbAccess;
}

- (id)initWithStatusTimeline:(StatusTimeline)timeline;

- (NSMutableArray *)getStatusIds;
- (void)saveStatusIds:(NSMutableArray *)statusIds;

@end
