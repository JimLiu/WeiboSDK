//
//  Status.h
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-9-4.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionaryAdditions.h"
#import "GeoInfo.h"
#import "User.h"

@interface Status : NSObject<NSCoding> {
    NSString *_statusIdString; //字符串型的微博ID
    time_t _createdAt;  //创建时间
    long long _statusId; //微博ID
    NSString *_text;    //微博信息内容
    NSString *_source;  //微博来源
    NSString *_sourceUrl;//微博来源Url
    BOOL _favorited;    //是否已收藏
    BOOL _truncated;    //是否被截断
    long long _inReplyToStatusId;   //回复ID
    long long _inReplyToUserId;     //回复人UID
    NSString *_inReplyToScreenName; //回复人昵称
    long long _mid;                 //微博MID
    NSString *_middleImageUrl;      //中等尺寸图片地址
    NSString *_originalImageUrl;    //原始图片地址
    NSString *_thumbnailImageUrl;   //缩略图片地址
    int _repostsCount;              //转发数
    int _commentsCount;             //评论数
    GeoInfo *_geo;                  //地理信息字段
    User *_user;                    //微博作者的用户信息字段
    Status *_retweetedStatus;  // 转发微博
    
    NSNumber *_statusKey;
}

+ (Status *)statusWithJsonDictionary:(NSDictionary*)dic;
- (id)initWithJsonDictionary:(NSDictionary*)dic;

@property (nonatomic, copy) NSString *statusIdString;
@property (nonatomic, assign) time_t createdAt;
@property (nonatomic, assign) long long statusId;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *sourceUrl;
@property (nonatomic, assign, getter=isFavorited) BOOL favorited;
@property (nonatomic, assign, getter=isTruncated) BOOL truncated;
@property (nonatomic, assign) long long inReplyToStatusId;
@property (nonatomic, assign) long long inReplyToUserId;
@property (nonatomic, copy) NSString *inReplyToScreenName;
@property (nonatomic, assign) long long mid;
@property (nonatomic, copy) NSString *middleImageUrl;
@property (nonatomic, copy) NSString *originalImageUrl;
@property (nonatomic, copy) NSString *thumbnailImageUrl;
@property (nonatomic, assign) int repostsCount;
@property (nonatomic, assign) int commentsCount;
@property (nonatomic, retain) GeoInfo *geo;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) Status *retweetedStatus;
@property (nonatomic, readonly) NSNumber *statusKey;

- (NSString*)statusTimeString;
- (NSString*)statusDateTimeString;


@end
