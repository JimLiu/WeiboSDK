//
//  NULDBDB.h
//  NULevelDB
//
//  Created by Brent Gulanowski on 11-07-29.
//  Copyright 2011 Nulayer Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NULDBSlice.h"
#import "NULDBSerializable.h"


extern NSString *NULDBErrorDomain;


@class NULDBWriteBatch;

@interface NULDBDB : NSObject

//@property (nonatomic, assign) NULDBSliceType keyType;
@property (nonatomic, retain) NSString *location;
@property (nonatomic) BOOL sync;
@property (nonatomic, getter=isCacheEnabled) BOOL cacheEnabled;

// size is the write buffer size; default is 4MB
- (id)initWithLocation:(NSString *)path bufferSize:(NSUInteger)size;
- (id)initWithLocation:(NSString *)path;

- (void)compact;
- (void)reopen;  // closes and opens the database; triggers a variety of maintenance routines on open
- (void)destroy; // Deprecated - call +destroyDatabase: when you have no active pointers to your db

// works like a stack (counter); feel free to use indiscriminately
+ (void)enableLogging;
+ (void)disableLogging;

// User Library folder "Store.db"
+ (NSString *)defaultLocation;

// Erases the database files (files are created automatically)
+ (void)destroyDatabase:(NSString *)path;

//// Batch write support
- (BOOL)putValue:(NULDBSlice *)value forKey:(NULDBSlice *)key error:(NSError **)error;
- (NULDBSlice *)getValueForKey:(NULDBSlice *)key type:(NULDBSliceType)type error:(NSError **)error;
//- (NULDBSlice *)getValueForKey:(NULDBKey *)key error:(NSError **)error; // infers from key - TODO
- (BOOL)deleteValueForKey:(NULDBSlice *)key error:(NSError **)error;
- (BOOL)writeBatch:(NULDBWriteBatch *)writeBatch error:(NSError **)error;

//// Basic key-value support
- (BOOL)storeValue:(id<NSCoding>)value forKey:(id<NSCoding>)key;
- (id)storedValueForKey:(id<NSCoding>)key;
- (BOOL)deleteStoredValueForKey:(id<NSCoding>)key;
- (BOOL)storedValueExistsForKey:(id<NSCoding>)key;

//// Streamlined key-value support for pre-encoded Data objects
// Data keys
- (BOOL)storeData:(NSData *)data forDataKey:(NSData *)key error:(NSError **)error;
- (NSData *)storedDataForDataKey:(NSData *)key error:(NSError **)error;
- (BOOL)deleteStoredDataForDataKey:(NSData *)key error:(NSError **)error;
- (BOOL)storedDataExistsForDataKey:(NSData *)key;

// String keys - string<->data key conversion provided by optional block
// This will allow the client to replace string keys with optimized data keys of its own preference
- (BOOL)storeData:(NSData *)data forKey:(NSString *)key translator:(NSData *(^)(NSString *))block error:(NSError **)error;
- (NSData *)storedDataForKey:(NSString *)key translator:(NSData *(^)(NSString *))block error:(NSError **)error;
- (BOOL)deleteStoredDataForKey:(NSString *)key translator:(NSData *(^)(NSString *))block error:(NSError **)error;

// String keys - encoded as-is (UTF8 data)
- (BOOL)storeData:(NSData *)data forKey:(NSString *)key error:(NSError **)error;
- (NSData *)storedDataForKey:(NSString *)key error:(NSError **)error;
- (BOOL)deleteStoredDataForKey:(NSString *)key error:(NSError **)error;
- (BOOL)storedDataExistsForKey:(NSString *)key;

// string keys and string values encoded as UTF8 data; use deletion methods above
- (BOOL)storeString:(NSString *)string forKey:(NSString *)key error:(NSError **)error;
- (NSString *)storedStringForKey:(NSString *)key error:(NSError **)error;
- (BOOL)storedStringExistsForKey:(NSString *)key;

