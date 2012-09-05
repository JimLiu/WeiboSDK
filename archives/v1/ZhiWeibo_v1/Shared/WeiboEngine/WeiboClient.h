//
//  WeiboClient.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-20.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboConnection.h"
#import "StringUtil.h"

@interface WeiboClient : WeiboConnection {

}



- (void)getPublicTimeline; // statuses/public_timeline

- (void)getFollowedTimelineMaximumID:(long long)maxID startingAtPage:(int)page count:(int)count;
- (void)getFollowedTimelineSinceID:(long long)sinceID startingAtPage:(int)pageNum count:(int)count; // statuses/friends_timeline
- (void)getFollowedTimelineSinceID:(long long)sinceID withMaximumID:(long long)maxID startingAtPage:(int)pageNum count:(int)count; // statuses/friends_timeline

- (void)getUserTimelineUserId:(long long)userId maximumID:(long long)maxID startingAtPage:(int)page count:(int)count;
- (void)getUserTimelineSinceID:(long long)sinceID userId:(long long)userId startingAtPage:(int)page count:(int)count;
- (void)getUserTimelineSinceID:(long long)sinceID 
						withUserId:(long long)userId maximumID:(long long)maxID startingAtPage:(int)page count:(int)count;

- (void)getRepostTimelineStatusId:(long long)statusId maximumID:(long long)maxID startingAtPage:(int)page count:(int)count;
- (void)getRepostTimelineSinceID:(long long)sinceID statusId:(long long)statusId startingAtPage:(int)page count:(int)count;
- (void)getRepostTimelineSinceID:(long long)sinceID 
					withStatusId:(long long)statusId maximumID:(long long)maxID startingAtPage:(int)page count:(int)count;

- (void)getMentionsMaximumID:(long long)maxID startingAtPage:(int)page count:(int)count;
- (void)getMentionsSinceID:(long long)sinceID startingAtPage:(int)page count:(int)count;
- (void)getMentionsSinceID:(long long)sinceID 
			 withMaximumID:(long long)maxID startingAtPage:(int)page count:(int)count;

- (void)favorite:(long long)statusId;
- (void)unfavorite:(long long)statusId;

- (void)getCommentCounts:(NSArray *)statuses;

- (void)getComments:(long long)statusId 
	 startingAtPage:(int)page 
			  count:(int)count;

- (void)getCommentsTimelineMaximumID:(long long)maxID startingAtPage:(int)page count:(int)count;
- (void)getCommentsTimelineSinceID:(long long)sinceID startingAtPage:(int)pageNum count:(int)count; // statuses/friends_timeline
- (void)getCommentsTimelineSinceID:(long long)sinceID withMaximumID:(long long)maxID startingAtPage:(int)pageNum count:(int)count; // statuses/friends_timeline

- (void)getTrendsTimelineName:(NSString *)trend_name;
- (void)getPublicTrendsHourly;
- (void)getPublicTrendsDaily;
- (void)getPublicTrendsWeekly;
- (void)getHotUserByCategory:(NSString*)category;
- (void)getHotStatusesDaily:(int)count;

- (void)getFavoritesTimelinePage:(int)page;

- (void)getDirectMessagesMaximumID:(long long)maxID startingAtPage:(int)page count:(int)count;
- (void)getDirectMessagesSinceID:(long long)sinceID startingAtPage:(int)page count:(int)count;
- (void)getDirectMessagesSinceID:(long long)sinceID 
				   withMaximumID:(long long)maxID startingAtPage:(int)page count:(int)count;

- (void)getDirectMessagesSentMaximumID:(long long)maxID startingAtPage:(int)page count:(int)count;
- (void)getDirectMessagesSentSinceID:(long long)sinceID startingAtPage:(int)page count:(int)count;
- (void)getDirectMessagesSentSinceID:(long long)sinceID 
					   withMaximumID:(long long)maxID startingAtPage:(int)page count:(int)count;

- (void)getUserTimelineByName:(NSString*)name page:(int)page count:(int)count;

- (void)getStatusTimelineByName:(NSString*)name startTime:(time_t)startTime
						endTime:(time_t)endTime page:(int)page count:(int)count;

- (void)verify;

- (void)getFriends:(long long)userId 
			cursor:(int)cursor 
			 count:(int)count;

- (void)getFollowers:(long long)userId 
			  cursor:(int)cursor 
			   count:(int)count;

- (void)getUser:(long long)userId;

- (void)getUserByScreenName:(NSString *)screenName;

- (void)getFriendship:(long long)userId;

- (void)getUnread;

- (void)resetUnreadFollowers;

- (void)follow:(long long)userId;

- (void)unfollow:(long long)userId;

- (void)post:(NSString*)tweet latitude:(float)latitude 
			longitude:(float)longitude;

- (void)upload:(NSData*)jpeg status:(NSString *)status
	 latitude:(float)latitude longitude:(float)longitude;

- (void)repost:(long long)statusId
		 tweet:(NSString*)tweet 
	 isComment:(BOOL)isComment;

- (void)comment:(long long)statusId
	  commentId:(long long)commentId
		comment:(NSString*)comment;

- (void)sendDirectMessage:(NSString*)text 
					   to:(int)recipientedId;

- (NSString *)getURL:(NSString *)path 
	 queryParameters:(NSMutableDictionary*)params;

- (void)alert;


@end
