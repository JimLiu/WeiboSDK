//
//  User.m
//  WeiboSDK
//
//  Created by Liu Jim on 8/3/13.
//  Copyright (c) 2013 openlab. All rights reserved.
//

#import "User.h"
#import "NSDictionary+Json.h"
#import "Resources.h"

@implementation User


//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:[NSNumber numberWithLongLong:self.userId] forKey:@"userId"];
    [encoder encodeObject:self.screenName forKey:@"screenName"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.province forKey:@"province"];
    [encoder encodeObject:self.city forKey:@"city"];
    [encoder encodeObject:self.location forKey:@"location"];
    [encoder encodeObject:self.userDescription forKey:@"description"];
    [encoder encodeObject:self.url forKey:@"url"];
    [encoder encodeObject:self.profileImageUrl forKey:@"profileImageUrl"];
    [encoder encodeObject:self.profileLargeImageUrl forKey:@"profileLargeImageUrl"];
    [encoder encodeObject:self.domain forKey:@"domain"];
    [encoder encodeObject:self.weihao forKey:@"weihao"];
    [encoder encodeObject:self.profileUrl forKey:@"profileUrl"];
    [encoder encodeObject:self.verifiedReason forKey:@"verifiedReason"];
    [encoder encodeInt:self.gender forKey:@"gender"];
    [encoder encodeInt:self.followersCount forKey:@"followersCount"];
    [encoder encodeInt:self.friendsCount forKey:@"friendsCount"];
    [encoder encodeInt:self.statusesCount forKey:@"statusesCount"];
    [encoder encodeInt:self.favoritesCount forKey:@"favoritesCount"];
    [encoder encodeInt:self.biFollowersCount forKey:@"biFollowersCount"];
    [encoder encodeInt64:self.createdAt forKey:@"createdAt"];
    [encoder encodeBool:self.following forKey:@"following"];
    [encoder encodeBool:self.followedBy forKey:@"followedBy"];
    [encoder encodeBool:self.verified forKey:@"verified"];
    [encoder encodeBool:self.allowAllActMsg forKey:@"allowAllActMsg"];
    [encoder encodeBool:self.geoEnabled forKey:@"geoEnabled"];
    [encoder encodeBool:self.allowComment forKey:@"allowComment"];
    [encoder encodeInt:self.onlineStatus forKey:@"onlineStatus"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        [self setUserId:[[decoder decodeObjectForKey:@"userId"] longLongValue]];
        self.screenName = [decoder decodeObjectForKey:@"screenName"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.province = [decoder decodeObjectForKey:@"province"];
        self.city = [decoder decodeObjectForKey:@"city"];
        self.location = [decoder decodeObjectForKey:@"location"];
        self.userDescription = [decoder decodeObjectForKey:@"description"];
        self.url = [decoder decodeObjectForKey:@"url"];
        self.profileImageUrl = [decoder decodeObjectForKey:@"profileImageUrl"];
        self.profileLargeImageUrl = [decoder decodeObjectForKey:@"profileLargeImageUrl"];
        self.domain = [decoder decodeObjectForKey:@"domain"];
        self.weihao = [decoder decodeObjectForKey:@"weihao"];
        self.profileUrl = [decoder decodeObjectForKey:@"profileUrl"];
        self.verifiedReason = [decoder decodeObjectForKey:@"verifiedReason"];
        self.gender = [decoder decodeIntForKey:@"gender"];
        self.followersCount = [decoder decodeIntForKey:@"followersCount"];
        self.friendsCount = [decoder decodeIntForKey:@"friendsCount"];
        self.statusesCount = [decoder decodeIntForKey:@"statusesCount"];
        self.favoritesCount = [decoder decodeIntForKey:@"favoritesCount"];
        self.biFollowersCount = [decoder decodeIntForKey:@"biFollowersCount"];
        self.createdAt = [decoder decodeIntForKey:@"createdAt"];
        self.following = [decoder decodeBoolForKey:@"following"];
        self.followedBy = [decoder decodeBoolForKey:@"followedBy"];
        self.verified = [decoder decodeBoolForKey:@"verified"];
        self.allowAllActMsg = [decoder decodeBoolForKey:@"allowAllActMsg"];
        self.geoEnabled = [decoder decodeBoolForKey:@"geoEnabled"];
        self.allowComment = [decoder decodeBoolForKey:@"allowComment"];
        self.onlineStatus = [decoder decodeIntForKey:@"onlineStatus"];
    }
    return self;
}

- (id)initWithJsonDictionary:(NSDictionary*)dic
{
	self = [super init];
    if (self) {
        self.userId = [dic longLongValueForKey:@"id"];
        self.screenName = [dic stringValueForKey:@"screen_name"];
        self.name = [dic stringValueForKey:@"name"];
        NSString *provinceId = [dic stringValueForKey:@"province"];
        NSString *cityId = [dic stringValueForKey:@"city"];
        self.province = [Resources getProvinceName:provinceId];
        self.city = [Resources getCityNameWithProvinceId:provinceId withCityId:cityId];
        self.location = [dic stringValueForKey:@"location"];
        self.userDescription = [dic stringValueForKey:@"description"];
        self.url = [dic stringValueForKey:@"url"];
        self.profileImageUrl = [dic stringValueForKey:@"profile_image_url"];
        self.profileLargeImageUrl = [dic stringValueForKey:@"avatar_large"];
        self.domain = [dic stringValueForKey:@"domain"];
        self.profileUrl = [dic stringValueForKey:@"profile_url"];
        self.weihao = [dic stringValueForKey:@"weihao"];
        self.verifiedReason = [dic stringValueForKey:@"verified_reason"];
        
        NSString *genderChar = [dic stringValueForKey:@"gender"];
        if ([genderChar isEqualToString:@"m"])
            self.gender = GenderMale;
        else if ([genderChar isEqualToString:@"f"])
            self.gender = GenderFemale;
        else
            self.gender = GenderUnknow;
        
        self.followersCount = [dic intValueForKey:@"followers_count"];
        self.friendsCount = [dic intValueForKey:@"friends_count"];
        self.statusesCount = [dic intValueForKey:@"statuses_count"];
        self.favoritesCount = [dic intValueForKey:@"favourites_count"];
        self.biFollowersCount = [dic intValueForKey:@"bi_followers_count"];
        self.createdAt = [dic timeValueForKey:@"created_at"];
        self.following = [dic boolValueForKey:@"following"];
        self.followedBy = [dic boolValueForKey:@"follow_me"];
        self.verified = [dic boolValueForKey:@"verified"];
        self.allowAllActMsg = [dic boolValueForKey:@"allow_all_act_msg"];
        self.geoEnabled = [dic boolValueForKey:@"geo_enabled"];
        self.allowComment = [dic boolValueForKey:@"allow_all_comment"];
        self.onlineStatus = [dic intValueForKey:@"online_status"];
    }
	return self;
}



@end
