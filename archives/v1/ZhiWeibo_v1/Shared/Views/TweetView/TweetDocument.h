//
//  TweetDocument.h
//  TweetViewDemo
//
//  Created by junmin liu on 10-10-14.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TweetNode.h"
#import "TweetLinkNode.h"
#import "TweetTextNode.h"
#import "TweetImageLinkNode.h"
#import "TweetFrame.h"
#import "TweetLayout.h"
#import "EmoticonDataSource.h"
#import "Emoticon.h"
#import "TweetAnimationImageNode.h"

@interface TweetDocument : NSObject {
	NSMutableArray *layouts;
	BOOL highlighted;
	
	UIView *view;
	BOOL needsLayout;
	BOOL needsDisplay;
	
	CGFloat _width;
	CGFloat _height;
	
	UIColor *textColor; //black
	UIColor *linkTextColor; //#696969
}

@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, retain) UIColor *linkTextColor;
@property (nonatomic, readonly) CGFloat width;
@property (nonatomic, readonly) CGFloat height;
@property (nonatomic, assign) UIView *view;
@property (nonatomic, assign) BOOL highlighted;

- (id)init;

- (void)setNeedsLayout;

- (void)setNeedsDisplay;

- (void)setNeedsDisplayInRect:(CGRect)rect;

- (NSMutableArray *)parseStatus:(NSString *)string layout:(TweetLayout*)_layout;

- (void)addLayout:(TweetLayout *)layout;

- (TweetLayout *)addLayoutForText:(NSString *)status frame:(CGRect)rect;

- (TweetLayout *)addLayoutForStatus:(NSString *)status frame:(CGRect)rect;

- (TweetLayout *)addLayoutForImageUrl:(NSString *)url 
						   imageWidth:(CGFloat)width 
						  imageHeight:(CGFloat)height
							   frame:(CGRect)rect;

- (TweetFrame*)hitTest:(CGPoint)point;
- (void)performStep:(int)step;
- (void)drawAtPoint:(CGPoint)point;

@end
