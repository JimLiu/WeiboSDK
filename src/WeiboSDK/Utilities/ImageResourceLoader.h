//
//  ImageResourceLoader.h
//  WeiboSDK
//
//  Created by Liu Jim on 8/4/13.
//  Copyright (c) 2013 openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageResourceLoader : NSObject

+ (UIImage*) imageFromBytes:(const Byte *)bytes
                     length:(NSUInteger)length
            fromRetinaBytes:(const Byte *)retinaBytes
               retinaLength:(NSUInteger)retinaLength;

@end
