//
//  Province.h
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-8-31.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Province : NSObject<NSCoding> {
	NSString *_name;
	NSString *_provinceId;
	NSMutableDictionary *_cities;
}

- (id)initWithDictionary:(NSDictionary *)dict;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) NSString *provinceId;
@property (nonatomic, retain) NSMutableDictionary *cities;

@end
