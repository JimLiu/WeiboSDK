//
//  TweetImageNode.h
//  TweetViewDemo
//
//  Created by junmin liu on 10-10-14.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TweetImageBaseNode.h"

/*-(UIImage *)imageWithShadow:(UIImage *)_image 
 shadowSize:(CGFloat)_shadowSize
 blur:(CGFloat)_blur 
 shadowColor:(UIColor*)_shadowColor;*/

@interface TweetImageNode : TweetImageBaseNode {
	NSString* _imageUrl;
	UIImage*  _defaultImage;
}

@property (nonatomic, retain) NSString* imageUrl;
@property (nonatomic, retain) UIImage*  defaultImage;

- (id)initWithImageUrl:(NSString*)imageUrl layout:(TweetLayout*)_layout;

- (id)initWithImageUrl:(NSString*)imageUrl cacheName:(NSString *)_cacheName layout:(TweetLayout*)_layout;

@end
