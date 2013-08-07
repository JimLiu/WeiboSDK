//
//  StatusImage.h
//  WeiboSDK
//
//  Created by Liu Jim on 8/3/13.
//  Copyright (c) 2013 openlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatusImage : NSObject<NSCoding>

- (id)initWithJsonDictionary:(NSDictionary*)dic;

@property (nonatomic, copy) NSString *middleImageUrl; //中等尺寸图片地址
@property (nonatomic, copy) NSString *originalImageUrl; //原始图片地址
@property (nonatomic, copy) NSString *thumbnailImageUrl; //缩略图片地址

@end
