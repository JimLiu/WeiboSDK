//
//  NULDBDB_private.h
//  NULevelDB
//
//  Created by Brent Gulanowski on 11-11-04.
//  Copyright (c) 2011 Nulayer Inc. All rights reserved.
//


#import "NULDBDB.h"
#import "NULDBSlice.h"
#import "NULDBWriteBatch.h"

#import "NULDBUtilities.h"

#include <leveldb/db.h>
#include <leveldb/slice.h>
#include <leveldb/options.h>
#include <leveldb/comparator.h>
#include <leveldb/write_batch.h>


extern int logging;


using namespace leveldb;


@interface NULDBSlice ()
+ (id)objectWithSlice:(Slice&)slice type:(NULDBSliceType)sliceType;
+ (id)objectWithSlice:(Slice&)slice key:(Slice&)keySlice type:(NULDBSliceType *)type;
+ (BOOL)getSlice:(Slice *)slice forObject:(id)object type:(NULDBSliceType)sliceType;
- (id)initWithSlice:(Slice&)slice key:(Slice&)key;
- (id)initWithSlice:(Slice&)slice type:(NULDBSliceType)sliceType;
- (void)getSlice:(Slice *)slice;
@end


@interface NULDBWriteBatch () {
    WriteBatch *writeBatch;
}

@property (readonly) WriteBatch *writeBatch;

- (void)close;

@end


@interface NULDBDB () {
    DB *db;
    ReadOptions readOptions;
    WriteOptions writeOptions;
    Slice *classIndexKey;
    size_t bufferSize;
}
@end


@interface NULDBDB (ErrorConstructing)
+ (NSError *)errorForStatus:(Status *)status;
@end


static inline BOOL NULDBStoreValueForKey(DB *db, WriteOptions &writeOptions, Slice &key, Slice &value, NSError **error) {
    
    Status status = db->Put(writeOptions, key, value);
    
    if(!status.ok()) {
        if(NULL != error)
            *error = [NULDBDB errorForStatus:&status];
        else
            NSLog(@"Failed to store value in database: %s", status.ToString().c_str());
    }
    
    return status.ok();
}

inline BOOL NULDBLoadValueForKey(DB *db, ReadOptions &options, Slice &key, id *retValue, BOOL isString, NSError **error) {
    
    std::string tempValue;
    Status status = db->Get(options, key, &tempValue);
    
    assert(NULL != retValue);
    
    if(!status.IsNotFound()) {
        if(!status.ok()) {
            if(NULL != error) {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSString stringWithUTF8String:status.ToString().c_str()], NSLocalizedDescriptionKey,
                                          //                                          NSLocalizedString(@"", @""), NSLocalizedRecoverySuggestionErrorKey,
                                          nil];
                *error = [NSError errorWithDomain:NULDBErrorDomain code:2 userInfo:userInfo];
            }
            else {
                NSLog(@"Failed to load value from database: %s", status.ToString().c_str());
            }
            
            *retValue = nil;
            
            return NO;
        }
        else {
            
            Slice value = tempValue;
            
            if(isString)
                *retValue = NULDBStringFromSlice(value);
            else
                *retValue = NULDBDataFromSlice(value);
        }
    }
    else
        *retValue = nil;
    
    if(NULL != error)
        *error = nil;
    
    return YES;
}

inline BOOL NULDBDeleteValueForKey(DB *db, WriteOptions &options, Slice &key, NSError **error) {
    
    Status status = db->Delete(options, key);
    
    if(!status.ok() && !status.IsNotFound()) {
        if(NULL != error) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSString stringWithUTF8String:status.ToString().c_str()], NSLocalizedDescriptionKey,
                                      //                                      NSLocalizedString(@"", @""), NSLocalizedRecoverySuggestionErrorKey,
                                      nil];
            *error = [NSError errorWithDomain:NULDBErrorDomain code:3 userInfo:userInfo];
        }
        else {
            NSLog(@"Failed to delete value in database: %s", status.ToString().c_str());
        }
        return NO;
    }
    return YES;
}
