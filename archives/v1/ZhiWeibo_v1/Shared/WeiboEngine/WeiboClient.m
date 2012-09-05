//
//  WeiboClient.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-20.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "WeiboClient.h"
#import "CJSONDeserializer.h"

#define API_FORMAT @"json"


@implementation WeiboClient



- (void)dealloc
{
    [super dealloc];
}



#pragma mark -
#pragma mark REST API methods
#pragma mark -

#pragma mark Status methods


- (void)getPublicTimeline
{
	needAuth = NO;
    NSString *path = [NSString stringWithFormat:@"statuses/public_timeline.%@", API_FORMAT];
    [super asyncGet:path params:nil];
}

#pragma mark -
#pragma mark Followed Timeline

- (void)getFollowedTimelineMaximumID:(long long)maxID startingAtPage:(int)page count:(int)count
{
    [self getFollowedTimelineSinceID:0 withMaximumID:maxID startingAtPage:page count:count];
}

- (void)getFollowedTimelineSinceID:(long long)sinceID startingAtPage:(int)page count:(int)count
{
    [self getFollowedTimelineSinceID:sinceID withMaximumID:0 startingAtPage:page count:count];
}

- (void)getFollowedTimelineSinceID:(long long)sinceID 
					 withMaximumID:(long long)maxID startingAtPage:(int)page count:(int)count
{
	needAuth = YES;
	NSString *path = [NSString stringWithFormat:@"statuses/friends_timeline.%@", API_FORMAT];
	
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    if (sinceID > 0) {
        [params setObject:[NSString stringWithFormat:@"%lld", sinceID] forKey:@"since_id"];
    }
    if (maxID > 0) {
        [params setObject:[NSString stringWithFormat:@"%lld", maxID] forKey:@"max_id"];
    }
    if (page > 0) {
        [params setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    }
    if (count > 0) {
        [params setObject:[NSString stringWithFormat:@"%d", count] forKey:@"count"];
    }
    [super asyncGet:path params:params];
}

#pragma mark -
#pragma mark User Timeline

- (void)getUserTimelineUserId:(long long)userId maximumID:(long long)maxID startingAtPage:(int)page count:(int)count
{
    [self getUserTimelineSinceID:0 withUserId:userId maximumID:maxID startingAtPage:page count:count];
}

- (void)getUserTimelineSinceID:(long long)sinceID userId:(long long)userId startingAtPage:(int)page count:(int)count
{
    [self getUserTimelineSinceID:sinceID withUserId:userId maximumID:0 startingAtPage:page count:count];
}

- (void)getUserTimelineSinceID:(long long)sinceID 
						withUserId:(long long)userId maximumID:(long long)maxID startingAtPage:(int)page count:(int)count
{
	needAuth = YES;
	NSString *path = [NSString stringWithFormat:@"statuses/user_timeline.%@", API_FORMAT];
	
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    if (sinceID > 0) {
        [params setObject:[NSString stringWithFormat:@"%lld", sinceID] forKey:@"since_id"];
    }
	if (userId > 0) {
		[params setObject:[NSString stringWithFormat:@"%lld", userId] forKey:@"user_id"];
	}
    if (maxID > 0) {
        [params setObject:[NSString stringWithFormat:@"%lld", maxID] forKey:@"max_id"];
    }
    if (page > 0) {
        [params setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    }
    if (count > 0) {
        [params setObject:[NSString stringWithFormat:@"%d", count] forKey:@"count"];
    }
    [super asyncGet:path params:params];
}

#pragma mark -
#pragma mark Repost Timeline

- (void)getRepostTimelineStatusId:(long long)statusId maximumID:(long long)maxID startingAtPage:(int)page count:(int)count
{
    [self getRepostTimelineSinceID:0 withStatusId:statusId maximumID:maxID startingAtPage:page count:count];
}

- (void)getRepostTimelineSinceID:(long long)sinceID statusId:(long long)statusId startingAtPage:(int)page count:(int)count
{
    [self getRepostTimelineSinceID:sinceID withStatusId:statusId maximumID:0 startingAtPage:page count:count];
}

- (void)getRepostTimelineSinceID:(long long)sinceID 
					withStatusId:(long long)statusId maximumID:(long long)maxID startingAtPage:(int)page count:(int)count
{
	needAuth = YES;
	NSString *path = [NSString stringWithFormat:@"statuses/repost_timeline.%@", API_FORMAT];
	
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    if (sinceID > 0) {
        [params setObject:[NSString stringWithFormat:@"%lld", sinceID] forKey:@"since_id"];
    }
	if (statusId > 0) {
		[params setObject:[NSString stringWithFormat:@"%lld", statusId] forKey:@"id"];
	}
    if (maxID > 0) {
        [params setObject:[NSString stringWithFormat:@"%lld", maxID] forKey:@"max_id"];
    }
    if (page > 0) {
        [params setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    }
    if (count > 0) {
        [params setObject:[NSString stringWithFormat:@"%d", count] forKey:@"count"];
    }
    [super asyncGet:path params:params];
}

#pragma mark -
#pragma mark Mentions

- (void)getMentionsMaximumID:(long long)maxID startingAtPage:(int)page count:(int)count
{
    [self getMentionsSinceID:0 withMaximumID:maxID startingAtPage:page count:count];
}

- (void)getMentionsSinceID:(long long)sinceID startingAtPage:(int)page count:(int)count
{
    [self getMentionsSinceID:sinceID withMaximumID:0 startingAtPage:page count:count];
}

- (void)getMentionsSinceID:(long long)sinceID 
			 withMaximumID:(long long)maxID startingAtPage:(int)page count:(int)count
{
	needAuth = YES;
	NSString *path = [NSString stringWithFormat:@"statuses/mentions.%@", API_FORMAT];
	
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    if (sinceID > 0) {
        [params setObject:[NSString stringWithFormat:@"%lld", sinceID] forKey:@"since_id"];
    }
    if (maxID > 0) {
        [params setObject:[NSString stringWithFormat:@"%lld", maxID] forKey:@"max_id"];
    }
    if (page > 0) {
        [params setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    }
    if (count > 0) {
        [params setObject:[NSString stringWithFormat:@"%d", count] forKey:@"count"];
    }
    [super asyncGet:path params:params];
}

#pragma mark -
#pragma mark Favorite


- (void)favorite:(long long)statusId
{
	needAuth = YES;
    NSString *path = [NSString stringWithFormat:@"favorites/create.%@", API_FORMAT];
	
    [super asyncPost:path params:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%lld", statusId] forKey:@"id"] withFiles:nil];
}

- (void)unfavorite:(long long)statusId
{
	needAuth = YES;
    NSString *path = [NSString stringWithFormat:@"favorites/destroy/%lld.%@", statusId, API_FORMAT];
	
    [super asyncPost:path params:nil withFiles:nil];
}

#pragma mark -
#pragma mark Comments


- (void)getCommentCounts:(NSArray *)_statusIds {
	needAuth = YES;
	NSString *path = [NSString stringWithFormat:@"statuses/counts.%@", API_FORMAT];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	
	NSMutableString *ids = [[NSMutableString alloc]init];
	
	int count = _statusIds.count;
	int maxCount = 100;
	for (int i=0; i<count; i++) {
		NSNumber *statusId = [_statusIds objectAtIndex:i];
		[ids appendFormat:@"%lld", [statusId longLongValue]];
		maxCount--;
		if (i < count - 1 && maxCount > 0 ) {
			[ids appendString:@","];
		}
		if (maxCount <= 0) { 
			break;
		}
	}
	[params setObject:ids forKey:@"ids"];
	[ids release];
    [super asyncGet:path params:params];
}




- (void)getComments:(long long)statusId 
	 startingAtPage:(int)page 
			  count:(int)count
{
	needAuth = YES;
	NSString *path = [NSString stringWithFormat:@"statuses/comments.%@", API_FORMAT];
	
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	[params setObject:[NSString stringWithFormat:@"%lld", statusId] forKey:@"id"];
    if (page > 0) {
        [params setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    }
    if (count > 0) {
        [params setObject:[NSString stringWithFormat:@"%d", count] forKey:@"count"];
    }
    
    [super asyncGet:path params:params];
}


#pragma mark -
#pragma mark Comments Timeline

- (void)getCommentsTimelineMaximumID:(long long)maxID startingAtPage:(int)page count:(int)count
{
    [self getCommentsTimelineSinceID:0 withMaximumID:maxID startingAtPage:page count:count];
}

- (void)getCommentsTimelineSinceID:(long long)sinceID startingAtPage:(int)page count:(int)count
{
    [self getCommentsTimelineSinceID:sinceID withMaximumID:0 startingAtPage:page count:count];
}

- (void)getCommentsTimelineSinceID:(long long)sinceID 
					 withMaximumID:(long long)maxID startingAtPage:(int)page count:(int)count
{
	needAuth = YES;
	NSString *path = [NSString stringWithFormat:@"statuses/comments_to_me.%@", API_FORMAT];
	
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    if (sinceID > 0) {
        [params setObject:[NSString stringWithFormat:@"%lld", sinceID] forKey:@"since_id"];
    }
    if (maxID > 0) {
        [params setObject:[NSString stringWithFormat:@"%lld", maxID] forKey:@"max_id"];
    }
    if (page > 0) {
        [params setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    }
    if (count > 0) {
        [params setObject:[NSString stringWithFormat:@"%d", count] forKey:@"count"];
    }
    [super asyncGet:path params:params];
}

#pragma mark -
#pragma mark Trend Timeline

- (void)getTrendsTimelineName:(NSString *)trend_name
{
    needAuth = YES;
	NSString *path = [NSString stringWithFormat:@"trends/statuses.%@", API_FORMAT];
	
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    if (trend_name) {
        [params setObject:[NSString stringWithFormat:@"%@", trend_name] forKey:@"trend_name"];
    }
    [super asyncGet:path params:params];
}

- (void)getPublicTrendsHourly {
	needAuth = YES;
	NSString *path = [NSString stringWithFormat:@"trends/hourly.%@", API_FORMAT];

    [super asyncGet:path params:nil];
}

- (void)getPublicTrendsDaily {
	needAuth = YES;
	NSString *path = [NSString stringWithFormat:@"trends/daily.%@", API_FORMAT];
	
    [super asyncGet:path params:nil];
}

- (void)getPublicTrendsWeekly {
	needAuth = YES;
	NSString *path = [NSString stringWithFormat:@"trends/weekly.%@", API_FORMAT];
	
    [super asyncGet:path params:nil];
}

- (void)getHotUserByCategory:(NSString*)category {
	needAuth = YES;
	NSString *path = [NSString stringWithFormat:@"users/hot.%@", API_FORMAT];
	
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    if (category) {
        [params setObject:[NSString stringWithFormat:@"%@", category] forKey:@"category"];
    }
	[super asyncGet:path params:params];
}

- (void)getHotStatusesDaily:(int)count {
	needAuth = YES;
	NSString *path = [NSString stringWithFormat:@"statuses/hot/repost_daily.%@", API_FORMAT];
	
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    if (count > 0) {
        [params setObject:[NSString stringWithFormat:@"%d", count] forKey:@"count"];
    }

	[super asyncGet:path params:params];
}

#pragma mark -
#pragma mark Favorites Timeline

- (void)getFavoritesTimelinePage:(int)page
{
	needAuth = YES;
	NSString *path = [NSString stringWithFormat:@"favorites.%@", API_FORMAT];
	
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    if (page >= 0) {
        [params setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    }
	[super asyncGet:path params:params];
}

#pragma mark -
#pragma mark DirectMessage

- (void)getDirectMessagesMaximumID:(long long)maxID startingAtPage:(int)page count:(int)count
{
    [self getDirectMessagesSinceID:0 withMaximumID:maxID startingAtPage:page count:count];
}

- (void)getDirectMessagesSinceID:(long long)sinceID startingAtPage:(int)page count:(int)count
{
    [self getDirectMessagesSinceID:sinceID withMaximumID:0 startingAtPage:page count:count];
}

- (void)getDirectMessagesSinceID:(long long)sinceID 
					 withMaximumID:(long long)maxID startingAtPage:(int)page count:(int)count
{
	needAuth = YES;
	NSString *path = [NSString stringWithFormat:@"direct_messages.%@", API_FORMAT];
	
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    if (sinceID > 0) {
        [params setObject:[NSString stringWithFormat:@"%lld", sinceID] forKey:@"since_id"];
    }
    if (maxID > 0) {
        [params setObject:[NSString stringWithFormat:@"%lld", maxID] forKey:@"max_id"];
    }
    if (page > 0) {
        [params setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    }
    if (count > 0) {
        [params setObject:[NSString stringWithFormat:@"%d", count] forKey:@"count"];
    }
	[super asyncGet:path params:params];																													
}

#pragma mark -
#pragma mark DirectMessageSent

- (void)getDirectMessagesSentMaximumID:(long long)maxID startingAtPage:(int)page count:(int)count
{
    [self getDirectMessagesSentSinceID:0 withMaximumID:maxID startingAtPage:page count:count];
}

- (void)getDirectMessagesSentSinceID:(long long)sinceID startingAtPage:(int)page count:(int)count
{
    [self getDirectMessagesSentSinceID:sinceID withMaximumID:0 startingAtPage:page count:count];
}

- (void)getDirectMessagesSentSinceID:(long long)sinceID 
				   withMaximumID:(long long)maxID startingAtPage:(int)page count:(int)count
{
	needAuth = YES;
	NSString *path = [NSString stringWithFormat:@"direct_messages/sent.%@", API_FORMAT];
	
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    if (sinceID > 0) {
        [params setObject:[NSString stringWithFormat:@"%lld", sinceID] forKey:@"since_id"];
    }
    if (maxID > 0) {
        [params setObject:[NSString stringWithFormat:@"%lld", maxID] forKey:@"max_id"];
    }
    if (page > 0) {
        [params setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    }
    if (count > 0) {
        [params setObject:[NSString stringWithFormat:@"%d", count] forKey:@"count"];
    }
	[super asyncGet:path params:params];																												
}

#pragma mark -
#pragma mark UserSearch

- (void)getUserTimelineByName:(NSString*)name page:(int)page count:(int)count
{
	needAuth = NO;
	NSString *path = [NSString stringWithFormat:@"users/search.%@", API_FORMAT];
	
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	if (name && ![name isEqualToString:@""]) {
		[params setObject:[NSString stringWithFormat:@"%@", name] forKey:@"q"];
	}
	if (page > 0) {
        [params setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    }
    if (count > 0) {
        [params setObject:[NSString stringWithFormat:@"%d", count] forKey:@"count"];
    }
	[super asyncGet:path params:params];
}

- (void)getStatusTimelineByName:(NSString*)name startTime:(time_t)startTime
						endTime:(time_t)endTime page:(int)page count:(int)count
{
	needAuth = NO;
	NSString *path = [NSString stringWithFormat:@"statuses/search.%@", API_FORMAT];
	
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	if (name && ![name isEqualToString:@""]) {
		[params setObject:[NSString stringWithFormat:@"%@", name] forKey:@"q"];
	}
	if (startTime > 0) {
		[params setObject:[NSString stringWithFormat:@"%llu", startTime] forKey:@"starttime"];
	}
	if (endTime > 0) {
		[params setObject:[NSString stringWithFormat:@"%lld", endTime] forKey:@"endtime"];
	}
	if (page > 0) {
        [params setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    }
    if (count > 0) {
        [params setObject:[NSString stringWithFormat:@"%d", count] forKey:@"count"];
    }
	[super asyncGet:path params:params];
}

#pragma mark -
#pragma mark Account

- (void)verify {
	needAuth = YES;
	NSString *path = [NSString stringWithFormat:@"account/verify_credentials.%@", API_FORMAT];
	[super asyncGet:path params:nil];
}


- (void)getFriends:(long long)userId 
			cursor:(int)cursor 
			 count:(int)count
{
	needAuth = YES;
	NSString *path = [NSString stringWithFormat:@"statuses/friends.%@", API_FORMAT];
	
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	[params setObject:[NSString stringWithFormat:@"%lld", userId] forKey:@"user_id"];
	[params setObject:[NSString stringWithFormat:@"%d", cursor] forKey:@"cursor"];
    if (count > 0) {
        [params setObject:[NSString stringWithFormat:@"%d", count] forKey:@"count"];
    }
	[super asyncGet:path params:params];
}


- (void)getFollowers:(long long)userId 
			  cursor:(int)cursor 
			   count:(int)count
{
	needAuth = YES;
	NSString *path = [NSString stringWithFormat:@"statuses/followers.%@", API_FORMAT];
	
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	[params setObject:[NSString stringWithFormat:@"%lld", userId] forKey:@"user_id"];
	[params setObject:[NSString stringWithFormat:@"%d", cursor] forKey:@"cursor"];
    if (count > 0) {
        [params setObject:[NSString stringWithFormat:@"%d", count] forKey:@"count"];
    }
	[super asyncGet:path params:params];
}

- (void)getUser:(long long)userId
{
	needAuth = YES;
    NSString *path = [NSString stringWithFormat:@"users/show.%@", API_FORMAT];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	[params setObject:[NSString stringWithFormat:@"%lld", userId] forKey:@"user_id"];
	[super asyncGet:path params:params];
}

- (void)getUserByScreenName:(NSString *)screenName {
	needAuth = YES;
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	[params setObject:[NSString stringWithFormat:@"%@", screenName] forKey:@"screen_name"];
	
    NSString *path = [NSString stringWithFormat:@"users/show.%@", API_FORMAT];
	[super asyncGet:path params:params];
}

- (void)getFriendship:(long long)userId {
	needAuth = YES;//friendships/show.xml?target_id=10503
    NSString *path = [NSString stringWithFormat:@"friendships/show.%@", API_FORMAT];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	[params setObject:[NSString stringWithFormat:@"%lld", userId] forKey:@"target_id"];
	[super asyncGet:path params:params];
}

- (void)getUnread {
	needAuth = YES;
    NSString *path = [NSString stringWithFormat:@"statuses/unread.%@", API_FORMAT];
	[super asyncGet:path params:nil];
}

- (void)resetUnreadFollowers {
	needAuth = YES;
	NSString *path = [NSString stringWithFormat:@"statuses/reset_count.%@", API_FORMAT];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", 4] forKey:@"type"];
    [super asyncPost:path params:params withFiles:nil];
}

- (void)follow:(long long)userId {
	needAuth = YES;///friendships/create.xml?user_id=1401881
    NSString *path = [NSString stringWithFormat:@"friendships/create.%@", API_FORMAT];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:[NSString stringWithFormat:@"%lld", userId] forKey:@"user_id"];
    [super asyncPost:path params:params withFiles:nil];
	
}

- (void)unfollow:(long long)userId {
	needAuth = YES;///friendships/destroy.xml?user_id=1401881
    NSString *path = [NSString stringWithFormat:@"friendships/destroy.%@", API_FORMAT];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:[NSString stringWithFormat:@"%lld", userId] forKey:@"user_id"];
    [super asyncPost:path params:params withFiles:nil];
}

- (void)post:(NSString*)tweet latitude:(float)latitude 
							longitude:(float)longitude
{
	needAuth = YES;
    NSString *path = [NSString stringWithFormat:@"statuses/update.%@", API_FORMAT];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   tweet, @"status",
                                   [NSString stringWithFormat:@"%f", latitude], @"lat",
                                   [NSString stringWithFormat:@"%f", longitude], @"long",
                                   nil];
    [super asyncPost:path params:params withFiles:nil];

}


- (void)upload:(NSData*)jpeg status:(NSString *)status
	  latitude:(float)latitude longitude:(float)longitude
{
	needAuth = YES;
	NSString *path = [NSString stringWithFormat:@"statuses/upload.%@", API_FORMAT];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
						 status, @"status",
						 [NSString stringWithFormat:@"%f", latitude], @"lat",
						 [NSString stringWithFormat:@"%f", longitude], @"long",
                         nil];
    RequestFile *file = [[[RequestFile alloc]initWithJpegData:jpeg forKey:@"pic"] autorelease];
    [super asyncPost:path params:params withFiles:[NSArray arrayWithObject:file]];

}


- (void)repost:(long long)statusId
		 tweet:(NSString*)tweet 
	 isComment:(BOOL)isComment {
	needAuth = YES;
    NSString *path = [NSString stringWithFormat:@"statuses/repost.%@", API_FORMAT];    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:tweet forKey:@"status"];
    [params setObject:[NSString stringWithFormat:@"%lld", statusId] forKey:@"id"];
    if (isComment) {
        [params setObject:@"1" forKey:@"is_comment"];
    }
	[super asyncPost:path params:params withFiles:nil];
}


- (void)comment:(long long)statusId
	  commentId:(long long)commentId
		comment:(NSString*)comment {
	needAuth = YES;
    NSString *path = [NSString stringWithFormat:@"statuses/comment.%@", API_FORMAT];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:comment forKey:@"comment"];
    [params setObject:[NSString stringWithFormat:@"%lld", statusId] forKey:@"id"];
	if (commentId > 0) {        
        [params setObject:[NSString stringWithFormat:@"%lld", commentId] forKey:@"cid"];
	}
	[super asyncPost:path params:params withFiles:nil];
}


- (void)sendDirectMessage:(NSString*)text 
					   to:(int)recipientedId
{
	needAuth = YES;
    NSString *path = [NSString stringWithFormat:@"direct_messages/new.%@", API_FORMAT];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:text forKey:@"text"];
    [params setObject:[NSString stringWithFormat:@"%d", recipientedId] forKey:@"user_id"];
    [super asyncPost:path params:params withFiles:nil];
    
}



- (void)alert
{
    [[ZhiWeiboAppDelegate getAppDelegate] alert:errorMessage message:errorDetail];
}




@end
