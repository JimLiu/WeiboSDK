//
//  NULDBWriteBatch.h
//  NULevelDB
//
//  Created by Brent Gulanowski on 11-11-14.
//  Copyright (c) 2011 Nulayer Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@class NULDBSlice;

@interface NULDBWriteBatch : NSObject

@property (readonly) BOOL written;

- (void)putValue:(NULDBSlice *)value forKey:(NULDBSlice *)key;
- (void)deleteValueForKey:(NULDBSlice *)key;

@end
