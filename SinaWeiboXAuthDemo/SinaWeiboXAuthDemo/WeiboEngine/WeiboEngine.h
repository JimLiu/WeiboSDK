//
//  WeiboEngine.h
//  SinaWeiboXAuthDemo
//
//  Created by junmin liu on 11-5-26.
//  Copyright 2011年 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuth.h"
#import "User.h"

@interface WeiboEngine : NSObject {
    OAuth *_oAuth;
    User *_user;
    BOOL isAuthorized;
}

@property (nonatomic, retain) OAuth *oAuth;
@property (nonatomic, retain) User *user;
@property (nonatomic, readonly) BOOL isAuthorized;

+ (WeiboEngine *)engine;

@end
