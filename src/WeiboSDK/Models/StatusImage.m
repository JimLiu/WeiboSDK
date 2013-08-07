//
//  StatusImage.m
//  WeiboSDK
//
//  Created by Liu Jim on 8/3/13.
//  Copyright (c) 2013 openlab. All rights reserved.
//

#import "StatusImage.h"
#import "NSDictionary+Json.h"

@implementation StatusImage


- (id)initWithJsonDictionary:(NSDictionary*)dic
{
	self = [super init];
    if (self) {
        self.middleImageUrl = [dic stringValueForKey:@"bmiddle_pic"];
        self.originalImageUrl = [dic stringValueForKey:@"original_pic"];
        self.thumbnailImageUrl = [dic stringValueForKey:@"thumbnail_pic"];
        if (self.originalImageUrl.length == 0) {
            self.originalImageUrl = [self.thumbnailImageUrl stringByReplacingOccurrencesOfString:@"/thumbnail/" withString:@"/large/"];
        }
        if (self.middleImageUrl.length == 0) {
            self.middleImageUrl = [self.thumbnailImageUrl stringByReplacingOccurrencesOfString:@"/thumbnail/" withString:@"/bmiddle/"];
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
    [encoder encodeObject:self.middleImageUrl forKey:@"middleImageUrl"];
    [encoder encodeObject:self.originalImageUrl forKey:@"originalImageUrl"];
    [encoder encodeObject:self.thumbnailImageUrl forKey:@"thumbnailImageUrl"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.middleImageUrl = [decoder decodeObjectForKey:@"middleImageUrl"];
        self.originalImageUrl = [decoder decodeObjectForKey:@"originalImageUrl"];
        self.thumbnailImageUrl = [decoder decodeObjectForKey:@"thumbnailImageUrl"];
    }
    return self;
}



@end
