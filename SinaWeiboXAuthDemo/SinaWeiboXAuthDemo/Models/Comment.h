//
//  Comment.h
//  WeiboPad
//
//  Created by junmin liu on 10-10-6.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "NSDictionaryAdditions.h"
#import "User.h"
#import "Status.h"

@interface Comment : NSObject {
	long long		commentId; // 评论ID
	NSNumber*		commentKey;
	NSString*		text; //评论内容
	time_t			createdAt; //评论时间
	NSString*		source; //评论来源
	NSString*		sourceUrl; 
	BOOL			favorited; //是否收藏
	BOOL			truncated; //是否被截断
	User*			user; //评论人信息
	Status*			status; //评论的微博
	Comment*		replyComment; //评论来源
}

@property (nonatomic, assign) long long		commentId; // 评论ID
@property (nonatomic, retain) NSNumber*		commentKey;
@property (nonatomic, readonly) NSString*         timestamp;
@property (nonatomic, retain) NSString*		text; //评论内容
@property (nonatomic, assign) time_t			createdAt; //评论时间
@property (nonatomic, retain) NSString*		source; //评论来源
@property (nonatomic, retain) NSString*		sourceUrl; //评论来源
@property (nonatomic, assign) BOOL			favorited; //是否收藏
@property (nonatomic, assign) BOOL			truncated; //是否被截断
@property (nonatomic, retain) User*			user; //评论人信息
@property (nonatomic, retain) Status*			status; //评论的微博
@property (nonatomic, retain) Comment*		replyComment; //评论来源


- (Comment*)initWithJsonDictionary:(NSDictionary*)dic;

+ (Comment*)commentWithJsonDictionary:(NSDictionary*)dic;

@end
