//
//  Status.m
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-9-4.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "Status.h"

@implementation Status
@synthesize statusIdString = _statusIdString;
@synthesize createdAt = _createdAt;
@synthesize statusId = _statusId;
@synthesize text = _text;
@synthesize source = _source;
@synthesize sourceUrl = _sourceUrl;
@synthesize favorited = _favorited;
@synthesize truncated = _truncated;
@synthesize inReplyToStatusId = _inReplyToStatusId;
@synthesize inReplyToUserId = _inReplyToUserId;
@synthesize inReplyToScreenName = _inReplyToScreenName;
@synthesize mid = _mid;
@synthesize middleImageUrl = _middleImageUrl;
@synthesize originalImageUrl = _originalImageUrl;
@synthesize thumbnailImageUrl = _thumbnailImageUrl;
@synthesize repostsCount = _repostsCount;
@synthesize commentsCount = _commentsCount;
@synthesize geo = _geo;
@synthesize user = _user;
@synthesize retweetedStatus = _retweetedStatus;

+ (Status *)statusWithJsonDictionary:(NSDictionary*)dic {
    return [[[Status alloc] initWithJsonDictionary:dic] autorelease];
}

- (id)initWithJsonDictionary:(NSDictionary*)dic
{
	self = [super init];
    if (self) {
        self.statusIdString = [dic stringValueForKey:@"idstr"];
        self.createdAt = [dic timeValueForKey:@"created_at"];
        self.statusId = [dic longLongValueForKey:@"id"];
        self.text = [dic stringValueForKey:@"text"];
        self.favorited = [dic boolValueForKey:@"favorited"];
        self.truncated = [dic boolValueForKey:@"truncated"];
        self.inReplyToStatusId = [dic longLongValueForKey:@"in_reply_to_status_id"];
        self.inReplyToUserId = [dic longLongValueForKey:@"in_reply_to_user_id"];
        self.inReplyToScreenName = [dic stringValueForKey:@"in_reply_to_screen_name"];
        self.mid = [dic longLongValueForKey:@"mid"];
        self.middleImageUrl = [dic stringValueForKey:@"bmiddle_pic"];
        self.originalImageUrl = [dic stringValueForKey:@"original_pic"];
        self.thumbnailImageUrl = [dic stringValueForKey:@"thumbnail_pic"];
        self.repostsCount = [dic intValueForKey:@"reposts_count"];
        self.commentsCount = [dic intValueForKey:@"comments_count"];
        NSDictionary *geoDic = [dic dictionaryValueForKey:@"geo"];
        if (geoDic) {
            self.geo = [[[GeoInfo alloc]initWithJsonDictionary:geoDic]autorelease];
        }
        else {
            self.geo = nil;
        }
        NSDictionary *userDic = [dic dictionaryValueForKey:@"user"];
        if (userDic) {
            self.user = [[[User alloc]initWithJsonDictionary:userDic]autorelease];
        }
        else {
            self.user = nil;
        }
        NSDictionary *retweetedStatusDic = [dic dictionaryValueForKey:@"retweeted_status"];
        if (retweetedStatusDic) {
            self.retweetedStatus = [Status statusWithJsonDictionary:retweetedStatusDic];
        }
        else {
            self.retweetedStatus = nil;
        }        
        // parse source parameter
        NSString *source, *sourceUrl;
		NSString *src = [dic stringValueForKey:@"source"];
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
        self.source = source;
        self.sourceUrl = sourceUrl;
    }
    return self;
}

