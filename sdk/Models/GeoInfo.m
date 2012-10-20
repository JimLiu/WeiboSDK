//
//  Geo.m
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-9-5.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "GeoInfo.h"

@implementation GeoInfo
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;

- (id)initWithJsonDictionary:(NSDictionary*)dic
{
	self = [super init];
    if (self) {
        NSArray *coordinatesArray = [dic arrayValueForKey:@"coordinates"];
        if (coordinatesArray && coordinatesArray.count == 2) {
            self.latitude = [[coordinatesArray objectAtIndex:0] doubleValue];
            self.longitude = [[coordinatesArray objectAtIndex:1] doubleValue];
        }
    }
    return self;
}

//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeDouble:self.latitude forKey:@"latitude"];
    [encoder encodeDouble:self.longitude forKey:@"longitude"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.latitude = [decoder decodeDoubleForKey:@"latitude"];
        self.longitude = [decoder decodeDoubleForKey:@"longitude"];
    }
    return self;
}

@end
