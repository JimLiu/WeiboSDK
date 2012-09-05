//
//  UIColorAdditions.h
//  Weibo
//
//  Created by junmin liu on 10-9-30.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface UIColor (Category)

/**
 * Accepted ranges:
 *        hue: 0.0 - 360.0
 * saturation: 0.0 - 1.0
 *      value: 0.0 - 1.0
 *      alpha: 0.0 - 1.0
 */
+ (UIColor*)colorWithHue:(CGFloat)h saturation:(CGFloat)s value:(CGFloat)v alpha:(CGFloat)a;

/**
 * Accepted ranges:
 *        hue: 0.0 - 1.0
 * saturation: 0.0 - 1.0
 *      value: 0.0 - 1.0
 */
- (UIColor*)multiplyHue:(CGFloat)hd saturation:(CGFloat)sd value:(CGFloat)vd;

- (UIColor*)addHue:(CGFloat)hd saturation:(CGFloat)sd value:(CGFloat)vd;

/**
 * Returns a new UIColor with the given alpha.
 */
- (UIColor*)copyWithAlpha:(CGFloat)newAlpha;

/**
 * Uses multiplyHue:saturation:value:alpha: to create a lighter version of the color.
 */
- (UIColor*)highlight;

/**
 * Uses multiplyHue:saturation:value:alpha: to create a darker version of the color.
 */
- (UIColor*)shadow;

- (CGFloat)hue;

- (CGFloat)saturation;

- (CGFloat)value;

@end
