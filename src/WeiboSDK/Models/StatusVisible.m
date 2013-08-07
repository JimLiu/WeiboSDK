//
//  StatusVisible.m
//  WeiboSDK
//
//  Created by Liu Jim on 8/3/13.
//  Copyright (c) 2013 openlab. All rights reserved.
//

#import "StatusVisible.h"
#import "NSDictionary+Json.h"

@implementation StatusVisible

- (id)initWithJsonDictionary:(NSDictionary*)dic
{
	self = [super init];
    if (self) {
        self.visibleType = [dic intValueForKey:@"type"];
        self.groupId = [dic intValueForKey:@"list_id"];
    }
    return self;
}

//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInt:self.visibleType forKey:@"visibleType"];
    [encoder encodeInt:self.groupId forKey:@"groupId"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.visibleType = [decoder decodeIntForKey:@"visibleType"];
        self.groupId = [decoder decodeIntForKey:@"groupId"];
    }
    return self;
}


@end
