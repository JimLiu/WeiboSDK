//
//  WeiboClient.m
//  WeiboFon
//
//  Created by kaz on 7/13/08.
//  Copyright naan studio 2008. All rights reserved.
//

#import "WeiboClient.h"
#import "DirectMessage.h"
#import "StringUtil.h"
#import "JSON.h"


@implementation WeiboClient

@synthesize request;
@synthesize context;
@synthesize hasError;
@synthesize errorMessage;
@synthesize errorDetail;

- (id)initWithTarget:(id)aDelegate engine:(OAuthEngine *)__engine action:(SEL)anAction
{
    [super initWithDelegate:aDelegate engine:__engine];
    action = anAction;
    hasError = false;
    return self;
}

- (void)dealloc
{
    [errorMessage release];
    [errorDetail release];
    [super dealloc];
}



- (NSString*) nameValString: (NSDictionary*) dict {
	NSArray* keys = [dict allKeys];
	NSString* result = [NSString string];
	int i;
	for (i = 0; i < [keys count]; i++) {
        result = [result stringByAppendingString:
                  [@"--" stringByAppendingString:
                   [TWITTERFON_FORM_BOUNDARY stringByAppendingString:
                    [@"\r\nContent-Disposition: form-data; name=\"" stringByAppendingString:
                     [[keys objectAtIndex: i] stringByAppendingString:
                      [@"\"\r\n\r\n" stringByAppendingString:
                       [[dict valueForKey: [keys objectAtIndex: i]] stringByAppendingString: @"\r\n"]]]]]]];
	}
	
	return result;
}

- (NSString *)_encodeString:(NSString *)string
{
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, 
																		   (CFStringRef)string, 
																		   NULL, 
																		   (CFStringRef)@";/?:@&=$+{}<>,",
																		   kCFStringEncodingUTF8);
    return [result autorelease];
}


- (NSString *)_queryStringWithBase:(NSString *)base parameters:(NSDictionary *)params prefixed:(BOOL)prefixed
{
    // Append base if specified.
    NSMutableString *str = [NSMutableString stringWithCapacity:0];
    if (base) {
        [str appendString:base];
    }
    
    // Append each name-value pair.
    if (params) {
        int i;
        NSArray *names = [params allKeys];
        for (i = 0; i < [names count]; i++) {
            if (i == 0 && prefixed) {
                [str appendString:@"?"];
            } else if (i > 0) {
                [str appendString:@"&"];
            }
            NSString *name = [names objectAtIndex:i];
            [str appendString:[NSString stringWithFormat:@"%@=%@", 
							   name, [self _encodeString:[params objectForKey:name]]]];
        }
    }
    
    return str;
}


- (NSString *)getURL:(NSString *)path 
	 queryParameters:(NSMutableDictionary*)params {
    NSString* fullPath = [NSString stringWithFormat:@"%@://%@/%@", 
						  (_secureConnection) ? @"https" : @"http",
						  API_DOMAIN, path];
	if (params) {
        fullPath = [self _queryStringWithBase:fullPath parameters:params prefixed:YES];
    }
	return fullPath;
}

#pragma mark -
#pragma mark REST API methods
#pragma mark -

#pragma mark Status methods


- (void)getPublicTimeline
{
	needAuth = NO;
    NSString *path = [NSString stringWithFormat:@"statuses/public_timeline.%@", API_FORMAT];
	[super get:[self getURL:path queryParameters:nil]];
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
	[super get:[self getURL:path queryParameters:params]];
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
	[super get:[self getURL:path queryParameters:params]];
}

#pragma mark -
#pragma mark Favorite


- (void)favorite:(long long)statusId
{
	needAuth = YES;
    NSString *path = [NSString stringWithFormat:@"favorites/create.%@", API_FORMAT];
    NSString *postString = [NSString stringWithFormat:@"id=%lld",
                            statusId];
	
    [self post:[self getURL:path queryParameters:nil]
		  body:postString];
}

- (void)unfavorite:(long long)statusId
{
	needAuth = YES;
    NSString *path = [NSString stringWithFormat:@"favorites/destroy/%lld.%@", statusId, API_FORMAT];
	
    [self post:[self getURL:path queryParameters:nil]
		  body:nil];
}

#pragma mark -
#pragma mark Comments


- (void)getCommentCounts:(NSMutableArray *)_statusIds {
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
	[super get:[self getURL:path queryParameters:params]];
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
	[super get:[self getURL:path queryParameters:params]];
}

- (void)getFriends:(int)userId 
	 cursor:(int)cursor 
			  count:(int)count
{
	needAuth = YES;
	NSString *path = [NSString stringWithFormat:@"statuses/friends.%@", API_FORMAT];
	
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	[params setObject:[NSString stringWithFormat:@"%d", userId] forKey:@"user_id"];
	[params setObject:[NSString stringWithFormat:@"%d", cursor] forKey:@"cursor"];
    if (count > 0) {
        [params setObject:[NSString stringWithFormat:@"%d", count] forKey:@"count"];
    }
	[super get:[self getURL:path queryParameters:params]];
}


