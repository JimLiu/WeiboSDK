//
//  NULDBSerializable.h
//  NULevelDB
//
//  Created by Brent Gulanowski on 11-08-10.
//  Copyright 2011 Nulayer Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


// Object graph serialization support
// Protocol suitable for serializing root objects or internal/leaf nodes
@protocol NULDBSerializable <NSObject>

- (NSString *)storageKey;
- (NSArray *)propertyNames;

@optional
- (void)awakeFromStorage:(NSString *)storageKey;

@end

// Protocol suitable for serializing internal/leaf nodes
@protocol NULDBPlistTransformable <NSObject>

- (id)initWithPropertyList:(NSDictionary *)values;
- (NSDictionary *)plistRepresentation;

@end
