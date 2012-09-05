//
//  DummyGapStatus.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-10-26.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DummyGapCell;

@interface DummyGapStatus : NSObject {
	DummyGapCell *cell;
	long long statusId;
}

- (id)initWithStatusId:(long long)_statusId;

@property (nonatomic, assign) DummyGapCell *cell;
@property (nonatomic, assign) long long statusId;

@end
