//
//  ColorUtils.m
//  TwitterFon
//
//  Created by kaz on 7/21/08.
//  Copyright 2008 naan studio. All rights reserved.
//

#import "ColorUtils.h"

static UIColor *gNavigationBarColors[5];
static UIColor *gUnreadCellColors[5];

@implementation UIColor (UIColorUtils)

+ (void) initTwitterFonColorScheme
{
    gUnreadCellColors[0] = [[UIColor colorWithRed:0.827 green:1.000 blue:1.000 alpha:1.0] retain]; // friends
    gUnreadCellColors[1] = [[UIColor colorWithRed:0.827 green:1.000 blue:0.820 alpha:1.0] retain]; // replies
    gUnreadCellColors[2] = [[UIColor colorWithRed:0.992 green:0.878 blue:0.820 alpha:1.0] retain]; // DM
    gUnreadCellColors[3] = [[UIColor colorWithRed:0.988 green:0.812 blue:0.820 alpha:1.0] retain]; // favorites
    gUnreadCellColors[4] = [[UIColor colorWithRed:0.996 green:0.929 blue:0.820 alpha:1.0] retain]; // search
    
    // Navigation Bar Color
    gNavigationBarColors[0] = [[UIColor colorWithRed:0.341 green:0.643 blue:0.859 alpha:1.0] retain];
    gNavigationBarColors[1] = [[UIColor colorWithRed:0.459 green:0.663 blue:0.557 alpha:1.0] retain];
    gNavigationBarColors[2] = [[UIColor colorWithRed:0.686 green:0.502 blue:0.447 alpha:1.0] retain];
    gNavigationBarColors[3] = [[UIColor colorWithRed:0.701 green:0.447 blue:0.459 alpha:1.0] retain];
    gNavigationBarColors[4] = [UIColor whiteColor];
    
}

+ (UIColor*)navigationColorForTab:(int)tab
{
    return gNavigationBarColors[tab];
}

+ (UIColor*)cellColorForTab:(int)tab
{
    return gUnreadCellColors[tab];
}

+ (UIColor*)cellLabelColor
{
    return [UIColor colorWithRed:0.195 green:0.309 blue:0.520 alpha:1.0];
}

+ (UIColor*)conversationBackground
{
    return [UIColor colorWithRed:0.859 green:0.886 blue:0.929 alpha:1.0];
}
@end
