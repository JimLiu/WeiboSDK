//
//  StatusCache.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-10-18.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "StatusCache.h"

static NSMutableDictionary *statusesDic = nil;
//static NSMutableDictionary *restatusToStatus = nil;

@implementation StatusCache


+ (void)cache:(Status*)_status {
	if (!statusesDic) {
		statusesDic = [[NSMutableDictionary alloc]init];
		//restatusToStatus = [[NSMutableDictionary alloc]init];
	}
	if (!_status) {
		return;
	}
	[statusesDic setObject:_status forKey:_status.statusKey];
	if (_status.retweetedStatus) {
		if ([statusesDic objectForKey:_status.retweetedStatus.statusKey] != nil) {
			_status.retweetedStatus = [statusesDic objectForKey:_status.retweetedStatus.statusKey];
		}
		else {
			[statusesDic setObject:_status.retweetedStatus forKey:_status.retweetedStatus.statusKey];
		}
		/*
		NSMutableArray *sids = [restatusToStatus objectForKey:_status.retweetedStatus.statusKey];
		if (sids == nil) {
			sids = [NSMutableArray array];
			[restatusToStatus setObject:sids forKey:_status.retweetedStatus.statusKey];
		}
		[sids addObject:_status.statusKey];
		 */
	}
}

+ (Status *)get:(NSNumber*)_statusKey {
	if (!statusesDic) {
		return nil;
	}
	return [statusesDic objectForKey:_statusKey];
}

/*
+ (NSMutableArray *)getStatusIdsByRetweet:(NSNumber *)_statusKey {
	if (!restatusToStatus) {
		return nil;
	}
	return (NSMutableArray *)[restatusToStatus objectForKey:_statusKey];
}
 */

+ (void)remove:(NSNumber*)_statusKey {
	if (!statusesDic) {
		return;
	}
	[statusesDic removeObjectForKey:_statusKey];
}

+ (void)removeAll {
	if (!statusesDic) {
		return;
	}
	[statusesDic removeAllObjects];	
}



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


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString*)storagePathWithName:(NSString*)name {
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* cachesPath = [paths objectAtIndex:0];
	NSString* cachePath = [cachesPath stringByAppendingPathComponent:name];
	
	[self createPathIfNecessary:cachesPath];
	[self createPathIfNecessary:cachePath];
	
	return cachePath;
}


+ (NSMutableArray *)loadStatusWithFilePath:(NSString *)filePath {
	NSMutableArray *status = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
	return status;
}

+ (void)storageStatuses:(NSArray *)statuses 
			   filePath:(NSString *)filePath {
	//[statuses writeToFile:filePath atomically:YES];
	
	//NSData *freezeDrid = [NSKeyedArchiver archivedDataWithRootObject:statuses];  
    //[freezeDrid writeToFile:filePath atomically:YES]; 
	
	[NSKeyedArchiver archiveRootObject:statuses toFile:filePath];
	
	//NSLog(@"filename: %@",filePath);
}


@end
