//
//  TweetLayout.h
//  TweetViewDemo
//
//  Created by junmin liu on 10-10-13.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TweetNode.h"
#import "TweetLinkNode.h"
#import "TweetTextNode.h"
#import "TweetImageBaseNode.h"
#import "TweetImageFrame.h"
#import "TweetImageLinkNode.h"
#import "TweetImageLinkFrame.h"
#import "TweetLinkFrame.h"
#import "TweetTextFrame.h"
#import "TweetAnimationImageNode.h"
#import "TweetAnimationImageFrame.h"


@class TweetDocument;

@interface TweetLayout : NSObject {
	TweetNode* _rootNode;
	TweetNode* _lastNode;
	
	TweetDocument* doc;
	BOOL highlighted;

	BOOL needsLayout;
	BOOL needsDisplay;
	CGRect _frame;
	LayoutHorizontalAlign horizontalAlign;
	LayoutVerticalAlign verticalAlign;
	UIEdgeInsets _margin;
	
	NSMutableArray *_nodes;
	NSMutableArray *_frames;
	
	NSMutableArray *_lineFrames;
	
	CGFloat _width;
	CGFloat _height;
	CGFloat _actualWidth;
	CGFloat _currentHeight;
	
	CGFloat _x;
	CGFloat _lineWidth;
	CGFloat _lineHeight;
	
	UIFont *font;
	UIFont *linkFont;
	UIColor *textColor; //#070707
	UIColor *linkTextColor; //696969
	UIColor *highlightedTextColor;//white
}

- (id)initWithFrame:(CGRect)frame doc:(TweetDocument *)_doc;

- (void)addNode:(TweetNode *)_node;

- (void)reset;

@property (nonatomic, assign) CGRect frame;
@property (nonatomic, readonly) CGFloat actualWidth;
@property (nonatomic)         UIEdgeInsets   margin;
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, assign) LayoutHorizontalAlign horizontalAlign;
@property (nonatomic, assign) LayoutVerticalAlign verticalAlign;
@property (nonatomic, retain, readonly) NSMutableArray *nodes;
@property (nonatomic, retain, readonly) NSMutableArray *frames;
@property (nonatomic, retain) UIFont *font;
@property (nonatomic, retain) UIFont *linkFont;
@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, retain) UIColor *linkTextColor;
@property (nonatomic, retain) UIColor *highlightedTextColor;

- (TweetTextNode *)addNodeForText:(NSString *)text;

- (TweetLinkNode *)addNodeForLink:(NSString *)text_ url:(NSString *)url_;

- (TweetImageNode *)addNodeForImageUrl:(NSString *)url
								 width:(CGFloat)width 
								height:(CGFloat)height;

- (TweetImageLinkNode *)addNodeForImageLink:(NSString *)url
								   imageUrl:(NSString *)imageUrl 
									  width:(CGFloat)width 
									 height:(CGFloat)height;

- (void)setNeedsLayout;
- (void)setNeedsDisplay;
- (void)setNeedsDisplayInRect:(CGRect)rect;
- (void)layout;
- (void)performStep:(int)step;
- (void)draw;
- (TweetFrame*)hitTest:(CGPoint)point;

- (NSString *)html;

@end
