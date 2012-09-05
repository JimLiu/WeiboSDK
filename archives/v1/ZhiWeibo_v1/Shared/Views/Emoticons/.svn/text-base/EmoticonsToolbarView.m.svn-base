//
//  EmoticonToolbar.m
//  ZhiWeibo
//
//  Created by junmin liu on 11-1-23.
//  Copyright 2011 Openlab. All rights reserved.
//

#import "EmoticonsToolbarView.h"


@implementation EmoticonsToolbarView
@synthesize toolbarDelegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		changeEmoticonsButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 41, 54)];
		recentEmoticonsButton = [[UIButton alloc]initWithFrame:CGRectMake(39, 0, 41, 54)];
		recentEmoticonsButton.tag = 0;
		emoticons1Button = [[UIButton alloc]initWithFrame:CGRectMake(79, 0, 41, 54)];
		emoticons1Button.tag = 1;
		emoticons2Button = [[UIButton alloc]initWithFrame:CGRectMake(119, 0, 41, 54)];
		emoticons2Button.tag = 2;
		emoticons3Button = [[UIButton alloc]initWithFrame:CGRectMake(159, 0, 41, 54)];
		emoticons3Button.tag = 3;
		emoticons4Button = [[UIButton alloc]initWithFrame:CGRectMake(199, 0, 41, 54)];
		emoticons4Button.tag = 4;
		emoticons5Button = [[UIButton alloc]initWithFrame:CGRectMake(239, 0, 41, 54)];
		emoticons5Button.tag = 5;
		deleteCharButton = [[UIButton alloc]initWithFrame:CGRectMake(279, 0, 41, 54)];
		
		[self addSubview:recentEmoticonsButton];
		[self addSubview:emoticons1Button];
		[self addSubview:emoticons2Button];
		[self addSubview:emoticons3Button];
		[self addSubview:emoticons4Button];
		[self addSubview:emoticons5Button];
		[self addSubview:changeEmoticonsButton];
		[self addSubview:deleteCharButton];
		[changeEmoticonsButton addTarget:self
							action:@selector(changeEmoticonsButtonTouch:)
				  forControlEvents:UIControlEventTouchUpInside];	
		[deleteCharButton addTarget:self
								  action:@selector(deleteCharButtonTouch:)
						forControlEvents:UIControlEventTouchUpInside];	
		[recentEmoticonsButton addTarget:self
								  action:@selector(emoticonsCategoryButtonTouch:)
						forControlEvents:UIControlEventTouchDown];	
		[emoticons1Button addTarget:self
								  action:@selector(emoticonsCategoryButtonTouch:)
						forControlEvents:UIControlEventTouchDown];	
		[emoticons2Button addTarget:self
								  action:@selector(emoticonsCategoryButtonTouch:)
						forControlEvents:UIControlEventTouchDown];	
		[emoticons3Button addTarget:self
								  action:@selector(emoticonsCategoryButtonTouch:)
						forControlEvents:UIControlEventTouchDown];	
		[emoticons4Button addTarget:self
								  action:@selector(emoticonsCategoryButtonTouch:)
						forControlEvents:UIControlEventTouchDown];	
		[emoticons5Button addTarget:self
								  action:@selector(emoticonsCategoryButtonTouch:)
						forControlEvents:UIControlEventTouchDown];	
		
		
		[changeEmoticonsButton setImage:[UIImage imageNamed:@"emoticon-kb-change.png"] forState:UIControlStateNormal];
		[changeEmoticonsButton setImage:[UIImage imageNamed:@"emoticon-kb-change-pressed.png"] forState:UIControlStateHighlighted];
		[deleteCharButton setImage:[UIImage imageNamed:@"emoticon-kb-close.png"] forState:UIControlStateNormal];
		[deleteCharButton setImage:[UIImage imageNamed:@"emoticon-kb-close-pressed.png"] forState:UIControlStateHighlighted];
		[recentEmoticonsButton setImage:[UIImage imageNamed:@"emoticon-kb-type1.png"] forState:UIControlStateNormal];
		[recentEmoticonsButton setImage:[UIImage imageNamed:@"emoticon-kb-type1-selected.png"] forState:UIControlStateSelected];
		[recentEmoticonsButton setImage:[UIImage imageNamed:@"emoticon-kb-type1-selected.png"] forState:UIControlStateHighlighted];
		[emoticons1Button setImage:[UIImage imageNamed:@"emoticon-kb-type2.png"] forState:UIControlStateNormal];
		[emoticons1Button setImage:[UIImage imageNamed:@"emoticon-kb-type2-selected.png"] forState:UIControlStateSelected];
		[emoticons1Button setImage:[UIImage imageNamed:@"emoticon-kb-type2-selected.png"] forState:UIControlStateHighlighted];
		[emoticons2Button setImage:[UIImage imageNamed:@"emoticon-kb-type3.png"] forState:UIControlStateNormal];
		[emoticons2Button setImage:[UIImage imageNamed:@"emoticon-kb-type3-selected.png"] forState:UIControlStateSelected];
		[emoticons2Button setImage:[UIImage imageNamed:@"emoticon-kb-type3-selected.png"] forState:UIControlStateHighlighted];
		[emoticons3Button setImage:[UIImage imageNamed:@"emoticon-kb-type4.png"] forState:UIControlStateNormal];
		[emoticons3Button setImage:[UIImage imageNamed:@"emoticon-kb-type4-selected.png"] forState:UIControlStateSelected];
		[emoticons3Button setImage:[UIImage imageNamed:@"emoticon-kb-type4-selected.png"] forState:UIControlStateHighlighted];
		[emoticons4Button setImage:[UIImage imageNamed:@"emoticon-kb-type5.png"] forState:UIControlStateNormal];
		[emoticons4Button setImage:[UIImage imageNamed:@"emoticon-kb-type5-selected.png"] forState:UIControlStateSelected];
		[emoticons4Button setImage:[UIImage imageNamed:@"emoticon-kb-type5-selected.png"] forState:UIControlStateHighlighted];
		[emoticons5Button setImage:[UIImage imageNamed:@"emoticon-kb-type6.png"] forState:UIControlStateNormal];
		[emoticons5Button setImage:[UIImage imageNamed:@"emoticon-kb-type6-selected.png"] forState:UIControlStateSelected];
		[emoticons5Button setImage:[UIImage imageNamed:@"emoticon-kb-type6-selected.png"] forState:UIControlStateHighlighted];
		
		buttons = [[NSMutableArray alloc]init];
		[buttons addObject:recentEmoticonsButton];
		[buttons addObject:emoticons1Button];
		[buttons addObject:emoticons2Button];
		[buttons addObject:emoticons3Button];
		[buttons addObject:emoticons4Button];
		[buttons addObject:emoticons5Button];
		
		currentCategoryIndex = 1;
		emoticons1Button.selected = YES;
	}
    return self;
}

- (void)changeEmoticonsButtonTouch:(id)sender {
	if (toolbarDelegate) {
		[toolbarDelegate changeEmoticonsType];
	}
}

- (void)deleteCharButtonTouch:(id)sender {
	if (toolbarDelegate) {
		[toolbarDelegate deleteChar];
	}
}

- (void)emoticonsCategoryButtonTouch:(id)sender {
	UIButton *button = (UIButton *)sender;
	if (button) {
		if (button.tag != currentCategoryIndex) {
			UIButton *currentSelectedButton = [buttons objectAtIndex:currentCategoryIndex];
			currentSelectedButton.selected = NO;
			currentCategoryIndex = button.tag;
			currentSelectedButton = [buttons objectAtIndex:currentCategoryIndex];
			currentSelectedButton.selected = YES;
			if (toolbarDelegate) {
				[toolbarDelegate emoticonsCategoryChanged:button.tag];
			}
		}
	}
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	[recentEmoticonsButton release];
	[changeEmoticonsButton release];
	[deleteCharButton release];
	[emoticons1Button release];
	[emoticons2Button release];
	[emoticons3Button release];
	[emoticons4Button release];
	[emoticons5Button release];
	[buttons release];
    [super dealloc];
}


@end