- (void)getFollowers:(int)userId 
			cursor:(int)cursor 
			 count:(int)count
{
	needAuth = YES;
	NSString *path = [NSString stringWithFormat:@"statuses/followers.%@", API_FORMAT];
	
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	[params setObject:[NSString stringWithFormat:@"%d", userId] forKey:@"user_id"];
	[params setObject:[NSString stringWithFormat:@"%d", cursor] forKey:@"cursor"];
    if (count > 0) {
        [params setObject:[NSString stringWithFormat:@"%d", count] forKey:@"count"];
    }
	[super get:[self getURL:path queryParameters:params]];
}

- (void)getUser:(int)userId
{
	needAuth = YES;
    NSString *path = [NSString stringWithFormat:@"users/show.%@", API_FORMAT];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	[params setObject:[NSString stringWithFormat:@"%d", userId] forKey:@"user_id"];
	[super get:[self getURL:path queryParameters:params]];
}

- (void)getUserByScreenName:(NSString *)screenName {
	needAuth = YES;
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	[params setObject:[NSString stringWithFormat:@"%@", screenName] forKey:@"screen_name"];
	
    NSString *path = [NSString stringWithFormat:@"users/show.%@", API_FORMAT];
	[super get:[self getURL:path queryParameters:params]];
}

- (void)getFriendship:(int)userId {
	needAuth = YES;//friendships/show.xml?target_id=10503
    NSString *path = [NSString stringWithFormat:@"friendships/show.%@", API_FORMAT];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	[params setObject:[NSString stringWithFormat:@"%d", userId] forKey:@"target_id"];
	[super get:[self getURL:path queryParameters:params]];
}

- (void)follow:(int)userId {
	needAuth = YES;///friendships/create.xml?user_id=1401881
    NSString *path = [NSString stringWithFormat:@"friendships/create.%@", API_FORMAT];
	NSString *postString = [NSString stringWithFormat:@"user_id=%d",userId];
    [self post:[self getURL:path queryParameters:nil]
		  body:postString];
	
}

- (void)unfollow:(int)userId {
	needAuth = YES;///friendships/destroy.xml?user_id=1401881
    NSString *path = [NSString stringWithFormat:@"friendships/destroy.%@", API_FORMAT];
	NSString *postString = [NSString stringWithFormat:@"user_id=%d",userId];
    [self post:[self getURL:path queryParameters:nil]
		  body:postString];
}

- (void)post:(NSString*)tweet
{
	needAuth = YES;
    NSString *path = [NSString stringWithFormat:@"statuses/update.%@", API_FORMAT];
    NSString *postString = [NSString stringWithFormat:@"status=%@",
                            [tweet encodeAsURIComponent]];
	
    [self post:[self getURL:path queryParameters:nil]
		  body:postString];
}


