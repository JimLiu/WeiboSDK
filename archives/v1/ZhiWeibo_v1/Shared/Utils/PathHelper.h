//
//  PathHelper.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-5.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PathHelper : NSObject {

}

+ (BOOL)createPathIfNecessary:(NSString*)path;

+ (NSString*)documentDirectoryPathWithName:(NSString*)name;

+ (NSString*)cacheDirectoryPathWithName:(NSString*)name;

@end
