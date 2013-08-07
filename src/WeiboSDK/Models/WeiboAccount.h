//
//  WeiboAccount.h
//  WeiboSDK
//
//  Created by Liu Jim on 8/3/13.
//  Copyright (c) 2013 openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboAuthentication.h"
#import "User.h"

// 登录帐号信息
@interface WeiboAccount : NSObject<NSCoding>

- (id)initWithAuthentication:(WeiboAuthentication *)auth
                        user:(User *)user;

@property (nonatomic, copy) NSString *userId; //用户Id
@property (nonatomic, copy) NSString *accessToken; //授权凭证
@property (nonatomic, strong) NSDate *expirationDate; //过期时间
@property (nonatomic, strong) User *user;
@property (nonatomic, assign) BOOL selected; //是否选中（当前用户）

@end
