//
//  NULDBUtilities.h
//  NULevelDB
//
//  Created by Brent Gulanowski on 11-08-10.
//  Copyright 2011 Nulayer Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <leveldb/db.h>


using namespace leveldb;


#define NULDBLog(frmt, ...) do{ if(logging) NSLog((frmt), ##__VA_ARGS__); } while(0)


#define NULDBSliceFromData(_data_) (Slice((char *)[_data_ bytes], [_data_ length]))
#define NULDBDataFromSlice(_slice_) ([NSData dataWithBytes:_slice_.data() length:_slice_.size()])

#define NULDBSliceFromString(_string_) (Slice((char *)[_string_ UTF8String], [_string_ lengthOfBytesUsingEncoding:NSUTF8StringEncoding]))
#define NULDBStringFromSlice(_slice_) ([[[NSString alloc] initWithBytes:_slice_.data() length:_slice_.size() encoding:NSUTF8StringEncoding] autorelease])


extern Class stringClass;
extern Class dataClass;
extern Class dictClass;
extern Class arrayClass;


extern NSData *NULDBEncodedObject(id<NSCoding>object);
extern id NULDBDecodedObject(NSData *data);

static inline Slice NULDBSliceFromObject(id<NSCoding> object) {
    if(nil == object) return Slice();
    NSData *d = NULDBEncodedObject(object);
    return Slice((const char *)[d bytes], (size_t)[d length]);
}

static inline id NULDBObjectFromSlice(Slice &slice) {
    return NULDBDecodedObject([NSData dataWithBytes:slice.data() length:slice.size()]);
}


@interface NULDBUtilities : NSObject

@end
