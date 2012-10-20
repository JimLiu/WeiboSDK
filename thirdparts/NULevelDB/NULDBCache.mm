//
//  NULDBCache.m
//  NULevelDB
//
//  Created by Brent Gulanowski on 11-07-29.
//  Copyright 2011 Nulayer Inc. All rights reserved.
//

#import "NULDBCache.h"

#include <leveldb/cache.h>

using namespace leveldb;


@implementation NULDBCache {
    Cache *cache;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end
