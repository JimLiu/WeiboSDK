//
//  EmoticonsPopupView.h
//  ZhiWeibo
//
//  Created by junmin liu on 11-1-14.
//  Copyright 2011 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EmoticonsScrollView.h"
#import "EmojiDataSource.h"
#import "EmoticonDataSource.h"
#import "EmoticonsToolbarView.h"


typedef enum {
	EmoticonsTypeEmoji,
	EmoticonsTypeSinaWeibo,
} EmoticonsType;


@interface EmoticonsPopupView : UIView<UIScrollViewDelegate, EmoticonsToolbarViewDelegate> {
	EmoticonsScrollView *emoticonsScrollView;
	EmoticonsToolbarView *emoticonsToolbarView;
	EmoticonsType currentEmoticonsType;
	int currentEmoticonsIndex;
}

- (void)setEmoticonNodes:(int)index;

@end
