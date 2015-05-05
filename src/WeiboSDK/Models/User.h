//
//  User.h
//  WeiboSDK
//
//  Created by Liu Jim on 8/3/13.
//  Copyright (c) 2013 openlab. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    GenderUnknow = 0,
    GenderMale,
    GenderFemale,
} Gender;

typedef enum {
    OnlineStatusOffline = 0,
    OnlineStatusOnline = 1,
} OnlineStatus;

@interface User : NSObject<NSCoding>

- (id)initWithJsonDictionary:(NSDictionary*)dic;

@property (nonatomic, assign) long long userId; //用户UID
@property (nonatomic, copy) NSString *screenName; //用户昵称
@property (nonatomic, copy) NSString *name; //友好显示名称
@property (nonatomic, copy) NSString *province; //用户所在省级
@property (nonatomic, copy) NSString *city; //用户所在城市
@property (nonatomic, copy) NSString *location; //用户所在地
@property (nonatomic, copy) NSString *userDescription; //用户个人描述
@property (nonatomic, copy) NSString *url; //用户博客地址
@property (nonatomic, copy) NSString *profileImageUrl; //用户头像地址
@property (nonatomic, copy) NSString *profileLargeImageUrl; //用户大头像地址
@property (nonatomic, copy) NSString *profileUrl; //用户的微博统一URL地址
@property (nonatomic, copy) NSString *domain; //用户的个性化域名
@property (nonatomic, copy) NSString *weihao; //微号
@property (nonatomic, copy) NSString *verifiedReason; //认证原因
@property (nonatomic, assign) Gender gender; //性别，m：男、f：女、n：未知
@property (nonatomic, assign) int followersCount; //粉丝数
@property (nonatomic, assign) int friendsCount; //关注数
@property (nonatomic, assign) int statusesCount; //微博数
@property (nonatomic, assign) int favoritesCount; //收藏数
@property (nonatomic, assign) int biFollowersCount; //用户的互粉数
@property (nonatomic, assign) time_t createdAt; //用户创建（注册）时间
@property (nonatomic, assign) BOOL following;
@property (nonatomic, assign) BOOL followedBy; //该用户是否关注当前登录用户，true：是，false：否
@property (nonatomic, assign) BOOL verified; //是否是微博认证用户，即加V用户，true：是，false：否
@property (nonatomic, assign) BOOL allowAllActMsg; //是否允许所有人给我发私信，true：是，false：否
@property (nonatomic, assign) BOOL geoEnabled; //是否允许标识用户的地理位置，true：是，false：否
@property (nonatomic, assign) BOOL allowComment; //是否允许所有人对我的微博进行评论，true：是，false：否
@property (nonatomic, assign) OnlineStatus onlineStatus; //用户的在线状态，0：不在线、1：在线

@end
