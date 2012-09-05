//
//  TweetNode.h
//  TweetViewDemo
//
//  Created by junmin liu on 10-10-13.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TweetStyle.h"

@class TweetLayout;


typedef enum {
	LayoutHorizontalAlignLeft,
	LayoutHorizontalAlignCenter,
	LayoutHorizontalAlignRight
} LayoutHorizontalAlign;

typedef enum {
	LayoutVerticalAlignBottom,
	LayoutVerticalAlignTop,
	LayoutVerticalAlignMiddle
} LayoutVerticalAlign;

typedef enum {
    TweetNodeStateNormal,                       
    TweetNodeStateHighlighted,                  // used when UIControl isHighlighted is set
    TweetNodeStateDisabled,
    TweetNodeStateSelected               // flags reserved for internal framework use
} TweetNodeState;

@interface TweetNode : NSObject {
	TweetNode* nextSibling;
	TweetLayout* layout;
	LayoutVerticalAlign verticalAlign;
	TweetNodeState state;
	UIEdgeInsets _margin;
	NSString* _className;
	BOOL highlighted;
	BOOL hideOnHighlighted;
	BOOL selectable;
}

@property (nonatomic, assign) TweetLayout* layout;
@property (nonatomic, assign) LayoutVerticalAlign verticalAlign;
@property (nonatomic, assign)   TweetNode* nextSibling;
@property (nonatomic)         UIEdgeInsets   margin;
@property (nonatomic, copy) NSString* className;
@property (nonatomic, assign) TweetNodeState state;
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, assign) BOOL hideOnHighlighted;
@property (nonatomic, assign) BOOL selectable;

- (id)initWithLayout:(TweetLayout*)_layout;
- (void)setNeedsDisplay;
- (NSString *)html;

@end
