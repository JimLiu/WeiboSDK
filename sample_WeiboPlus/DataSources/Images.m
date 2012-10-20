//
//  Images.m
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-9-1.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "Images.h"

@implementation Images

+ (UIImage *)cellHighlightBackgroundImage {
    static UIImage *_cellHighlightBackgroundImage = nil;
    if (!_cellHighlightBackgroundImage) {
        _cellHighlightBackgroundImage = [[UIImage imageNamed:@"TableBlueSelectionGradient.png"]retain];
    }
    return _cellHighlightBackgroundImage;
}

+ (UIImage *)profilePlaceholderOverWhiteImage {
    static UIImage *profilePlaceholderImage = nil;
    if (!profilePlaceholderImage) {
        profilePlaceholderImage = [[UIImage imageNamed:@"ProfilePlaceholderOverWhite.png"]retain];
    }
    return profilePlaceholderImage;
}

+ (UIImage *)profilePlaceholderOverBlueImage {
    static UIImage *profilePlaceholderImage = nil;
    if (!profilePlaceholderImage) {
        profilePlaceholderImage = [[UIImage imageNamed:@"ProfilePlaceholderOverBlue.png"]retain];
    }
    return profilePlaceholderImage;
}

+ (UIImage *)checkImage {
    static UIImage *selectedImage = nil;
    if (!selectedImage) {
        selectedImage = [[UIImage imageNamed:@"ic_pop_check.png"]retain];
    }
    return selectedImage;
}

+ (UIImage *)selectedTabBarBackgroundImage {
    static UIImage *selectedTabBarBackgroundImage = nil;
    if (!selectedTabBarBackgroundImage) {
        selectedTabBarBackgroundImage = [[UIImage imageNamed:@"bg_tab_bar_selected.png"] retain];
    }
    return selectedTabBarBackgroundImage;
}

+ (UIImage *)tabBarBackgroundImage {
    static UIImage *tabBarBackgroundImage = nil;
    if (!tabBarBackgroundImage) {
        tabBarBackgroundImage = [[UIImage imageNamed:@"bg_tab_bar.png"] retain];
    }
    return tabBarBackgroundImage;
}

+ (UIImage *)glowImage {
    static UIImage *glowImage = nil;
    if (!glowImage) {
        glowImage = [[UIImage imageNamed:@"TabBarGlow.png"]retain];
    }
    return glowImage;
}

+ (UIImage *)textureBackgroundImage {
    static UIImage *image = nil;
    if (!image) {
        image = [[UIImage imageNamed:@"bg_texture.png"] retain];
    }
    return image;
}

+ (UIImage *)tweetInnerBackgroundImage {
    static UIImage *image = nil;
    if (!image) {
        image = [[[UIImage imageNamed:@"bg-tweet-inner.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:4] retain];
    }
    return image;
}

+ (UIImage *)tweetOuterBackgroundImage {
    static UIImage *image = nil;
    if (!image) {
        image = [[[UIImage imageNamed:@"bg-tweet-outer.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:10] retain];
    }
    return image;
}

@end
