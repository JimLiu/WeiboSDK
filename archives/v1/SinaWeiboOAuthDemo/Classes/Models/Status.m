//
//  Status.m
//  WeiboPad
//
//  Created by junmin liu on 10-10-6.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "Status.h"
#import "RegexKitLite.h"

@implementation Status
@synthesize statusId, createdAt, text, source, sourceUrl, favorited, truncated, longitude, latitude, inReplyToStatusId;
@synthesize inReplyToUserId, inReplyToScreenName, thumbnailPic, bmiddlePic, originalPic, user;
@synthesize commentsCount, retweetsCount, retweetedStatus, unread, hasReply;
@synthesize statusKey;


- (id)initWithStatement:(Statement *)stmt {
	if (self = [super init]) {
		statusId = [stmt getInt64:0];
		statusKey = [[NSNumber alloc]initWithLongLong:statusId];
		createdAt = [stmt getInt32:1];
		text = [[stmt getString:2] retain];
		source = [[stmt getString:3] retain];
		sourceUrl = [[stmt getString:4] retain];
		favorited = [stmt getInt32:5];
		truncated = [stmt getInt32:6];
		latitude = [stmt getDouble:7];
		longitude = [stmt getDouble:8];
		inReplyToStatusId = [stmt getInt64:9];
		inReplyToUserId = [stmt getInt32:10];
		inReplyToScreenName = [[stmt getString:11] retain];
		thumbnailPic = [[stmt getString:12] retain];
		bmiddlePic = [[stmt getString:13] retain];
		originalPic = [[stmt getString:14] retain];
		user = [[User userWithId:[stmt getInt32:15]] retain];
		commentsCount = [stmt getInt32:16];
		retweetsCount = [stmt getInt32:17];
		unread = [stmt getInt32:19];
		hasReply = [stmt getInt32:20];
	}
	return self;
}

- (Status*)initWithJsonDictionary:(NSDictionary*)dic {
	if (self = [super init]) {
		statusId = [dic getLongLongValueValueForKey:@"id" defaultValue:-1];
		statusKey = [[NSNumber alloc]initWithLongLong:statusId];
		createdAt = [dic getTimeValueForKey:@"created_at" defaultValue:0];
		text = [[dic getStringValueForKey:@"text" defaultValue:@""] retain];
		
		// parse source parameter
		NSString *src = [dic getStringValueForKey:@"source" defaultValue:@""];
		NSRange r = [src rangeOfString:@"<a href"];
		NSRange end;
		if (r.location != NSNotFound) {
			NSRange start = [src rangeOfString:@"<a href=\""];
			if (start.location != NSNotFound) {
				int l = [src length];
				NSRange fromRang = NSMakeRange(start.location + start.length, l-start.length-start.location);
				end   = [src rangeOfString:@"\"" options:NSCaseInsensitiveSearch 
											 range:fromRang];
				if (end.location != NSNotFound) {
					r.location = start.location + start.length;
					r.length = end.location - r.location;
					sourceUrl = [src substringWithRange:r];
				}
				else {
					sourceUrl = @"";
				}
			}
			else {
				sourceUrl = @"";
			}			
			start = [src rangeOfString:@"\">"];
			end   = [src rangeOfString:@"</a>"];
			if (start.location != NSNotFound && end.location != NSNotFound) {
				r.location = start.location + start.length;
				r.length = end.location - r.location;
				source = [src substringWithRange:r];
			}
			else {
				source = @"";
			}
		}
		else {
			source = src;
		}
		source = [source retain];
		sourceUrl = [sourceUrl retain];
		
		favorited = [dic getBoolValueForKey:@"favorited" defaultValue:NO];
		truncated = [dic getBoolValueForKey:@"truncated" defaultValue:NO];
		
		NSDictionary* geoDic = [dic objectForKey:@"geo"];
		if (geoDic && [geoDic isKindOfClass:[NSDictionary class]]) {
			NSArray *coordinates = [geoDic objectForKey:@"coordinates"];
			if (coordinates && coordinates.count == 2) {
				longitude = [[coordinates objectAtIndex:0] doubleValue];
				latitude = [[coordinates objectAtIndex:1] doubleValue];
			}
		}
		
		inReplyToStatusId = [dic getLongLongValueValueForKey:@"in_reply_to_status_id" defaultValue:-1];
		inReplyToUserId = [dic getIntValueForKey:@"in_reply_to_user_id" defaultValue:-1];
		inReplyToScreenName = [[dic getStringValueForKey:@"in_reply_to_screen_name" defaultValue:@""] retain];
		thumbnailPic = [[dic getStringValueForKey:@"thumbnail_pic" defaultValue:@""] retain];
		bmiddlePic = [[dic getStringValueForKey:@"bmiddle_pic" defaultValue:@""] retain];
		originalPic = [[dic getStringValueForKey:@"original_pic" defaultValue:@""] retain];
		
		NSDictionary* userDic = [dic objectForKey:@"user"];
		if (userDic) {
			user = [[User userWithJsonDictionary:userDic] retain];
		}
		
		NSDictionary* retweetedStatusDic = [dic objectForKey:@"retweeted_status"];
		if (retweetedStatusDic) {
			retweetedStatus = [[Status statusWithJsonDictionary:retweetedStatusDic] retain];
		}
	}
	return self;
}