- (void)upload:(NSData*)jpeg status:(NSString *)status
{
	needAuth = YES;
	NSString *path = [NSString stringWithFormat:@"statuses/upload.%@", API_FORMAT];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 status, @"status",
						 _engine.consumerKey, @"source",
                         nil];
    
    NSString *param = [self nameValString:dic];
    NSString *footer = [NSString stringWithFormat:@"\r\n--%@--\r\n", TWITTERFON_FORM_BOUNDARY];
    
    param = [param stringByAppendingString:[NSString stringWithFormat:@"--%@\r\n", TWITTERFON_FORM_BOUNDARY]];
    param = [param stringByAppendingString:@"Content-Disposition: form-data; name=\"pic\";filename=\"image.jpg\"\r\nContent-Type: image/jpeg\r\n\r\n"];
    NSLog(@"jpeg size: %d", [jpeg length]);
	
    NSMutableData *data = [NSMutableData data];
    [data appendData:[param dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:jpeg];
    [data appendData:[footer dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	[params setObject:_engine.consumerKey forKey:@"source"];
	[params setObject:status forKey:@"status"];
	//[params setObject:[NSString stringWithFormat:@"%@", statusId] forKey:@"source"];

    [self post:[self getURL:path queryParameters:params] data:data];
}


- (void)repost:(long long)statusId
		 tweet:(NSString*)tweet {
	needAuth = YES;
    NSString *path = [NSString stringWithFormat:@"statuses/repost.%@", API_FORMAT];
    NSString *postString = [NSString stringWithFormat:@"id=%lld&status=%@",
							statusId,
                            [tweet encodeAsURIComponent]];
	
    [self post:[self getURL:path queryParameters:nil]
		  body:postString];
}


- (void)comment:(long long)statusId
	  commentId:(long long)commentId
		 comment:(NSString*)comment {
	needAuth = YES;
    NSString *path = [NSString stringWithFormat:@"statuses/comment.%@", API_FORMAT];
    NSString *postString;
	if (commentId) {
		postString = [NSString stringWithFormat:@"id=%lld&cid=%lld&comment=%@",
					  statusId,
					  commentId,
					  [comment encodeAsURIComponent]];
	}
	else {
		postString = [NSString stringWithFormat:@"id=%lld&comment=%@",
					  statusId,
					  [comment encodeAsURIComponent]];
	}

	
    [self post:[self getURL:path queryParameters:nil]
		  body:postString];
}


- (void)sendDirectMessage:(NSString*)text 
		  to:(int)recipientedId
{
	needAuth = YES;
    NSString *path = [NSString stringWithFormat:@"direct_messages/new.%@", API_FORMAT];
    
    NSString *postString = [NSString stringWithFormat:@"text=%@&user_id=%d"
							, [text encodeAsURIComponent], recipientedId];
    
    [self post:[self getURL:path queryParameters:nil] body:postString];
    
}



- (void)authError
{
    self.errorMessage = @"Authentication Failed";
    self.errorDetail  = @"Wrong username/Email and password combination.";    
    [delegate performSelector:action withObject:self withObject:nil];    
}

- (void)URLConnectionDidFailWithError:(NSError*)error
{
    hasError = true;
    if (error.code ==  NSURLErrorUserCancelledAuthentication) {
        statusCode = 401;
        [self authError];
    }
    else {
        self.errorMessage = @"Connection Failed";
        self.errorDetail  = [error localizedDescription];
        [delegate performSelector:action withObject:self withObject:nil];
    }
    [self autorelease];
}

-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge previousFailureCount] == 0) {
        NSLog(@"Authentication Challenge");
        NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
        NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
        NSURLCredential* cred = [NSURLCredential credentialWithUser:username password:password persistence:NSURLCredentialPersistenceNone];
        [[challenge sender] useCredential:cred forAuthenticationChallenge:challenge];
    } else {
        NSLog(@"Failed auth (%d times)", [challenge previousFailureCount]);
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    hasError = true;
    [self authError];
    [self autorelease];
}

- (void)URLConnectionDidFinishLoading:(NSString*)content
{
    switch (statusCode) {
        case 401: // Not Authorized: either you need to provide authentication credentials, or the credentials provided aren't valid.
            hasError = true;
            [self authError];
            goto out;
            
        case 304: // Not Modified: there was no new data to return.
            [delegate performSelector:action withObject:self withObject:nil];
            goto out;
            
        case 400: // Bad Request: your request is invalid, and we'll return an error message that tells you why. This is the status code returned if you've exceeded the rate limit
        case 200: // OK: everything went awesome.
        case 403: // Forbidden: we understand your request, but are refusing to fulfill it.  An accompanying error message should explain why.
            break;
                
        case 404: // Not Found: either you're requesting an invalid URI or the resource in question doesn't exist (ex: no such user). 
        case 500: // Internal Server Error: we did something wrong.  Please post to the group about it and the Weibo team will investigate.
        case 502: // Bad Gateway: returned if Weibo is down or being upgraded.
        case 503: // Service Unavailable: the Weibo servers are up, but are overloaded with requests.  Try again later.
        default:
        {
            hasError = true;
            self.errorMessage = @"Server responded with an error";
            self.errorDetail  = [NSHTTPURLResponse localizedStringForStatusCode:statusCode];
            [delegate performSelector:action withObject:self withObject:nil];
            goto out;
        }
    }
#if 0
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *pathStr;
    if (request == 0) {
        pathStr = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"friends_timeline.json"];
    }
    else if (request == 1) {
        pathStr = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"replies.json"];
    }
    else if (request == 2) {
        pathStr = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"direct_messages.json"];
    }
    if (request <= 2) {
        NSData *data = [fileManager contentsAtPath:pathStr];
        content = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    }
#endif

    NSObject *obj = [content JSONValue];
    if (request == WEIBO_REQUEST_FRIENDSHIP_EXISTS) {
        NSRange r = [content rangeOfString:@"true" options:NSCaseInsensitiveSearch];
  	  	obj = [NSNumber numberWithBool:r.location != NSNotFound];
    }
    
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary* dic = (NSDictionary*)obj;
        NSString *msg = [dic objectForKey:@"error"];
        if (msg) {
            NSLog(@"Weibo responded with an error: %@", msg);
            hasError = true;
            self.errorMessage = @"Weibo Server Error";
            self.errorDetail  = msg;
        }
    }
    
    [delegate performSelector:action withObject:self withObject:obj];
    
  out:
    [self autorelease];
}

- (void)alert
{
	UIAlertView *sAlert = [[[UIAlertView alloc] initWithTitle:errorMessage
                                        message:errorDetail
									   delegate:self
							  cancelButtonTitle:@"Close"
							  otherButtonTitles:nil] autorelease];
    [sAlert show];
}

@end
