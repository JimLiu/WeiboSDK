//
//  UserQuery.m
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-8-31.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "UserQuery.h"

@implementation UserQuery
@synthesize completionBlock = _completionBlock;


- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


+ (UserQuery *)query {
    return [[[UserQuery alloc]init]autorelease];
}

- (void)dealloc {
    [_completionBlock release];
    [super dealloc];
}


- (void)queryWithUserId:(long long)userId {
    [super getWithAPIPath:@"users/show.json"
                   params:[NSMutableDictionary dictionaryWithObject:[NSString stringWithFormat:@"%lld", userId] forKey:@"uid"]];
}

- (void)queryWithScreenName:(NSString *)screenName {
    [super getWithAPIPath:@"users/show.json"
                   params:[NSMutableDictionary dictionaryWithObject:screenName forKey:@"screen_name"]];
}


- (void)requestFailedWithError:(NSError *)error {
    if (_completionBlock) {
        _completionBlock(_request, nil, error);
    }
}

- (void)requestFinishedWithObject:(id)object {
    User *user = [[[User alloc]initWithJsonDictionary:object]autorelease];
    if (_completionBlock) {
        _completionBlock(_request, user, nil);
    }
}

@end
