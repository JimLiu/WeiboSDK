//
//  User.h
//  helloWeibo
//
//  Created by junmin liu on 11-4-13.
//  Copyright 2011年 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface User : NSObject {
 	long long   _userId; //用户UID
	NSString*   _screenName; //微博昵称
	NSString*   _profileImageUrl; //自定义图像   
}

@property (nonatomic, assign) long long  userId;
@property (nonatomic, retain) NSString* screenName;
@property (nonatomic, retain) NSString* profileImageUrl;

- (id)initWithJsonDictionary:(NSDictionary*)dic;

+ (User*)userWithJsonDictionary:(NSDictionary*)dic;

@end
