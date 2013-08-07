//
//  NULDBDB+Enumeration.m
//  NULevelDB
//
//  Created by Brent Gulanowski on 11-11-04.
//  Copyright (c) 2011 Nulayer Inc. All rights reserved.
//

#import "NULDBDB.h"

#import "NULDBDB_private.h"


inline void NULDBIterateSlice(DB*db, Slice &start, Slice &limit, BOOL (^block)(Slice &key, Slice &value)) {

    ReadOptions readopts;
    const Comparator *comp = limit.size() > 0 ? BytewiseComparator() : NULL;
    
    readopts.fill_cache = false;
    
    Iterator*iter = db->NewIterator(readopts);
    
    for(start.size() > 0 ? iter->Seek(start) : iter->SeekToFirst();
        iter->Valid() && (NULL == comp || comp->Compare(limit, iter->key()) > 0);
        iter->Next()) {
        
        Slice key = iter->key(), value = iter->value();
        
        if(!block(key, value))
            break;
    }
    
    delete iter;
}

inline void NULDBIterateCoded(DB*db, Slice &start, Slice &limit, BOOL (^block)(id<NSCoding>, id<NSCoding>value)) {
    
    ReadOptions readopts;
    const Comparator *comp = limit.size() > 0 ? BytewiseComparator() : NULL;
    
    readopts.fill_cache = false;
    
    Iterator*iter = db->NewIterator(readopts);
    
    for(start.size() > 0 ? iter->Seek(start) : iter->SeekToFirst();
        iter->Valid() && (NULL == comp || comp->Compare(limit, iter->key()) > 0);
        iter->Next()) {
        
        Slice key = iter->key(), value = iter->value();
        
        if(!block(NULDBObjectFromSlice(key), NULDBObjectFromSlice(value)))
            break;
    }
    
    delete iter;
}

inline void NULDBIterateKeys(DB*db, Slice &start, Slice &limit, BOOL (^block)(NSString *key, NSData *value)) {
    
    ReadOptions readopts;
    const Comparator *comp = limit.size() > 0 ? BytewiseComparator() : NULL;
    
    readopts.fill_cache = false;
    
    Iterator*iter = db->NewIterator(readopts);
    
    for(start.size() > 0 ? iter->Seek(start) : iter->SeekToFirst();
        iter->Valid() && (NULL == comp || comp->Compare(limit, iter->key()) > 0);
        iter->Next()) {
        
        Slice key = iter->key(), value = iter->value();
        
        if(!block(NULDBStringFromSlice(key), NULDBDataFromSlice(value)))
            break;
    }
    
    delete iter;
}

inline void NULDBIterateData(DB*db, Slice &start, Slice &limit, BOOL (^block)(NSData *key, NSData *value)) {
    
    ReadOptions readopts;
    const Comparator *comp = limit.size() > 0 ? BytewiseComparator() : NULL;
    
    readopts.fill_cache = false;
    
    Iterator*iter = db->NewIterator(readopts);
    
    for(start.size() > 0 ? iter->Seek(start) : iter->SeekToFirst();
        iter->Valid() && (NULL == comp || comp->Compare(limit, iter->key()) > 0);
        iter->Next()) {
        
        Slice key = iter->key(), value = iter->value();
        
        if(!block(NULDBDataFromSlice(key), NULDBDataFromSlice(value)))
            break;
    }
    
    delete iter;
}

inline void NULDBIterateIndex(DB*db, Slice &start, Slice &limit, BOOL (^block)(uint64_t, NSData *value)) {
    
    ReadOptions readopts;
    const Comparator *comp = BytewiseComparator();
    
    readopts.fill_cache = false;
    
    Iterator*iter = db->NewIterator(readopts);
    
    for(start.size() > 0 ? iter->Seek(start) : iter->SeekToFirst();
        iter->Valid() && comp->Compare(limit, iter->key()) > 0;
        iter->Next()) {
        
        Slice key = iter->key(), value = iter->value();
        uint64_t index;
        memcpy(&index, key.data(), key.size());
        
        if(!block(index, NULDBDataFromSlice(value)))
            break;
    }
    
    delete iter;
}


