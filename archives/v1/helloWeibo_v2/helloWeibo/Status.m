//
//  Status.m
//  helloWeibo
//
//  Created by junmin liu on 11-4-13.
//  Copyright 2011年 Openlab. All rights reserved.
//

#import "Status.h"


@implementation Status
@synthesize statusId = _statusId;
@synthesize createdAt = _createdAt;
@synthesize text = _text;
@synthesize thumbnailPic = _thumbnailPic;
@synthesize bmiddlePic = _bmiddlePic;
@synthesize originalPic = _originalPic;
@synthesize user = _user;
@synthesize commentsCount = _commentsCount;
@synthesize retweetsCount = _retweetsCount;
@synthesize retweetedStatus = _retweetedStatus;
@synthesize source = _source;
@synthesize sourceUrl = _sourceUrl;


long long		_statusId; //微博ID
time_t          _createdAt;
NSString*       _text; //微博信息内容
NSString*		_thumbnailPic; //缩略图
NSString*		_bmiddlePic; //中型图片
NSString*		_originalPic; //原始图片
User*           _user; //作者信息
int				_commentsCount; // 评论数
int				_retweetsCount; // 转发数
Status*			_retweetedStatus; //转发的博文，内容为status，如果不是转发，则没有此字段


- (time_t)getTimeValueFromString:(NSString *)stringTime {
    if ((id)stringTime == [NSNull null]) {
        stringTime = @"";
    }
	struct tm created;
    time_t now;
    time(&now);
    
	if (stringTime) {
		if (strptime([stringTime UTF8String], "%a %b %d %H:%M:%S %z %Y", &created) == NULL) {
			strptime([stringTime UTF8String], "%a, %d %b %Y %H:%M:%S %z", &created);
		}
		return mktime(&created);
	}
	return 0;
}

- (id)initWithJsonDictionary:(NSDictionary*)dic {
    self = [super init];
    if (self) {
        _statusId = [[dic objectForKey:@"id"] longLongValue];
        _createdAt = [self getTimeValueFromString:[dic objectForKey:@"created_at"]];
        _text = [[dic objectForKey:@"text"] retain];
        _thumbnailPic = [[dic objectForKey:@"thumbnail_pic"] retain];
        _bmiddlePic = [[dic objectForKey:@"bmiddle_pic"] retain];
        _originalPic = [[dic objectForKey:@"originalPic"] retain];
		_commentsCount = -1;
		_retweetsCount = -1;
        NSDictionary* userDic = [dic objectForKey:@"user"];
		if (userDic) {
			_user = [[User userWithJsonDictionary:userDic] retain];
		}
		
		NSDictionary* retweetedStatusDic = [dic objectForKey:@"retweeted_status"];
		if (retweetedStatusDic) {
			_retweetedStatus = [[Status statusWithJsonDictionary:retweetedStatusDic] retain];
		}
        
        // parse source parameter
		NSString *src = [dic objectForKey:@"source"];
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
					_sourceUrl = [src substringWithRange:r];
				}
				else {
					_sourceUrl = @"";
				}
			}
			else {
				_sourceUrl = @"";
			}			
			start = [src rangeOfString:@"\">"];
			end   = [src rangeOfString:@"</a>"];
			if (start.location != NSNotFound && end.location != NSNotFound) {
				r.location = start.location + start.length;
				r.length = end.location - r.location;
				_source = [src substringWithRange:r];
			}
			else {
				_source = @"";
			}
		}
		else {
			_source = src;
		}
		_source = [_source retain];
		_sourceUrl = [_sourceUrl retain];

    }
    return self;
}

+ (Status*)statusWithJsonDictionary:(NSDictionary*)dic {
    return [[[Status alloc]initWithJsonDictionary:dic]autorelease];
}

- (void)dealloc {
    [_text release];
    [_thumbnailPic release];
    [_bmiddlePic release];
    [_originalPic release];
    [_user release];
    [_retweetedStatus release];
    [_source release];
    [_sourceUrl release];
    [_timeString release];
    [super dealloc];
}


- (NSString*)timestamp
{
	NSString *_timestamp;
    // Calculate distance time string
    //
    time_t now;
    time(&now);
    
    int distance = (int)difftime(now, _createdAt);
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
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_createdAt];        
        _timestamp = [dateFormatter stringFromDate:date];
    }
    return _timestamp;
}

- (NSString *)timeString {
	if (!_timeString) {
		static NSDateFormatter *dateFormatter = nil;
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        }
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_createdAt];        
        _timeString = [[dateFormatter stringFromDate:date] copy];
	}
	return _timeString;
}

- (NSString *)commentsCountText {
	return _commentsCount > 0 ? [NSString stringWithFormat:@"(%d)", _commentsCount] : @"";
}

- (NSString *)retweetsCountText {
	return _retweetsCount > 0 ? [NSString stringWithFormat:@"(%d)", _retweetsCount] : @"";
}


@end
