//
//  RepostTimelineDataSource.h
//  ZhiWeibo
//
//  Created by Zhang Jason on 1/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatusDataSource.h"

@class Status;
@interface RepostTimelineDataSource : StatusDataSource {
	Status *status;
}

@property (nonatomic,retain) Status *status;

@end
