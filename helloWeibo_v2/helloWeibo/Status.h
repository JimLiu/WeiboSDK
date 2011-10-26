//
//  Status.h
//  helloWeibo
//
//  Created by junmin liu on 11-4-13.
//  Copyright 2011年 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@class Status;

@interface Status : NSObject {
    long long		_statusId; //微博ID
    time_t          _createdAt;
	NSString*       _text; //微博信息内容
	NSString*       _source; //微博来源
	NSString*		_sourceUrl; //微博来源Url
	NSString*		_timeString;
	NSString*		_thumbnailPic; //缩略图
	NSString*		_bmiddlePic; //中型图片
	NSString*		_originalPic; //原始图片
    User*           _user; //作者信息
    int				_commentsCount; // 评论数
	int				_retweetsCount; // 转发数
	Status*			_retweetedStatus; //转发的博文，内容为status，如果不是转发，则没有此字段
}

@property (nonatomic, assign) long long statusId;
@property (nonatomic, assign) time_t createdAt;
@property (nonatomic, assign) int commentsCount;
@property (nonatomic, assign) int retweetsCount;
@property (nonatomic, retain) NSString* text;
@property (nonatomic, retain) NSString* source; 
@property (nonatomic, retain) NSString* sourceUrl;
@property (nonatomic, retain) NSString* thumbnailPic;
@property (nonatomic, retain) NSString* bmiddlePic;
@property (nonatomic, retain) NSString* originalPic;
@property (nonatomic, retain) User* user;
@property (nonatomic, retain) Status* retweetedStatus;


- (id)initWithJsonDictionary:(NSDictionary*)dic;

+ (Status*)statusWithJsonDictionary:(NSDictionary*)dic;

- (NSString*)timestamp;

- (NSString*)commentsCountText;

- (NSString*)retweetsCountText;

@end
