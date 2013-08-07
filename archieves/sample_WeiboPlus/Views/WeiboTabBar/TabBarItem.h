//
//  TabBarItem.h
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-9-2.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Images.h"

@interface TabBarItem : UIButton {
    BOOL _isGlowed;
    UIImageView *_glowImageView;
    UIImage *_selectedImage;
    UIImage *_unselectedImage;
}

@property (nonatomic, assign, getter=isGlowed) BOOL isGlowed;

- (void)setFinishedSelectedImage:(UIImage *)selectedImage withFinishedUnselectedImage:(UIImage *)unselectedImage;

- (void)setTitle:(NSString *)title;

@end
