//
//  Status.h
//  WeiboPad
//
//  Created by junmin liu on 10-10-6.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "NSDictionaryAdditions.h"
#import "User.h"
#import "RegexKitLite.h"

@interface Status : NSObject {
    long long		statusId; //微博ID
	NSNumber		*statusKey;
    time_t          createdAt;
	NSString*       text; //微博信息内容
	NSString*       source; //微博来源
	NSString*		sourceUrl; //微博来源Url
    BOOL            favorited; //是否已收藏(正在开发中，暂不支持)
    BOOL            truncated; //是否被截断
	double			latitude;
	double			longitude;
    long long		inReplyToStatusId; //回复ID
    int             inReplyToUserId; //回复人UID
    NSString*       inReplyToScreenName; //回复人昵称
	NSString*		thumbnailPic; //缩略图
	NSString*		bmiddlePic; //中型图片
	NSString*		originalPic; //原始图片
    User*           user; //作者信息
    int				commentsCount; // 评论数
	int				retweetsCount; // 转发数
	Status*			retweetedStatus; //转发的博文，内容为status，如果不是转发，则没有此字段
	
    BOOL            unread;
    BOOL            hasReply;

	NSString*		_formmatedText;
}

@property (nonatomic, assign) long long    statusId;
@property (nonatomic, retain) NSNumber*		statusKey;
@property (nonatomic, assign) time_t          createdAt;
@property (nonatomic, readonly) NSString*         timestamp;
@property (nonatomic, retain) NSString*       text;
@property (nonatomic, retain) NSString*       source; 
@property (nonatomic, retain) NSString*		sourceUrl;
@property (nonatomic, assign) BOOL            favorited; //是否已收藏(正在开发中，暂不支持)
@property (nonatomic, assign) BOOL            truncated; //是否被截断
@property (nonatomic, assign) double			latitude;
@property (nonatomic, assign) double			longitude;
@property (nonatomic, assign) long long    inReplyToStatusId; //回复ID
@property (nonatomic, assign) int             inReplyToUserId; //回复人UID
@property (nonatomic, retain) NSString*       inReplyToScreenName; //回复人昵称
@property (nonatomic, retain) NSString*		thumbnailPic; //缩略图
@property (nonatomic, retain) NSString*		bmiddlePic; //中型图片
@property (nonatomic, retain) NSString*		originalPic; //原始图片
@property (nonatomic, retain) User*           user; //作者信息
@property (nonatomic, assign) int             commentsCount; //评论数
@property (nonatomic, assign) int             retweetsCount; // 转发数

@property (nonatomic, retain) Status*			retweetedStatus; //转发的博文，内容为status，如果不是转发，则没有此字段

@property (nonatomic, assign) BOOL            unread;
@property (nonatomic, assign) BOOL            hasReply;



- (NSString*)timestamp;

- (id)initWithStatement:(Statement *)stmt;

- (Status*)initWithJsonDictionary:(NSDictionary*)dic;

+ (Status*)statusWithJsonDictionary:(NSDictionary*)dic;

+ (Status*)statusWithStatusId:(long long)statusId;

+ (BOOL)isExists:(sqlite_int64)aStatusId;

- (void)insertDB;

@end
