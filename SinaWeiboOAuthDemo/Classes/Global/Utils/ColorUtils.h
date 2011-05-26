//
//  ColorUtils.h
//  TwitterFon
//
//  Created by kaz on 7/21/08.
//  Copyright 2008 naan studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (UIColorUtils)
+ (void)initTwitterFonColorScheme;

+ (UIColor*)navigationColorForTab:(int)tab;
+ (UIColor*)cellColorForTab:(int)tab;
+ (UIColor*)cellLabelColor;
+ (UIColor*)conversationBackground;
@end