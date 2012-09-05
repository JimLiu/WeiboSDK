//
//  EmoticonsScrollView.m
//  ZhiWeibo
//
//  Created by junmin liu on 11-1-15.
//  Copyright 2011 Openlab. All rights reserved.
//

#import "EmoticonsScrollView.h"

@interface EmoticonsScrollView (PrivateMethods)


- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;


@end

@implementation EmoticonsScrollView
@synthesize emoticonNodes;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		emoticonsPerRow = 7;
		emoticonsPerPage = emoticonsPerRow * 3;
		
		emoticonsViews = [[NSMutableArray array] retain];
		
		self.backgroundColor = [UIColor clearColor];
		scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, 320, 300)];
		scrollView.pagingEnabled = YES;
		scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
		scrollView.showsHorizontalScrollIndicator = NO;
		scrollView.showsVerticalScrollIndicator = NO;
		scrollView.delegate = self;
		scrollView.backgroundColor = [UIColor clearColor];
		
		pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
		pageControl.currentPage = 0;
		pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
		pageControl.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		
		[self addSubview:scrollView];
		[self addSubview:pageControl];
		
    }
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect frame = self.frame;
	CGSize pageControlSize = [pageControl sizeForNumberOfPages:pageControl.numberOfPages];
	pageControl.frame = CGRectMake((frame.size.width - pageControlSize.width) / 2, 0, pageControlSize.width, 20);
}

- (void)setEmoticonNodes:(NSMutableArray *)_emoticonNodes {
	
	if (emoticonNodes != _emoticonNodes) {
		[emoticonNodes release];
		emoticonNodes = [_emoticonNodes retain];
		
		kNumberOfPages = emoticonNodes.count % emoticonsPerPage == 0 ?
		emoticonNodes.count / emoticonsPerPage : emoticonNodes.count / emoticonsPerPage + 1;
		pageControl.numberOfPages = kNumberOfPages;
		[scrollView setContentOffset:CGPointMake(0, 0)];
		scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
		[self setNeedsLayout];

		
		for (EmoticonsView *view in emoticonsViews) {
			if ((NSNull *)view != [NSNull null]) {
				[view removeFromSuperview];
			}
		}
		
		[emoticonsViews removeAllObjects];
		for (unsigned i = 0; i < kNumberOfPages; i++) {
			[emoticonsViews addObject:[NSNull null]];
		}
		[self loadScrollViewWithPage:0];
		//[self loadScrollViewWithPage:1];
	}
	
}

- (void)dealloc {
	[emoticonNodes release];
    [emoticonsViews release];
    [scrollView release];
    [pageControl release];
    [super dealloc];
}


- (NSMutableArray *)getEmoticons:(int)page {
	int count = emoticonsPerPage * (page + 1)  < emoticonNodes.count ? emoticonsPerPage : emoticonNodes.count - emoticonsPerPage * page;
	count = count < 0 ? 0 : count;
	NSArray *pageEmoticonNodes = [emoticonNodes subarrayWithRange:NSMakeRange(emoticonsPerPage * page, count)];
	NSMutableArray *emoticons = [NSMutableArray array];
	int size = 45;
	int i = 0;
	for (EmoticonNode *node in pageEmoticonNodes) {
		node.bounds = CGRectMake(size * i % emoticonsPerRow, size * i / emoticonsPerRow, size, size);
		[emoticons addObject:node];
		i++;
	}
	return emoticons;
}

- (void)loadScrollViewWithPage:(int)page {
    if (page < 0) return;
    if (page >= kNumberOfPages) return;
	
    // replace the placeholder if necessary
    EmoticonsView *view = [emoticonsViews objectAtIndex:page];
    if ((NSNull *)view == [NSNull null]) {
        view = [[EmoticonsView alloc] initWithFrame:CGRectZero];
		view.emoticonNodes = [self getEmoticons:page];
        [emoticonsViews replaceObjectAtIndex:page withObject:view];
        [view release];
    }
	if (!currentEmoticonsView) {
		currentEmoticonsView = view;
	}
	
    // add the controller's view to the scroll view
    if (nil == view.superview) {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        view.frame = frame;
        [scrollView addSubview:view];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if (pageControlUsed) {
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	if (page < 0) {
		page = 0;
	}
	if (page >= kNumberOfPages) {
		page = kNumberOfPages - 1;
	}
    pageControl.currentPage = page;
	EmoticonsView *view = [emoticonsViews objectAtIndex:page];
    if ((NSNull *)view != [NSNull null]) {
		currentEmoticonsView = view;
	}
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    //[self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    //[self loadScrollViewWithPage:page + 1];
	
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender {
    int page = pageControl.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    //[self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    //[self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}


@end
