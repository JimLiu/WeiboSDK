//
//  ImageDownloadReceiver.h
//  iPlus
//
//  Created by junmin liu on 11-7-26.
//  Copyright 2011年 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageDownloadReceiver : NSObject {
	int failedCount;
	float progress;
	float max;
    void (^_completionBlock)(NSData *imageData, NSString *url, NSError *error);
    void (^_progressBlock)(float totalSize, float totalBytesRead);
}

@property (copy) void (^completionBlock)(NSData *imageData, NSString *url, NSError *error);
@property (copy) void (^progressBlock)(float totalSize, float totalBytesRead);
@property (nonatomic, assign) CGRect displayRect;
@property (nonatomic, assign) int failedCount; 


- (id)init;

@end
