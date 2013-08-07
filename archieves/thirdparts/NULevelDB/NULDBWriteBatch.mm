//
//  NULDBWriteBatch.m
//  NULevelDB
//
//  Created by Brent Gulanowski on 11-11-14.
//  Copyright (c) 2011 Nulayer Inc. All rights reserved.
//

#import "NULDBWriteBatch.h"
#import "NULDBDB_private.h"

#import "NULDBSlice.h"

#include <leveldb/write_batch.h>


using namespace leveldb;


@implementation NULDBWriteBatch

@synthesize writeBatch, written;

- (void)dealloc {
    if(NULL != writeBatch)
        delete writeBatch, writeBatch = NULL;
    [super dealloc];
}

- (id)init {
    self = [super init];
    if(self) {
        writeBatch = new WriteBatch();
    }
    return self;
}

- (void)putValue:(NULDBSlice *)value forKey:(NULDBSlice *)key {
    Slice v;
    Slice k;
    [value getSlice:&v];
    [key getSlice:&k];
    
    writeBatch->Put(k, v);
}

- (void)deleteValueForKey:(NULDBSlice *)key {
    Slice k;
    [key getSlice:&k];
    writeBatch->Delete(k);
}

- (void)close {
    written = YES;
}

@end
