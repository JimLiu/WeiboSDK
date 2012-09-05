//
//  User.m
//  helloWeibo
//
//  Created by junmin liu on 11-4-13.
//  Copyright 2011年 Openlab. All rights reserved.
//

#import "User.h"


@implementation User
@synthesize userId = _userId;
@synthesize screenName = _screenName;
@synthesize profileImageUrl = _profileImageUrl;

- (id)initWithJsonDictionary:(NSDictionary*)dic {
    self = [super init];
    if (self) {
        _userId = [[dic objectForKey:@"id"] longLongValue];
        _screenName = [[dic objectForKey:@"screen_name"] retain];
        _profileImageUrl = [[dic objectForKey:@"profile_image_url"] retain];
    }
    return self;
}


+ (User*)userWithJsonDictionary:(NSDictionary*)dic
{
    User *u = [[User alloc] initWithJsonDictionary:dic];
    return [u autorelease];
}


- (void)dealloc {
    [_screenName release];
    [_profileImageUrl release];
    [super dealloc];
}

@end
