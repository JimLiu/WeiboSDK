/*
 * Copyright 2010-present Facebook.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//
//  ImageResourceLoader.m
//  WeiboSDK
//
//  Created by Liu Jim on 8/4/13.
//  Copyright (c) 2013 openlab. All rights reserved.
//

#import "ImageResourceLoader.h"

@implementation ImageResourceLoader

+ (BOOL) isRetinaDisplay {
    // Check for displayLinkWithTarget:selector: since that is only available on iOS 4.0+
    // deal with edge case where scale returns 2.0 on a iPad running 3.2 with 2x
    // (which is not retina).
    static dispatch_once_t onceToken;
    static BOOL supportsRetina;
    
    dispatch_once(&onceToken, ^{
        supportsRetina = ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                          ([UIScreen mainScreen].scale == 2.0));
    });
    return supportsRetina;
}

+ (UIImage*) loadImageFromBytes:(const Byte*)bytes
                         length:(NSUInteger)length
                          scale:(CGFloat)scale {
    NSData *data = [NSData dataWithBytesNoCopy:(void*)bytes length:length freeWhenDone:NO];
    UIImage *image = [UIImage imageWithData:data scale:scale];
    return image;
}

+ (UIImage*) imageFromBytes:(const Byte *)bytes
                     length:(NSUInteger)length
            fromRetinaBytes:(const Byte *)retinaBytes
               retinaLength:(NSUInteger)retinaLength {
    if ([[self class] isRetinaDisplay]) {
        return [[self class] loadImageFromBytes:retinaBytes length:retinaLength scale:2.0];
    } else {
        return [[self class] loadImageFromBytes:bytes length:length scale:1.0];
    }
}

@end
