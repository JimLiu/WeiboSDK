//
//  NULDBSlice.h
//  NULevelDB
//
//  Created by Brent Gulanowski on 11-07-29.
//  Copyright 2011 Nulayer Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    kNULDBSliceTypeUndefined = 0,
    kNULDBSliceTypeArchive,
    kNULDBSliceTypeString,
    kNULDBSliceTypeData,
    kNULDBSliceTypeIndex64,
    kNULDBSliceTypeEncoded,
} NULDBSliceType;

@interface NULDBSlice : NSObject {
    id object;
    NULDBSliceType type;
}

@property (nonatomic, retain, readonly) id object;
@property (nonatomic, assign) NULDBSliceType type;

/*
 * if the type is undefined, it will be inferred;
 * if the type is not supported (cannot be encoded as data), throws invalid argument exception
 */
- (id)initWithObject:(id)object type:(NULDBSliceType)sliceType;
- (id)initWithPersistentObject:(id<NSCoding>)object;
- (id)initWithData:(NSData *)data;
- (id)initWithString:(NSString *)string;
- (id)initWithPropertyList:(id)plist;

+ (NULDBSliceType)typeForObject:(id)object;

@end

// 
@interface NULDBKey : NULDBSlice
@end


@interface NULDBEntry : NSObject {
@private
    NULDBKey *key;
    NULDBSlice *value;
}
@end


@interface NULDBKeyEncoder : NSObject

@end



@interface NULDBKeyDecoder : NSObject

@end
