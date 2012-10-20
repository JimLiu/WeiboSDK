//
//  User.h
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-8-31.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionaryAdditions.h"

typedef enum {
    GenderUnknow = 0,
    GenderMale,
    GenderFemale,
} Gender;

typedef enum {
    OnlineStatusOffline = 0,
    OnlineStatusOnline = 1,
} OnlineStatus;

@interface User : NSObject<NSCoding> {
    long long   _userId; //用户UID
	NSString*   _screenName; //微博昵称
    NSString*   _name; //友好显示名称，如Bill Gates(此特性暂不支持)
	NSString*	_province; //省份编码（参考省份编码表）
	NSString*	_city; //城市编码（参考城市编码表）
	NSString*   _location; //地址
	NSString*   _description; //个人描述
	NSString*   _url; //用户博客地址
	NSString*   _profileImageUrl; //自定义图像
	NSString*	_profileLargeImageUrl; //大图像地址
	NSString*	_domain; //用户个性化URL
    NSString*   _verifiedReason; //认证原因
	Gender		_gender; //性别,m--男，f--女,n--未知
	int         _followersCount; //粉丝数
    int         _friendsCount; //关注数
    int         _statusesCount; //微博数
    int         _favoritesCount; //收藏数
    int         _biFollowersCount; //用户的互粉数
	time_t      _createdAt; //创建时间
    BOOL        _following; //是否已关注(此特性暂不支持)
	BOOL		_followedBy; //该用户是否关注当前登录用户
    BOOL        _verified; //加V标示，是否微博认证用户
	BOOL		_allowAllActMsg; //是否允许所有人给我发私信
	BOOL		_geoEnabled; //是否允许带有地理信息
    BOOL        _allowComment; //是否允许所有人对我的微博进行评论
    OnlineStatus _onlineStatus;//用户的在线状态，0：不在线、1：在线
}

- (id)initWithJsonDictionary:(NSDictionary*)dic;

@property (nonatomic, assign) long long userId;
@property (nonatomic, copy) NSString *screenName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *profileImageUrl;
@property (nonatomic, copy) NSString *profileLargeImageUrl;
@property (nonatomic, copy) NSString *domain;
@property (nonatomic, copy) NSString *verifiedReason;
@property (nonatomic, assign) Gender gender;
@property (nonatomic, assign) int followersCount;
@property (nonatomic, assign) int friendsCount;
@property (nonatomic, assign) int statusesCount;
@property (nonatomic, assign) int favoritesCount;
@property (nonatomic, assign) int biFollowersCount;
@property (nonatomic, assign) time_t createdAt;
@property (nonatomic, assign, getter=isFollowing) BOOL following;
@property (nonatomic, assign, getter=isFollowedBy) BOOL followedBy;
@property (nonatomic, assign, getter=isVerified) BOOL verified;
@property (nonatomic, assign, getter=isAllowAllActMsg) BOOL allowAllActMsg;
@property (nonatomic, assign, getter=isGeoEnabled) BOOL geoEnabled;
@property (nonatomic, assign, getter=isAllowComment) BOOL allowComment;
@property (nonatomic, assign) OnlineStatus onlineStatus;


@end
