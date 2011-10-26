//
//  EmojiDataSource.h
//  ZhiWeibo
//
//  Created by junmin liu on 11-1-12.
//  Copyright 2011 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EmojiNode.h"
#import "WeiboEngine.h"

@interface EmojiDataSource : NSObject {
	
}

+ (void)insertEmoji:(NSString *)_emoji phrase:(NSString *)_phrase forType:(NSString *)_type ;

+ (NSMutableDictionary *)emojies;

+ (NSMutableArray *)getEmojiNodes:(NSString *)_type;

+ (void)insertEmojies;

+ (NSMutableArray *)loadRecentEmojiNodes;

+ (void)addRecentEmojiNodes:(EmojiNode *)node;

@end
