//
//  EmoticonDataSource.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-10-18.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouchXML.h"
#import "Emoticon.h"
#import "GlobalCore.h"
#import "GifEmoticonNode.h"
#import "WeiboEngine.h"

@interface EmoticonDataSource : NSObject {

}

+ (NSMutableDictionary *)emoticonTypes;

+ (NSMutableArray *)emoticons;

+ (NSMutableDictionary *)emoticonNodes;

+ (void)insertEmoticon:(NSString *)_phrase
			  filename:(NSString *)_filename
				  type:(NSString *)_type
				 width:(int)_width
				height:(int)_height
	 defaultFrameIndex:(int)_defaultFrameIndex
				delays:(NSArray*)_delays;

+ (void)insertEmoticons;

+ (NSMutableArray *)getEmoticonNodes:(NSString *)_type;

+ (NSMutableArray *)loadRecentEmoticonNodes;

+ (void)addRecentEmoticonNodes:(GifEmoticonNode *)node;

@end
