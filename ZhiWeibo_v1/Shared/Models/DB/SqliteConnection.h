//
//  SqliteConnection.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-14.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Statement.h"

@interface SqliteConnection : NSObject {
	NSString *dbName;
	NSString *dbPath;
}

- (id)initWithDBName:(NSString*)dbName;

- (id)initWithDBName:(NSString*)dbName userId:(int)userId;

@end