//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.statusIdString forKey:@"statusIdString"];
    [encoder encodeInt:self.createdAt forKey:@"createdAt"];
    [encoder encodeObject:[NSNumber numberWithLongLong:self.statusId] forKey:@"statusId"];
    [encoder encodeObject:self.text forKey:@"text"];
    [encoder encodeObject:self.source forKey:@"source"];
    [encoder encodeObject:self.sourceUrl forKey:@"sourceUrl"];
    [encoder encodeBool:self.favorited forKey:@"favorited"];
    [encoder encodeBool:self.truncated forKey:@"truncated"];
    [encoder encodeObject:[NSNumber numberWithLongLong:self.inReplyToStatusId] forKey:@"inReplyToStatusId"];
    [encoder encodeObject:[NSNumber numberWithLongLong:self.inReplyToUserId] forKey:@"inReplyToUserId"];
    [encoder encodeObject:self.inReplyToScreenName forKey:@"inReplyToScreenName"];
    [encoder encodeObject:[NSNumber numberWithLongLong:self.mid] forKey:@"mid"];
    [encoder encodeObject:self.middleImageUrl forKey:@"middleImageUrl"];
    [encoder encodeObject:self.originalImageUrl forKey:@"originalImageUrl"];
    [encoder encodeObject:self.thumbnailImageUrl forKey:@"thumbnailImageUrl"];
    [encoder encodeInt:self.repostsCount forKey:@"repostsCount"];
    [encoder encodeInt:self.commentsCount forKey:@"commentsCount"];
    [encoder encodeObject:self.geo forKey:@"geo"];
    [encoder encodeObject:self.user forKey:@"user"];
    [encoder encodeObject:self.retweetedStatus forKey:@"retweetedStatus"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.statusIdString = [decoder decodeObjectForKey:@"statusIdString"];
        self.createdAt = [decoder decodeIntForKey:@"createdAt"];
        [self setStatusId:[[decoder decodeObjectForKey:@"statusId"] longLongValue]];
        self.text = [decoder decodeObjectForKey:@"text"];
        self.source = [decoder decodeObjectForKey:@"source"];
        self.sourceUrl = [decoder decodeObjectForKey:@"sourceUrl"];
        self.favorited = [decoder decodeBoolForKey:@"favorited"];
        self.truncated = [decoder decodeBoolForKey:@"truncated"];
        [self setInReplyToStatusId:[[decoder decodeObjectForKey:@"inReplyToStatusId"] longLongValue]];
        [self setInReplyToUserId:[[decoder decodeObjectForKey:@"inReplyToUserId"] longLongValue]];
        self.inReplyToScreenName = [decoder decodeObjectForKey:@"inReplyToScreenName"];
        [self setMid:[[decoder decodeObjectForKey:@"mid"] longLongValue]];
        self.middleImageUrl = [decoder decodeObjectForKey:@"middleImageUrl"];
        self.originalImageUrl = [decoder decodeObjectForKey:@"originalImageUrl"];
        self.thumbnailImageUrl = [decoder decodeObjectForKey:@"thumbnailImageUrl"];
        self.repostsCount = [decoder decodeIntForKey:@"repostsCount"];
        self.commentsCount = [decoder decodeIntForKey:@"commentsCount"];
        self.geo = [decoder decodeObjectForKey:@"geo"];
        self.user = [decoder decodeObjectForKey:@"user"];
        self.retweetedStatus = [decoder decodeObjectForKey:@"retweetedStatus"];
    }
    return self;
}


//===========================================================
// dealloc
//===========================================================
- (void)dealloc
{
    [_statusIdString release];
    [_text release];
    [_source release];
    [_sourceUrl release];
    [_inReplyToScreenName release];
    [_middleImageUrl release];
    [_originalImageUrl release];
    [_thumbnailImageUrl release];
    [_geo release];
    [_user release];
    [_retweetedStatus release];
    [_statusKey release];
    
    [super dealloc];
}

- (NSNumber *)statusKey {
    if (!_statusKey) {
        _statusKey = [[NSNumber numberWithLongLong:_statusId]retain];
    }
    return _statusKey;
}

- (NSString*)timestamp:(time_t)t
{
	NSString *_timestamp;
    // Calculate distance time string
    //
    time_t now;
    time(&now);
    
    int distance = (int)difftime(now, t);
    if (distance < 0) distance = 0;
    
    if (distance < 60) {
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @" second ago" : @" seconds ago"];
    }
    else if (distance < 60 * 60) {
        distance = distance / 60;
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @" minute ago" : @" minutes ago"];
    }
    else if (distance < 60 * 60 * 24) {
        distance = distance / 60 / 60;
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @" hour ago" : @" hours ago"];
    }
    else if (distance < 60 * 60 * 24 * 7) {
        distance = distance / 60 / 60 / 24;
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @" day ago" : @" days ago"];
    }
    else if (distance < 60 * 60 * 24 * 7 * 4) {
        distance = distance / 60 / 60 / 24 / 7;
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @" week ago" : @" weeks ago"];
    }
    else {
        static NSDateFormatter *dateFormatter = nil;
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
        }
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
        _timestamp = [dateFormatter stringFromDate:date];
    }
    return _timestamp;
}

- (NSString*)statusTimeString {
    return [self timestamp:_createdAt];
}

- (NSString*)statusDateTimeString {
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_createdAt];
    return [dateFormatter stringFromDate:date];
}


@end
