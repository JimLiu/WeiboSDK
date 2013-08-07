//
//  Status.h
//  WeiboSDK
//
//  Created by Liu Jim on 8/3/13.
//  Copyright (c) 2013 openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "GeoInfo.h"
#import "StatusImage.h"

@interface Status : NSObject<NSCoding> {
    NSNumber *_statusKey;
}

+ (Status *)statusWithJsonDictionary:(NSDictionary*)dic;
- (id)initWithJsonDictionary:(NSDictionary*)dic;

@property (nonatomic, copy) NSString *statusIdString; //字符串型的微博ID
@property (nonatomic, assign) time_t createdAt;  //创建时间
@property (nonatomic, assign) long long statusId; //微博ID
@property (nonatomic, copy) NSString *text; //微博信息内容
@property (nonatomic, copy) NSString *source; //微博来源
@property (nonatomic, copy) NSString *sourceUrl; //微博来源Url
@property (nonatomic, assign) BOOL favorited; //是否已收藏
@property (nonatomic, assign) BOOL truncated; //是否被截断
@property (nonatomic, assign) long long inReplyToStatusId; //回复ID
@property (nonatomic, assign) long long inReplyToUserId; //回复人UID
@property (nonatomic, copy) NSString *inReplyToScreenName; //回复人昵称
@property (nonatomic, assign) long long mid; //微博MID
@property (nonatomic, strong) NSArray *images; //图片集合
@property (nonatomic, assign) int repostsCount; //转发数
@property (nonatomic, assign) int commentsCount; //评论数
@property (nonatomic, assign) int attitudesCount; //赞
@property (nonatomic, retain) GeoInfo *geo; //地理信息字段
@property (nonatomic, strong) User *user; //微博作者的用户信息字段
@property (nonatomic, strong) Status *retweetedStatus; // 转发微博
@property (nonatomic, readonly) NSNumber *statusKey;

- (NSString*)statusTimeString;
- (NSString*)statusDateTimeString;

@end
