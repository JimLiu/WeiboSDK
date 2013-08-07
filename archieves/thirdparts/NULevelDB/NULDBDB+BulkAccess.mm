//
//  NULDBDB+BulkAccess.m
//  NULevelDB
//
//  Created by Brent Gulanowski on 11-11-04.
//  Copyright (c) 2011 Nulayer Inc. All rights reserved.
//

#import "NULDBDB_private.h"


@implementation NULDBDB (BulkAccess)

- (BOOL)storeValuesFromDictionary:(NSDictionary *)dictionary {
    
    for(id key in [dictionary allKeys]) {
        if(![self storeValue:[dictionary objectForKey:key] forKey:key])
            return NO;
    }
    
    return YES;
}

- (NSDictionary *)storedValuesForKeys:(NSArray *)keys {
    
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:[keys count]];
    
    for(id key in keys) {
        
        id value = [self storedValueForKey:key];
        
        if(nil != value)
            [result setObject:value forKey:key];
    }
    
    return [NSDictionary dictionaryWithDictionary:result];
}

- (BOOL)deleteStoredValuesForKeys:(NSArray *)keys {
    
    for(id key in keys) {
        if(![self deleteStoredValueForKey:key])
            return NO;
    }
    
    return YES;
}

// Data values and keys
- (BOOL)storeDataFromDictionary:(NSDictionary *)dictionary error:(NSError **)error {
    
    for(id key in [dictionary allKeys]) {
        
        Slice k = NULDBSliceFromData(key), v = NULDBSliceFromData([dictionary objectForKey:key]);
        
        if(!NULDBStoreValueForKey(db, writeOptions, k, v, error))
            return NO;
    }
    
    return YES;
}

- (NSDictionary *)storedDataForKeys:(NSArray *)keys error:(NSError **)error {
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:[keys count]];
    
    for(id key in keys) {
        
        NSData *result = nil;
        Slice k = NULDBSliceFromData(key);
        if(!NULDBLoadValueForKey(db, readOptions, k, &result, NO, error)) {
            if (4 == [*error code])
                continue;
            else
                return nil;
        }
        
        [dictionary setObject:result forKey:key]; 
    }
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)deleteStoredDataForKeys:(NSArray *)keys error:(NSError **)error {
    
    for(id key in keys) {
        
        Slice k = NULDBSliceFromData(key);
        if(!NULDBDeleteValueForKey(db, writeOptions, k, error))
            return NO;
    }
    
    return YES;
}

- (BOOL)storeDataFromArray:(NSArray *)array forIndexes:(uint64_t *)indexes error:(NSError **)error {
    
    uint64_t *currentIndex = indexes;
    
    for(NSData *data in array) {
        
        Slice k((char *)currentIndex++, sizeof(uint64_t)), v = NULDBSliceFromData(data);
        if(!NULDBStoreValueForKey(db, writeOptions, k, v, error))
            return NO;
    }
    
    return YES;
}

- (NSArray *)storedDataForIndexes:(uint64_t *)indexes count:(NSUInteger)count error:(NSError **)error {
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    
    NSData *result = nil;
    
    for(int i=0; i<count; ++i) {
        
        uint64_t index = indexes[i];
        Slice k((char *)&index, sizeof(uint64_t));
        if(!NULDBLoadValueForKey(db, readOptions, k, &result, NO, error)) {
            if (4 == [*error code])
                continue;
            else
                return nil;
        }
        
        [array addObject:result];
    }
    
    return [NSArray arrayWithArray:array];
}

- (BOOL)deleteStoredDataForIndexes:(uint64_t *)indexes count:(NSUInteger)count error:(NSError **)error {
    
    for(NSUInteger i=0; i<count; ++i) {
        Slice k((char *)(indexes+i), sizeof(uint64_t));
        if(!NULDBDeleteValueForKey(db, writeOptions, k, error))
            return NO;
    }
    
    return YES;
}


// String values and keys
- (BOOL)storeStringsFromDictionary:(NSDictionary *)dictionary error:(NSError **)error {
    
    for(id key in [dictionary allKeys]) {
        
        Slice k = NULDBSliceFromString(key), v = NULDBSliceFromString([dictionary objectForKey:key]);
        
        if(!NULDBStoreValueForKey(db, writeOptions, k, v, error))
            return NO;
    }
    
    return YES;
}

- (NSDictionary *)storedStringsForKeys:(NSArray *)keys error:(NSError **)error {
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:[keys count]];
    
    for(id key in keys) {
        
        NSString *result = nil;
        Slice k = NULDBSliceFromString(key);
        if(!NULDBLoadValueForKey(db, readOptions, k, &result, YES, error)) {
            if (4 == [*error code])
                continue;
            else
                return nil;
        }
        
        [dictionary setObject:result forKey:key];
    }
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)deleteStoredStringsForKeys:(NSArray *)keys error:(NSError **)error {
    
    for(id key in keys) {
        
        Slice k = NULDBSliceFromString(key);
        if(! NULDBDeleteValueForKey(db, writeOptions, k, error))
            return NO;
    }
    
    return YES;
}

@end
