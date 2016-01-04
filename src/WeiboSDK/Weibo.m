//
//  Weibo.m
//  WeiboSDK
//
//  Created by Liu Jim on 8/4/13.
//  Copyright (c) 2013 openlab. All rights reserved.
//

#import "Weibo.h"
#import "NSDictionary+Json.h"
#import "WeiboSignIn.h"
#import "WeiboAccounts.h"

NSString *const WeiboErrorDomain = @"com.openlab.weibosdk";

static Weibo *g_weibo = nil;

@interface Weibo ()

@property (nonatomic, strong) WeiboLoginDialog *loginDialog;
@property (nonatomic, strong) WeiboAuthentication *authentication;
@property (nonatomic, strong) WeiboSignIn *weiboSignIn;

@end


@implementation Weibo

- (id)initWithAppKey:(NSString *)appKey
       withAppSecret:(NSString *)appSecret
       withRedirectURI: (NSString *)redirectURI {
    self = [super init];
    if (self) {
        self.appKey = appKey;
        self.appSecret = appSecret;
        self.redirectURI = redirectURI;
        self.authentication = [[WeiboAuthentication alloc]initWithAuthorizeURL:kWeiboAuthorizeURL accessTokenURL:kWeiboAccessTokenURL appKey:self.appKey appSecret:self.appSecret redirectURI: self.redirectURI];

    }
    return self;
}


+ (Weibo*)weibo {
    if (!g_weibo) {
        Weibo *weibo = [[Weibo alloc] initWithAppKey:kAppKey withAppSecret:kAppSecret withRedirectURI:kRedirectURI];
        [[self class] setWeibo:weibo];
    }
    return g_weibo;
}

// Just invoke the weibo method
+ (Weibo*)getWeibo {
    return [self weibo];
}

+ (Weibo*)setWeibo:(Weibo*)weibo {
    
    if (weibo != g_weibo) {
        g_weibo = weibo;
    }
    
    return weibo;
}

#pragma mark - Auth

- (BOOL)isAuthenticated {
    return [[WeiboAccounts shared]currentAccount] != NULL;
}

- (void)authorizeWithCompleted:(WeiboUserAuthenticationCompletedBlock)completedBlock {
    if (!self.weiboSignIn) {
        [self.weiboSignIn cancel];
    }
    self.weiboSignIn = [[WeiboSignIn alloc] initWithWeiboAuthentication:self.authentication withBlock:^(WeiboAuthentication *auth, NSError *error) {
        if (!error) {
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:auth.userId, @"uid", auth.accessToken, @"access_token", nil];
            [self queryUserWithPath:@"users/show.json"
                             params:params
                          completed:^(User *user, NSError *error) {
                              self.weiboSignIn = nil;
                              if (error) {
                                  completedBlock(nil, error);
                              }
                              else {
                                  NSLog(@"user:%@", user.screenName);
                                  WeiboAccount *account = [[WeiboAccount alloc]initWithAuthentication:auth user:user];
                                  //if (saveAccount) {
                                      [[WeiboAccounts shared] addAccount:account];
                                  //}
                                  [[WeiboRequest shared] setAccessToken:auth.accessToken];
                                  completedBlock(account, nil);
                              }
            }];
            
        }
        else {
            self.weiboSignIn = nil;
            completedBlock(nil, error);
        }
    }];
    [self.weiboSignIn signIn];
}

- (void)signOut {
    [[WeiboAccounts shared] signOut];
}

- (WeiboAccount *)currentAccount {
    return [[WeiboAccounts shared]currentAccount];
}

#pragma mark - User Query


- (WeiboRequestOperation *)queryUserWithPath:(NSString *)path
                                      params:(NSDictionary *)params
                                   completed:(WeiboUserQueryCompletedBlock)completedBlock {
    WeiboRequestOperation *operation =
    [[WeiboRequest shared] getFromPath:path
                                params:params
                             completed:^(id result, NSData *data, NSError *error) {
                                 if (error) {
                                     completedBlock(nil, error);
                                 }
                                 else {
                                     @try {
                                         User *user = [[User alloc]initWithJsonDictionary:result];
                                         completedBlock(user, nil);
                                     }
                                     @catch (NSException *exception) {
                                         NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                         NSString *msg = [NSString stringWithFormat:@"Failed to parse responsed object. responseString: %@", responseString];
                                         completedBlock(nil, [NSError errorWithDomain:WeiboErrorDomain code:kJsonParseUserErrorCode userInfo:@{NSLocalizedDescriptionKey: msg}]);
                                     }
                                     @finally {
                                         
                                     }
                                 }
                                 
                                 
                             }];
    return operation;
}


- (WeiboRequestOperation *)queryWithUserId:(long long)userId
                                 completed:(WeiboUserQueryCompletedBlock)completedBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:[NSString stringWithFormat:@"%lld", userId] forKey:@"uid"];
    return [self queryUserWithPath:@"users/show.json"
                            params:params completed:completedBlock];
}




#pragma mark - Timeline Query


