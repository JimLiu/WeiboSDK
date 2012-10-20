//
//  Fonts.m
//  WeiboPlus
//
//  Created by junmin liu on 12-10-14.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "Fonts.h"

@implementation Fonts

+ (UIFont *)defaultFont {
    static UIFont *font = nil;
    if (!font) {
        font = [[UIFont fontWithName:@"Georgia" size:13] retain];
    }
    return font;
}


+ (UIFont *)statusTimeFont {
    static UIFont *font = nil;
    if (!font) {
        font = [[UIFont systemFontOfSize:11] retain];
    }
    return font;
}

@end