+ (Status*)statusWithJsonDictionary:(NSDictionary*)dic
{
	return [[[Status alloc] initWithJsonDictionary:dic] autorelease];
}


- (NSString*)timestamp
{
	NSString *_timestamp;
    // Calculate distance time string
    //
    time_t now;
    time(&now);
    
    int distance = (int)difftime(now, createdAt);
    if (distance < 0) distance = 0;
    
    if (distance < 60) {
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"秒前" : @"秒前"];
    }
    else if (distance < 60 * 60) {  
        distance = distance / 60;
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"分钟前" : @"分钟前"];
    }  
    else if (distance < 60 * 60 * 24) {
        distance = distance / 60 / 60;
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"小时前" : @"小时前"];
    }
    else if (distance < 60 * 60 * 24 * 7) {
        distance = distance / 60 / 60 / 24;
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"天前" : @"天前"];
    }
    else if (distance < 60 * 60 * 24 * 7 * 4) {
        distance = distance / 60 / 60 / 24 / 7;
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"周前" : @"周前"];
    }
    else {
        static NSDateFormatter *dateFormatter = nil;
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        }
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:createdAt];        
        _timestamp = [dateFormatter stringFromDate:date];
    }
    return _timestamp;
}


- (void)dealloc {
	[text release];
	[source release];
	[sourceUrl release];
	[inReplyToScreenName release];
	[thumbnailPic release];
	[bmiddlePic release];
	[originalPic release];
	[user release];
	[retweetedStatus release];
	[statusKey release];
	[super dealloc];
}

+ (Status*)statusWithStatusId:(long long)statusId {
	
    Status *status;
	
    static Statement *stmt = nil;
    if (stmt == nil) {
        stmt = [DBConnection statementWithQuery:"SELECT * FROM statuses WHERE statusId = ?"];
        [stmt retain];
    }
    
    [stmt bindInt64:statusId forIndex:1];
    int ret = [stmt step];
    if (ret != SQLITE_ROW) {
        [stmt reset];
        return nil;
    }
    
    status = [[[Status alloc] initWithStatement:stmt] autorelease];
	long long retweetedStatusId = [stmt getInt64:18];	
    [stmt reset];
	
	if (retweetedStatusId > 0) {
		status.retweetedStatus = [Status statusWithStatusId:retweetedStatusId];
	}
	
	return status;
	
}


+ (BOOL)isExists:(sqlite_int64)aStatusId
{
    static Statement *stmt = nil;
    if (stmt == nil) {
        stmt = [DBConnection statementWithQuery:"SELECT statusId FROM statuses WHERE statusId=?"];
        [stmt retain];
    }
    
    [stmt bindInt64:aStatusId forIndex:1];
    
    BOOL result = ([stmt step] == SQLITE_ROW) ? true : false;
    [stmt reset];
    return result;
}


- (void)insertDB
{
	
    [user updateDB];

    static Statement *stmt = nil;
    if (stmt == nil) {
        stmt = [DBConnection statementWithQuery:"REPLACE INTO statuses VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"];
        [stmt retain];
    }
    [stmt bindInt64:statusId    forIndex:1];
	[stmt bindInt32:createdAt   forIndex:2];
	[stmt bindString:text       forIndex:3];
	[stmt bindString:source       forIndex:4];
	[stmt bindString:sourceUrl       forIndex:5];
	[stmt bindInt32:favorited       forIndex:6];
	[stmt bindInt32:truncated       forIndex:7];
	[stmt bindDouble:latitude		forIndex:8];
	[stmt bindDouble:longitude		forIndex:9];
	[stmt bindInt32:inReplyToStatusId forIndex:10];
	[stmt bindInt32:inReplyToUserId forIndex:11];
	[stmt bindString:inReplyToScreenName forIndex:12];
	[stmt bindString:thumbnailPic forIndex:13];
	[stmt bindString:bmiddlePic forIndex:14];
	[stmt bindString:originalPic forIndex:15];
	[stmt bindInt32:user.userId       forIndex:16];
	[stmt bindInt32:commentsCount       forIndex:17];
	[stmt bindInt32:retweetsCount       forIndex:18];
	if (retweetedStatus) {
		[stmt bindInt64:retweetedStatus.statusId       forIndex:19];
	}
	else {
		[stmt bindInt32:-1       forIndex:19];
	}
	[stmt bindInt32:unread forIndex:20];
	[stmt bindInt32:hasReply forIndex:21];
    
	int step = [stmt step];
    if (step != SQLITE_DONE) {
		NSLog(@"update error  status: %lld.%@, %@, %@, %@", statusId, text
			  , inReplyToScreenName, thumbnailPic, sourceUrl);
        [DBConnection alert];
    }
    [stmt reset];
	
	if (retweetedStatus) {
		[retweetedStatus insertDB];
	}
}


- (void)deleteFromDB
{
    Statement *stmt = [DBConnection statementWithQuery:"DELETE FROM statuses WHERE statusId = ?"];
    [stmt bindInt64:statusId forIndex:1];
    [stmt step]; // ignore error
}



@end
