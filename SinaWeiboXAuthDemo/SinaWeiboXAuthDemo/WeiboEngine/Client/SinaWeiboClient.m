//
//  SinaWeiboClient.m
//  Zhiweibo2
//
//  Created by junmin liu on 11-2-21.
//  Copyright 2011 Openlab. All rights reserved.
//

#import "SinaWeiboClient.h"


@implementation SinaWeiboClient

- (void)dealloc {
	[super dealloc];
}

+ (SinaWeiboClient *)connectionWithDelegate:(id)aDelegate 
									 action:(SEL)anAction
									  oAuth:(OAuth *)_oAuth {
	SinaWeiboClient *connection = [[[SinaWeiboClient alloc]initWithDelegate:aDelegate
																	 action:anAction
																	  oAuth:_oAuth] autorelease];
	return connection;
}

+ (SinaWeiboClient *)connectionWithDelegate:(id)aDelegate 
									 action:(SEL)anAction {
	SinaWeiboClient *connection = [[[SinaWeiboClient alloc]initWithDelegate:aDelegate
																	 action:anAction] autorelease];
	return connection;
}


- (void)processError:(NSDictionary *)dic {
	NSString *msg = [dic objectForKey:@"error"];
	if (msg) {
		NSLog(@"Weibo responded with an error: %@", msg);
		int errorCode = 0;//[[dic objectForKey:@"error_code"] intValue];
		NSRange range = [msg rangeOfString:@":"];
		if (range.length == 1 && range.location != NSNotFound) {
			errorCode = [[msg substringToIndex:range.location] intValue];
		}
		hasError = true;
		switch (errorCode) {
			default: 
				self.errorMessage = @"Weibo Server Error";
				self.errorDetail  = msg;
				break;					
		}
	}
}

- (NSString *)baseUrl {
	return @"http://api.t.sina.com.cn/";
}


#pragma mark -
#pragma mark overide public methods

- (void)verifyCredentials {
	[self asyncGet:@"account/verify_credentials.json" params:nil];
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
	[super asyncGet:@"statuses/friends_timeline.json" params:params];
}



- (void)post:(NSString*)tweet
{
	needAuth = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:tweet forKey:@"status"];
	[super asyncPost:@"statuses/update.json" params:params withFiles:nil];

}


- (void)upload:(NSData*)jpeg status:(NSString *)status
{
    needAuth = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:status forKey:@"status"];
    RequestFile *file = [[[RequestFile alloc]initWithJpegData:jpeg forKey:@"pic"]autorelease];
	[super asyncPost:@"statuses/upload.json" params:params withFiles:[NSArray arrayWithObject:file]];

    /*
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
     */
}

@end
