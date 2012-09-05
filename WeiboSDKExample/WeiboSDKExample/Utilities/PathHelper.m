//
//  PathHelper.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-5.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "PathHelper.h"


@implementation PathHelper


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL)createPathIfNecessary:(NSString*)path {
	BOOL succeeded = YES;
	
	NSFileManager* fm = [NSFileManager defaultManager];
	if (![fm fileExistsAtPath:path]) {
		succeeded = [fm createDirectoryAtPath: path
				  withIntermediateDirectories: YES
								   attributes: nil
										error: nil];
	}
	
	return succeeded;
}

+ (NSString*)bundlePathWithName:(NSString *)name {
    return [[[NSBundle mainBundle] resourcePath] 
     stringByAppendingPathComponent:name];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString*)documentDirectoryPathWithName:(NSString*)name {
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* cachesPath = [paths objectAtIndex:0];
	NSString* cachePath = [cachesPath stringByAppendingPathComponent:name];
	
	[PathHelper createPathIfNecessary:cachesPath];
	[PathHelper createPathIfNecessary:cachePath];
	
	return cachePath;
}

+ (NSString*)cacheDirectoryPathWithName:(NSString*)name {
    return [self cacheDirectoryPathWithName:name createPathIfNecessary:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString*)cacheDirectoryPathWithName:(NSString*)name createPathIfNecessary:(BOOL)createPathIfNecessary{
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString* cachesPath = [paths objectAtIndex:0];
	NSString* cachePath = [cachesPath stringByAppendingPathComponent:name];
	
    if (createPathIfNecessary) {
        [PathHelper createPathIfNecessary:cachesPath];
        [PathHelper createPathIfNecessary:cachePath];
    }
	
	return cachePath;
}

+ (NSString *)sanitizeFileNameString:(NSString *)fileName {
    NSCharacterSet* illegalFileNameCharacters = [NSCharacterSet characterSetWithCharactersInString:@"/\\?%*|\"<>"];
    return [[fileName componentsSeparatedByCharactersInSet:illegalFileNameCharacters] componentsJoinedByString:@""];
}
@end
