//
//  NULDBSlice.m
//  NULevelDB
//
//  Created by Brent Gulanowski on 11-07-29.
//  Copyright 2011 Nulayer Inc. All rights reserved.
//

#import "NULDBSlice.h"

#import "NULDBUtilities.h"

#include <leveldb/slice.h>


using namespace leveldb;


@interface NULDBSlice ()
@property (nonatomic, retain, readwrite) id object;
@end


@implementation NULDBSlice

@synthesize object, type;

#pragma mark - NULevelDBPrivate (see NULDBDB_private.h)
+ (NULDBSliceType)typeForObject:(id)object {
    if([object isKindOfClass:[NSString class]])         return kNULDBSliceTypeString;
    if([object isKindOfClass:[NSData class]])           return kNULDBSliceTypeData;
    if([object conformsToProtocol:@protocol(NSCoding)]) return kNULDBSliceTypeArchive;
    return kNULDBSliceTypeUndefined;
}

+ (NULDBSliceType)typeForSlice:(Slice&)slice {
    return kNULDBSliceTypeUndefined;
}

+ (NULDBSliceType)valueTypeForKey:(Slice&)slice {
    return kNULDBSliceTypeUndefined;
}

+ (id)objectWithSlice:(Slice&)slice type:(NULDBSliceType)sliceType {
    
    id result = nil;

    if(kNULDBSliceTypeUndefined == sliceType) sliceType = [self typeForSlice:slice];
    
    switch (sliceType) {
        case kNULDBSliceTypeArchive:
            result = NULDBDecodedObject([NSData dataWithBytes:slice.data() length:slice.size()]);
            break;
            
        case kNULDBSliceTypeData:
            result = NULDBDataFromSlice(slice);
            break;
            
        case kNULDBSliceTypeString:
            result = NULDBStringFromSlice(slice);
            break;
            
        case kNULDBSliceTypeUndefined:
        default:
            [NSException raise:NSInvalidArgumentException format:@"Cannot determine type of stored data"];
            break;
    }
    
    return result;
}

+ (id)objectWithSlice:(Slice&)slice key:(Slice&)keySlice type:(NULDBSliceType *)type {
    NULDBSliceType sliceType = [self valueTypeForKey:keySlice];
    if(NULL != type) *type = sliceType;
    return [self objectWithSlice:slice type:sliceType];
}

+ (BOOL)getSlice:(Slice *)slice forObject:(id)object type:(NULDBSliceType)sliceType {

    NSParameterAssert(NULL != slice);
    NSParameterAssert(nil != object);
    
    if(kNULDBSliceTypeUndefined == sliceType) sliceType = [self typeForObject:object];
    
    switch (sliceType) {
        case kNULDBSliceTypeArchive:
            *slice = NULDBSliceFromObject(object);
            break;
            
        case kNULDBSliceTypeData:
            *slice = NULDBSliceFromData(object);
            break;
            
        case kNULDBSliceTypeString:
            *slice = NULDBSliceFromString(object);
            break;
            
        case kNULDBSliceTypeUndefined:
        default:
            [NSException raise:NSInvalidArgumentException format:@"Cannot determine storage type of provided object"];
            break;
    }

    return NO;
}

- (id)initWithSlice:(Slice&)slice key:(Slice&)key {
    NULDBSliceType sliceType = kNULDBSliceTypeUndefined;
    return [self initWithObject:[NULDBSlice objectWithSlice:slice key:key type:&sliceType] type:sliceType];
}

- (id)initWithSlice:(Slice&)slice type:(NULDBSliceType)sliceType {
    return [self initWithObject:[NULDBSlice objectWithSlice:slice type:sliceType] type:sliceType];
}

- (void)getSlice:(Slice *)slice {
    [NULDBSlice getSlice:slice forObject:self.object type:self.type];
}


#pragma mark - NSObject
- (void)dealloc {
    self.object = nil;
    type = kNULDBSliceTypeUndefined;
    [super dealloc];
}


#pragma mark - Designated Initializer
- (id)initWithObject:(id)obj type:(NULDBSliceType)sliceType {
    self = [self init];
    if(self) {
        self.object = obj;
        self.type = sliceType;
    }
    
    return self;
}


#pragma mark - Convenience Initializers
- (id)initWithPersistentObject:(id<NSCoding>)obj {
    return [self initWithObject:obj type:kNULDBSliceTypeArchive];
}

- (id)initWithData:(NSData *)data {
    return [self initWithObject:data type:kNULDBSliceTypeData];
}

- (id)initWithString:(NSString *)string {
    return [self initWithObject:string type:kNULDBSliceTypeString];
}

- (id)initWithPropertyList:(id)plist {
    
    NSError *error = nil;
    NSData *data = [NSPropertyListSerialization dataWithPropertyList:plist
                                                              format:NSPropertyListBinaryFormat_v1_0
                                                             options:0
                                                               error:&error];
    if(nil == error) {
        NSLog(@"Could not instantiate data for property list %@; error: %@", plist, error);
        [self release];
        return nil;
    }
    
    return [self initWithObject:data type:kNULDBSliceTypeData];
}

@end


@implementation NULDBKey

- (id)initWithData:(NSData *)data {
    [self release];
    return nil;
}

- (id)initWithString:(NSString *)string {
    [self release];
    return nil;
}

@end


@implementation NULDBKeyEncoder



@end


@implementation NULDBKeyDecoder



@end
