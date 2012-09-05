//
//  UserTimelineDataSource.h
//  ZhiWeibo
//
//  Created by Zhang Jason on 12/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatusDataSource.h"
#import "User.h"


@interface UserTimelineDataSource : StatusDataSource {
	long long userId;
}

@property(nonatomic,assign) long long userId;

@end
