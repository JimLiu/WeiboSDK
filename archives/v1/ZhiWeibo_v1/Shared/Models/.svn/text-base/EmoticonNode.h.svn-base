//
//  EmoticonNode.h
//  ZhiWeibo
//
//  Created by junmin liu on 11-1-14.
//  Copyright 2011 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EmoticonNode : NSObject {
	CGRect bounds;
	CGRect frame;
	UIView *view;
	BOOL isHighlighted;	
	NSString *phrase;
}

@property (nonatomic, assign) UIView *view;
@property (nonatomic, assign) CGRect bounds;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) BOOL isHighlighted;
@property (nonatomic, copy) NSString *phrase;

- (id)initWithCoder:(NSCoder *)decoder;

- (void)encodeWithCoder:(NSCoder *)encoder;

- (void)drawInRect:(CGRect)rect;

- (void)draw;

- (void)setPreviewImageView:(UIImageView *)previewImageView 
		 previewPhraseLabel:(UILabel *)previewPhraseLabel;

@end