- (NSMutableArray *)pareseTimelineResponseObject:(id)object {
    NSMutableArray *statuses = nil;
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)object;
        NSArray *statusesArray = [dic arrayValueForKey:@"statuses"];
        if (statusesArray) {
            statuses = [NSMutableArray array];
            for (NSDictionary *statusDic in statusesArray) {
                Status *status = [Status statusWithJsonDictionary:statusDic];
                [statuses addObject:status];
            }
        }
    }
    return statuses;
}


- (WeiboRequestOperation *)queryTimelineWithPath:(NSString *)path
                                          params:(NSDictionary *)params
                                       completed:(WeiboTimelineQueryCompletedBlock)completedBlock {
    WeiboRequestOperation *operation =
        [[WeiboRequest shared] getFromPath:path
                                    params:params
                                 completed:^(id result, NSData *data, NSError *error) {
             if (error) {
                 completedBlock(nil, error);
             }
             else {
                 NSMutableArray *statuses = [self pareseTimelineResponseObject:result];
                 if (statuses) {
                     completedBlock(statuses, nil);
                 }
                 else {
                     completedBlock(nil, [NSError errorWithDomain:WeiboErrorDomain code:kJsonParseTimelineErrorCode userInfo:@{NSLocalizedDescriptionKey: @"Failed to parse responsed object."}]);
                 }
             }
                                     
                                                                    
        }];
    return operation;
}

- (WeiboRequestOperation *)queryPublicTimelineWithCount:(int)count
                                              completed:(WeiboTimelineQueryCompletedBlock)completedBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   self.appKey, @"source",
                                   [NSString stringWithFormat:@"%d", count], @"count"
                                   , nil];
    return [self queryTimelineWithPath:@"statuses/public_timeline.json" params:params completed:completedBlock];
}

- (WeiboRequestOperation *)queryTimeline:(StatusTimeline)timeline
                                 sinceId:(long long)sinceId
                                   maxId:(long long)maxId
                                   count:(int)count
                               completed:(WeiboTimelineQueryCompletedBlock)completedBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [NSString stringWithFormat:@"%lld", sinceId], @"since_id",
                                   [NSString stringWithFormat:@"%lld", maxId], @"max_id",
                                   [NSString stringWithFormat:@"%d", count], @"count"
                                   , nil];
    NSString *queryPath = nil;
    if (timeline == StatusTimelineMentions) {
        queryPath = @"statuses/mentions.json";
    }
    queryPath = @"statuses/friends_timeline.json";
    return [self queryTimelineWithPath:queryPath params:params completed:completedBlock];
}

- (WeiboRequestOperation *)queryTimeline:(StatusTimeline)timeline
                                 sinceId:(long long)sinceId
                                   count:(int)count
                               completed:(WeiboTimelineQueryCompletedBlock)completedBlock {
    return [self queryTimeline:timeline sinceId:sinceId maxId:0 count:count completed:completedBlock];
}


- (WeiboRequestOperation *)queryTimeline:(StatusTimeline)timeline
                                   maxId:(long long)maxId
                                   count:(int)count
                               completed:(WeiboTimelineQueryCompletedBlock)completedBlock {
    return [self queryTimeline:timeline sinceId:0 maxId:maxId count:count completed:completedBlock];
}

- (WeiboRequestOperation *)queryTimeline:(StatusTimeline)timeline
                                   count:(int)count
                               completed:(WeiboTimelineQueryCompletedBlock)completedBlock {
    return [self queryTimeline:timeline sinceId:0 maxId:0 count:count completed:completedBlock];
}


#pragma mark - Post


- (WeiboRequestOperation *)newStatus:(NSString *)status
                                 pic:(NSData *)picData
                           completed:(WeiboNewStatusCompletedBlock)completedBlock {
    NSString *path = picData.length ? @"statuses/upload.json" : @"statuses/update.json";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:status forKey:@"status"];
    if (picData.length) {
        [params setObject:picData forKey:@"pic"];
    }
    WeiboRequestOperation *operation =
    [[WeiboRequest shared] postToPath:path
                               params:params
                            completed:^(id result, NSData *data, NSError *error) {
                                 if (error) {
                                     completedBlock(nil, error);
                                 }
                                 else {
                                     Status *status = nil;
                                     if ([result isKindOfClass:[NSDictionary class]]) {
                                         @try {
                                             status = [[Status alloc] initWithJsonDictionary:result];
                                         }
                                         @catch (NSException *exception) {
                                             NSLog(@"newStatus exception: %@", exception);
                                         }
                                         @finally {
                                             
                                         }
                                     }
                                     if (status) {
                                         completedBlock(status, nil);
                                     }
                                     else {
                                         NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                         NSString *msg = [NSString stringWithFormat:@"Failed to parse responsed object. responseString: %@", responseString];
                                         
                                         completedBlock(nil, [NSError errorWithDomain:WeiboErrorDomain code:kJsonParseTimelineErrorCode userInfo:@{NSLocalizedDescriptionKey: msg}]);
                                     }
                                 }
                                 
                                 
                             }];
    return operation;
    
    
}


@end