// 64-bit binary keys and data values
- (BOOL)storeData:(NSData *)data forIndexKey:(uint64_t)key error:(NSError **)error;
- (NSData *)storedDataForIndexKey:(uint64_t)key error:(NSError **)error;
- (BOOL)deleteStoredDataForIndexKey:(uint64_t)key error:(NSError **)error;
- (BOOL)storedDataExistsForIndexKey:(uint64_t)key;

@end


@interface NULDBDB (BulkAccess)

// Generalized
- (BOOL)storeValuesFromDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)storedValuesForKeys:(NSArray *)keys;
- (BOOL)deleteStoredValuesForKeys:(NSArray *)keys;

// Data values and keys
- (BOOL)storeDataFromDictionary:(NSDictionary *)dictionary error:(NSError **)error;
- (NSDictionary *)storedDataForKeys:(NSArray *)keys error:(NSError **)error;
- (BOOL)deleteStoredDataForKeys:(NSArray *)keys error:(NSError **)error;

// String values and keys
- (BOOL)storeStringsFromDictionary:(NSDictionary *)dictionary error:(NSError **)error;
- (NSDictionary *)storedStringsForKeys:(NSArray *)keys error:(NSError **)error;
- (BOOL)deleteStoredStringsForKeys:(NSArray *)keys error:(NSError **)error;

// data values and uint64_t and keys
- (BOOL)storeDataFromArray:(NSArray *)array forIndexes:(uint64_t *)indexes error:(NSError **)error;
- (NSArray *)storedDataForIndexes:(uint64_t *)indexes count:(NSUInteger)count error:(NSError **)error;
- (BOOL)deleteStoredDataForIndexes:(uint64_t *)indexes count:(NSUInteger)count error:(NSError **)error;

@end


@interface NULDBDB (Enumeration)

// nil start value means start at first key; nil limit means proceed to last key
- (void)enumerateFrom:(id<NSCoding>)start to:(id<NSCoding>)limit block:(BOOL (^)(id<NSCoding>key, id<NSCoding>value))block;
- (NSDictionary *)storedValuesFrom:(id<NSCoding>)start to:(id<NSCoding>)limit;

- (void)enumerateFromKey:(NSString *)start toKey:(NSString *)limit block:(BOOL (^)(NSString *key, NSData *value))block;
- (NSDictionary *)storedValuesFromKey:(NSString *)start toKey:(NSString *)limit;

- (void)enumerateFromData:(NSData *)start toData:(NSData *)limit block:(BOOL (^)(NSData *key, NSData *value))block;
- (NSDictionary *)storedValuesFromData:(NSData *)start toData:(NSData *)limit;

- (void)enumerateFromIndex:(uint64_t)start to:(uint64_t)limit block:(BOOL (^)(uint64_t key, NSData *value))block;
- (NSArray *)storedValuesFromIndex:(uint64_t)start to:(uint64_t)limit;

- (void)enumerateAllEntriesWithBlock:(BOOL (^)(NSData *key, NSData *value))block;

@end



@interface NULDBDB (Serializing)
- (void)storeObject:(NSObject<NULDBSerializable> *)obj;
- (id)storedObjectForKey:(NSString *)key;
- (void)deleteStoredObjectForKey:(NSString *)key;
@end


@interface NULDBDB (SizeEstimation)
- (NSUInteger)currentFileSizeEstimate;
- (NSUInteger)sizeForKeyRangeFrom:(NSString *)start to:(NSString *)limit;
- (NSUInteger)currentSizeEstimate;
- (NSUInteger)sizeUsedByKey:(NSString *)key;
@end


@interface NULDBDB (Deprecated)
- (void)iterateFrom:(id<NSCoding>)start to:(id<NSCoding>)limit block:(BOOL (^)(id<NSCoding>key, id<NSCoding>value))block;
- (void)iterateFromKey:(NSString *)start toKey:(NSString *)limit block:(BOOL (^)(NSString *key, NSData *value))block;
- (void)iterateFromData:(NSData *)start toData:(NSData *)limit block:(BOOL (^)(NSData *key, NSData *value))block;
- (void)iterateFromIndex:(uint64_t)start to:(uint64_t)limit block:(BOOL (^)(uint64_t key, NSData *value))block;
@end
