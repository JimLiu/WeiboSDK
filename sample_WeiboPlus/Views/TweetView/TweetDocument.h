//
//  TweetDocument.h
//  TweetLayerDemo
//
//  Created by junmin liu on 12-10-17.
//  Copyright (c) 2012年 openlab Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>
#import "TweetLink.h"

@interface TweetDocument : NSObject {
    NSMutableArray *_links;
	UIFont *_font;
    
    UIColor *_textColor;
    UIColor *_linkColor;
    UIColor *_linkPrefixColor;
	UIColor *_activeLinkColor;
    UIColor *_activeLinkBackgroundColor;
    CGFloat _activeLinkBackgroundCornerRadius;
    
    NSAttributedString *_attributedText;
    
    NSString *_tweet;
    
    CTFramesetterRef _framesetter;
    BOOL _needsFramesetter;
}

@property (nonatomic, copy) NSString *tweet;
@property (nonatomic, retain) UIFont *font;

@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, retain) UIColor *linkColor;
@property (nonatomic, retain) UIColor *linkPrefixColor;
@property (nonatomic, retain) UIColor *activeLinkColor;
@property (nonatomic, retain) UIColor *activeLinkBackgroundColor;
@property (nonatomic, assign) CGFloat activeLinkBackgroundCornerRadius;

@property (nonatomic, readonly) NSMutableArray *links;
@property (nonatomic, readonly) NSAttributedString *attributedText;

@property (readwrite, nonatomic, assign) CTFramesetterRef framesetter;

- (id)initWithTweet:(NSString *)tweet;
+ (TweetDocument *)documentWithTweet:(NSString *)tweet;

- (void)addTweetLink:(TweetLink *)link;
//- (void)setNeedsFramesetter;
- (CGRect)textRectForBounds:(CGRect)bounds;
- (CGSize)textSizeForWidth:(CGFloat)width;

- (void)setNeedsFramesetter;

- (NSMutableArray *)getLinkRects:(TweetLink *)link bounds:(CGRect)bounds;

- (void)drawTextInRect:(CGRect)rect textRect:(CGRect)textRect context:(CGContextRef)c;

@end
