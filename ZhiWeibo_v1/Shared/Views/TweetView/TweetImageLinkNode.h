//
//  TweetImageLinkNode.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-3.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TweetImageNode.h"

@interface TweetImageLinkNode : TweetImageNode {
	NSString *url;
}

@property (nonatomic, copy) NSString *url;

- (id)initWithUrl:(NSString *)_url imageUrl:(NSString *)_imageUrl layout:(TweetLayout*)_layout;

+ (TweetImageLinkNode *)withUrl:(NSString *)_url imageUrl:(NSString *)_imageUrl layout:(TweetLayout*)_layout;

@end
