//
//  TweetTextNode.h
//  TweetViewDemo
//
//  Created by junmin liu on 10-10-13.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TweetNode.h"

@interface TweetTextNode : TweetNode {
	NSString *text;
	UIColor *textColor;
	UIColor *highlightedTextColor;
	UIFont *font;
}

@property (nonatomic, copy) NSString *text;
@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, retain) UIColor *highlightedTextColor;
@property (nonatomic, retain) UIFont *font;

- (id)initWithText:(NSString *)_text layout:(TweetLayout*)_layout;

+(TweetTextNode *)withText:(NSString *)_text layout:(TweetLayout*)_layout;

@end
