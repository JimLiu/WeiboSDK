//
//  StatusCache.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-10-18.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Status.h"

@interface StatusCache : NSObject {

}

+ (void)cache:(Status*)_status;

+ (Status *)get:(NSNumber*)_statusKey;

/*
 + (NSMutableArray *)getStatusIdsByRetweet:(NSNumber *)_statusKey;
 */

+ (void)remove:(NSNumber*)_statusKey;

+ (void)removeAll;

+ (void)cache:(Status*)_status;

+ (Status *)get:(NSNumber*)_statusKey;

/*
+ (NSMutableArray *)getStatusIdsByRetweet:(NSNumber *)_statusKey;
 */

+ (void)remove:(NSNumber*)_statusKey;

+ (void)removeAll;

+ (NSString*)storagePathWithName:(NSString*)name;


+ (NSMutableArray *)loadStatusWithFilePath:(NSString *)filePath;

+ (void)storageStatuses:(NSArray *)statuses 
			   filePath:(NSString *)filePath;

@end
