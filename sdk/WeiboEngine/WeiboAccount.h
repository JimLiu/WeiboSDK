//
//  WeiboAccount.h
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-8-20.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiboAccount : NSObject {
    NSString *_userId;
    NSString *_accessToken;
    NSDate *_expirationDate;
    NSString *_screenName;
    NSString *_profileImageUrl;
    BOOL _selected;
}

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, retain) NSDate *expirationDate;
@property (nonatomic, copy) NSString *screenName;
@property (nonatomic, copy) NSString *profileImageUrl;
@property (nonatomic, assign) BOOL selected;

@end
