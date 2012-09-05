//
//  WeiboAccount.m
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-8-20.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "WeiboAccount.h"

@implementation WeiboAccount
@synthesize userId = _userId;
@synthesize accessToken = _accessToken;
@synthesize expirationDate = _expirationDate;
@synthesize screenName = _screenName;
@synthesize profileImageUrl = _profileImageUrl;
@synthesize selected = _selected;


//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.userId forKey:@"userId"];
    [encoder encodeObject:self.accessToken forKey:@"accessToken"];
    [encoder encodeObject:self.expirationDate forKey:@"expirationDate"];
    [encoder encodeObject:self.screenName forKey:@"screenName"];
    [encoder encodeObject:self.profileImageUrl forKey:@"profileImageUrl"];
    [encoder encodeBool:self.selected forKey:@"selected"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.userId = [decoder decodeObjectForKey:@"userId"];
        self.accessToken = [decoder decodeObjectForKey:@"accessToken"];
        self.expirationDate = [decoder decodeObjectForKey:@"expirationDate"];
        self.screenName = [decoder decodeObjectForKey:@"screenName"];
        self.profileImageUrl = [decoder decodeObjectForKey:@"profileImageUrl"];
        self.selected = [decoder decodeBoolForKey:@"selected"];
    }
    return self;
}

- (void)dealloc
{
    [_userId release];
    [_accessToken release];
    [_screenName release];
    [_profileImageUrl release];
    [_expirationDate release];
    
    [super dealloc];
}

@end
