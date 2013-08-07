//
//  WeiboAccount.m
//  WeiboSDK
//
//  Created by Liu Jim on 8/3/13.
//  Copyright (c) 2013 openlab. All rights reserved.
//

#import "WeiboAccount.h"

@implementation WeiboAccount

- (id)init {
    self = [super init];
    return self;
}

- (id)initWithAuthentication:(WeiboAuthentication *)auth
                        user:(User *)user {
    self = [super init];
    if (self) {
        self.accessToken = auth.accessToken;
        self.userId = auth.userId;
        self.expirationDate = auth.expirationDate;
        self.user = user;
    }
    return self;
}

//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.userId forKey:@"userId"];
    [encoder encodeObject:self.accessToken forKey:@"accessToken"];
    [encoder encodeObject:self.expirationDate forKey:@"expirationDate"];
    [encoder encodeObject:self.user forKey:@"user"];
    [encoder encodeBool:self.selected forKey:@"selected"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.userId = [decoder decodeObjectForKey:@"userId"];
        self.accessToken = [decoder decodeObjectForKey:@"accessToken"];
        self.expirationDate = [decoder decodeObjectForKey:@"expirationDate"];
        self.user = [decoder decodeObjectForKey:@"user"];
        self.selected = [decoder decodeBoolForKey:@"selected"];
    }
    return self;
}

@end
