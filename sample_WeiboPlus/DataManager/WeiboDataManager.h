//
//  KeyValueDataManager.h
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-9-7.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimelineStorage.h"




@interface WeiboDataManager : NSObject {
    TimelineQuery *_query;
    StatusTimeline _timeline;
    TimelineStorage *_storage;
}

- (id)initWithStatusTimeline:(StatusTimeline)timeline;


- (void)loadRecentStatus:(int)count;

@end
