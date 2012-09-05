//
//  EmoticonsScrollView.h
//  ZhiWeibo
//
//  Created by junmin liu on 11-1-15.
//  Copyright 2011 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EmoticonsView.h"


@interface EmoticonsScrollView : UIView<UIScrollViewDelegate> {
	UIScrollView *scrollView;
	UIPageControl *pageControl;
	NSMutableArray *emoticonsViews;
	NSMutableArray *emoticonNodes;
	int emoticonsPerPage;
	int emoticonsPerRow;
	int kNumberOfPages;
    // To be used when scrolls originate from the UIPageControl
    BOOL pageControlUsed;
	EmoticonsView *currentEmoticonsView;
}

@property (nonatomic, retain) NSMutableArray *emoticonNodes;

@end
