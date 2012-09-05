//
//  TweetLinkNode.h
//  TweetViewDemo
//
//  Created by junmin liu on 10-10-13.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TweetTextNode.h"

@interface TweetLinkNode : TweetTextNode {
	NSString *url;
}

@property (nonatomic, copy) NSString *url;

- (id)initWithUrl:(NSString *)_url text:(NSString *)_text layout:(TweetLayout*)_layout;

+ (TweetLinkNode *)withUrl:(NSString *)_url layout:(TweetLayout*)_layout;

+ (TweetLinkNode *)withUrl:(NSString *)_url text:(NSString *)_text layout:(TweetLayout*)_layout;

@end
