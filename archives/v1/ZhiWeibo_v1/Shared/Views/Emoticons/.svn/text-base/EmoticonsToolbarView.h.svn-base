//
//  EmoticonToolbar.h
//  ZhiWeibo
//
//  Created by junmin liu on 11-1-23.
//  Copyright 2011 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EmoticonsToolbarViewDelegate

- (void)changeEmoticonsType;

- (void)deleteChar;

- (void)emoticonsCategoryChanged:(int)index;

@end


@interface EmoticonsToolbarView : UIView {
	UIButton *changeEmoticonsButton;
	UIButton *recentEmoticonsButton;
	UIButton *emoticons1Button;
	UIButton *emoticons2Button;
	UIButton *emoticons3Button;
	UIButton *emoticons4Button;
	UIButton *emoticons5Button;
	UIButton *deleteCharButton;
	id<EmoticonsToolbarViewDelegate> toolbarDelegate;
	
	NSMutableArray *buttons;
	int currentCategoryIndex;
}

@property (nonatomic, assign) id<EmoticonsToolbarViewDelegate> toolbarDelegate;

@end