@implementation NULDBDB (Enumeration)

- (void)enumerateFrom:(id<NSCoding>)start to:(id<NSCoding>)limit block:(BOOL (^)(id<NSCoding>key, id<NSCoding>value))block {
    Slice startSlice = NULDBSliceFromObject(start);
    Slice limitSlice = NULDBSliceFromObject(limit);
    NULDBIterateCoded(db, startSlice, limitSlice, block);
}

- (NSDictionary *)storedValuesFrom:(id<NSCoding>)start to:(id<NSCoding>)limit {
    
    NSMutableDictionary *tuples = [NSMutableDictionary dictionary];
    
    [self iterateFrom:start to:limit block:^(id<NSCoding>key, id<NSCoding>value) {
        [tuples setObject:value forKey:(id <NSCopying>)key];
        return YES;
    }];
    
    return tuples;
}

- (void)enumerateFromKey:(NSString *)start toKey:(NSString *)limit block:(BOOL (^)(NSString *key, NSData *value))block {
    Slice startSlice = nil == start ? Slice() : NULDBSliceFromString(start);
    Slice limitSlice = nil == limit ? Slice() : NULDBSliceFromString(limit);
    NULDBIterateKeys(db, startSlice, limitSlice, block);
}

- (NSDictionary *)storedValuesFromKey:(NSString *)start toKey:(NSString *)limit {
    
    NSMutableDictionary *tuples = [NSMutableDictionary dictionary];
    
    [self iterateFromKey:start toKey:limit block:^BOOL(NSString *key, NSData *value) {
        [tuples setObject:value forKey:key];
        return YES;
    }];
    
    return tuples;
}

- (void)enumerateFromData:(NSData *)start toData:(NSData *)limit block:(BOOL (^)(NSData *key, NSData *value))block {
    Slice startSlice = nil == start ? Slice() : NULDBSliceFromData(start);
    Slice limitSlice = nil == limit ? Slice() : NULDBSliceFromData(limit);
    NULDBIterateData(db, startSlice, limitSlice, block);
}

- (NSDictionary *)storedValuesFromData:(NSData *)start toData:(NSData *)limit {
    
    NSMutableDictionary *tuples = [NSMutableDictionary dictionary];
    
    [self iterateFromData:start toData:limit block:^(NSData *key, NSData *value) {
        [tuples setObject:value forKey:key];
        return YES;
    }];
    
    return tuples;
}

- (void)enumerateFromIndex:(uint64_t)start to:(uint64_t)limit block:(BOOL (^)(uint64_t key, NSData *value))block {
    Slice startSlice((char *)start, sizeof(uint64_t));
    Slice limitSlice((char *)limit, sizeof(uint64_t));
    NULDBIterateIndex(db, startSlice, limitSlice, block);
}

- (NSArray *)storedValuesFromIndex:(uint64_t)start to:(uint64_t)limit {
    
    NSMutableArray *array = [NSMutableArray array];
    
    [self iterateFromIndex:start to:limit block:^(uint64_t key, NSData *data) {
        [array addObject:data];
        return YES;
    }];
    
    return array;
}

- (void)enumerateAllEntriesWithBlock:(BOOL (^)(NSData *key, NSData *value))block {
    
    ReadOptions readopts;
    
    readopts.fill_cache = false;
    
    Iterator*iter = db->NewIterator(readopts);
    
    for(iter->SeekToFirst(); iter->Valid(); iter->Next()) {
        
        Slice key = iter->key(), value = iter->value();
        
        if(!block(NULDBDataFromSlice(key), NULDBDataFromSlice(value)))
            break;
    }
    
    delete iter;
}


@end
