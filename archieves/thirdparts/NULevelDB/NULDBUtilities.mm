//
//  NULDBUtilities.m
//  NULevelDB
//
//  Created by Brent Gulanowski on 11-08-10.
//  Copyright 2011 Nulayer Inc. All rights reserved.
//

#import "NULDBUtilities.h"


Class stringClass;
Class dataClass;
Class dictClass;
Class arrayClass;


NSData *NULDBEncodedObject(id<NSCoding>object) {
    
    char type = 'o';
    
    if([(id)object isKindOfClass:stringClass])    type = 's';
    else if([(id)object isKindOfClass:dataClass]) type = 'd';
    else if([(id)object isKindOfClass:dictClass] || [(id)object isKindOfClass:arrayClass]) type = 'h';
    
    NSMutableData *d = [NSMutableData dataWithBytes:&type length:1];
    
    switch (type) {
        case 's':
            [d appendData:[(NSString *)object dataUsingEncoding:NSUTF8StringEncoding]];
            break;
            
        case 'd':
            [d appendData:(NSData *)object];
            break;
            
        case 'h':
            [d appendData:[NSPropertyListSerialization dataWithPropertyList:(id)object format:NSPropertyListBinaryFormat_v1_0 options:0 error:NULL]];
            break;
            
        default:
            [d appendData:[NSKeyedArchiver archivedDataWithRootObject:object]];
            break;
    }
    
    return d;
}

extern id NULDBDecodedObject(NSData *data) {
    
    NSData *value = [data subdataWithRange:NSMakeRange(1, [data length] - 1)];
    
    char type;
    
    [data getBytes:&type length:1];
    
    switch (type) {
        case 's':
            return [[[NSString alloc] initWithData:value encoding:NSUTF8StringEncoding] autorelease];
            break;
            
        case 'd':
            return value;
            break;
            
        case 'h':
            return [NSPropertyListSerialization propertyListWithData:value options:NSPropertyListImmutable format:NULL error:NULL];
            break;
            
        default:
            break;
    }
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}


@implementation NULDBUtilities

@end
