//
//  MiniUser.m
//  ZhiWeibo
//
//  Created by Zhang Jason on 1/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MiniUser.h"
#import "StringUtil.h"


@implementation MiniUser

@synthesize userId;
@synthesize userKey;
@synthesize screenName;
@synthesize profileImageUrl;

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self != nil) {
        userId = [decoder decodeInt64ForKey:@"userId"];
		userKey = [[NSNumber alloc] initWithLongLong:userId];
		screenName = [[decoder decodeObjectForKey:@"screenName"] retain];
		profileImageUrl = [[decoder decodeObjectForKey:@"profileImageUrl"]retain];
    }
    return self;
}   


- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt64:userId forKey:@"userId"];
    [encoder encodeObject:screenName forKey:@"screenName"];
    [encoder encodeObject:profileImageUrl forKey:@"profileImageUrl"];
}

- (void)dealloc
{
	[userKey release];
    [screenName release];
    [profileImageUrl release];
   	[super dealloc];
}

- (MiniUser*)initWithJsonDictionary:(NSDictionary*)dic
{
	self = [super init];
    
    userId          = [[dic objectForKey:@"id"] longLongValue];
	userKey			= [[NSNumber alloc] initWithLongLong:userId];
	screenName      = [[dic objectForKey:@"screen_name"] retain];
    profileImageUrl = [[dic objectForKey:@"profile_image_url"] retain];

	return self;
}

- (MiniUser*)initWithUser:(User*)user {
	self = [super init];
    
    userId          = user.userId;
	userKey			= [[NSNumber alloc] initWithLongLong:userId];
	screenName      = [user.screenName copy];
    profileImageUrl = [user.profileImageUrl copy];
	
	return self;
}

- (MiniUser*)initWithScreenName:(NSString*)name {
	self = [super init];
	screenName = [name retain];
	return self;
}

- (NSString*)pinyinOfScreenName {
	NSMutableString *pinyin = [NSMutableString string];;
	for (int i = 0; i < screenName.length; i++) {
		char t = pinyinFirstLetter([screenName characterAtIndex:i]);
		[pinyin appendFormat:@"%c",t];						 
	}
	return [NSString stringWithString:pinyin];
}

@end
