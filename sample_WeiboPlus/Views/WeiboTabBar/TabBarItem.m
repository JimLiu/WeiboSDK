//
//  TabBarItem.m
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-9-2.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "TabBarItem.h"
#import "Images.h"

@implementation TabBarItem
@synthesize isGlowed = _isGlowed;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.adjustsImageWhenHighlighted = NO;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        [self setBackgroundImage:nil forState:UIControlStateNormal];
        [self setBackgroundImage:[Images selectedTabBarBackgroundImage] forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:10.0];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.contentMode = UIViewContentModeCenter;
        
        _glowImageView = [[UIImageView alloc]initWithImage:[Images glowImage]];
        [self addSubview:_glowImageView];
        [_glowImageView release];
        _glowImageView.hidden = YES;
    }
    return self;
}


//===========================================================
// dealloc
//===========================================================
- (void)dealloc
{    
    [super dealloc];
}

- (void)setHighlighted:(BOOL)highlighted {

}

- (void)setIsGlowed:(BOOL)isGlowed {
    if (_isGlowed != isGlowed) {
        _isGlowed = isGlowed;
    }
    _glowImageView.hidden = !_isGlowed;
}

- (void)setTitle:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
}


- (CGRect)contentRectForBounds:(CGRect)bounds {
    return bounds;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect frame = contentRect;
    frame.origin.y = contentRect.size.height - 16;
    frame.size.height = 14;
    return frame;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGSize size = _selectedImage ? _selectedImage.size : CGSizeMake(26, 26);
    CGRect frame = CGRectMake((contentRect.size.width - size.width) / 2, 4, size.width, size.height);
    return frame;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat height = 4;
    CGFloat width = 19;
    CGRect frame = CGRectMake((self.bounds.size.width - width) / 2, self.bounds.size.height - height, width, height);
    _glowImageView.frame = frame;
    
    
}

- (void)setFinishedSelectedImage:(UIImage *)selectedImage withFinishedUnselectedImage:(UIImage *)unselectedImage {
    [self setImage:selectedImage forState:UIControlStateSelected];
    [self setImage:unselectedImage forState:UIControlStateNormal];
    
    [_selectedImage release];
    _selectedImage = [selectedImage retain];
    [_unselectedImage release];
    _unselectedImage = [unselectedImage retain];

    [self setNeedsLayout];
    /*
    CGSize size = selectedImage.size;
    
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -size.width + 2, -24.0, 0)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(-12.0, 0.0, 0.0, -self.titleLabel.bounds.size.width)];
    
    //self.imageEdgeInsets = UIEdgeInsetsMake(top, left, top + size.height, left + size.width);
     */
}

@end
