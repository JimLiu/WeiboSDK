//
//  SqliteConnection.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-14.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "SqliteConnection.h"
#import "WeiboEngine.h"

@implementation SqliteConnection

- (id)initWithDBName:(NSString*)_dbName {
	dbName = [_dbName copy];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    dbPath = [[documentsDirectory stringByAppendingPathComponent:_dbName] retain];	
}

- (id)initWithDBName:(NSString*)_dbName userId:(int)userId {
	dbName = [_dbName copy];
	dbPath = [[WeiboEngine getCurrentUserStoreagePath:_dbName] retain];
}

- (void)dealloc {
	[dbName release];
	[dbPath release];
	[super dealloc];
}

- (sqlite3*)openDatabase
{
    sqlite3* instance;    
	// Open the database. The database was prepared outside the application.
    if (sqlite3_open([dbPath UTF8String], &instance) != SQLITE_OK) {
        // Even though the open failed, call close to properly clean up resources.
        sqlite3_close(instance);
        NSLog(@"Failed to open database. (%s)", sqlite3_errmsg(instance));
        return nil;
    }        
    return instance;
}

// Creates a writable copy of the bundled default database in the application Documents directory.
- (void)createEditableCopyOfDatabaseIfNeeded:(BOOL)force
{
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    if (force) {
        [fileManager removeItemAtPath:dbPath error:&error];
    }
    
    // No exists any database file. Create new one.
    //
    success = [fileManager fileExistsAtPath:dbPath];
    if (success) 
		return;
	
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] 
							   stringByAppendingPathComponent:dbName];
    success = [fileManager copyItemAtPath:defaultDBPath 
								   toPath:dbPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

- (sqlite3*)getDatabase:(NSString *)dbName 
{
	if (!databaseDictionary) {
		databaseDictionary = [[NSMutableDictionary alloc]init];
	}
	sqlite3* database = [databaseDictionary objectForKey:dbName];
    if (database == nil) {
		NSString *dbFilepath = [self getSqlitePath:dbName];
        database = [self openDatabase:dbFilepath];
        if (database == nil) {
            [self createEditableCopyOfDatabaseIfNeeded:true
														dbName:dbName];
			database = [self openDatabase:dbFilepath];
        }
		[databaseDictionary setObject:database forKey:dbName];
    }
    return database;
}

//
// cleanup and optimize
//
const char *cleanup_sql =
"BEGIN;"
"COMMIT";


const char *optimize_sql = "VACUUM; ANALYZE";

- (void)closeDatabase:(NSString *)dbName
{
    char *errmsg;
	sqlite3* database = [self getDatabase:dbName];
    if (database) {
      	int launchCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"launchCount"];
        NSLog(@"launchCount %d", launchCount);
        if (launchCount-- <= 0) {
            NSLog(@"Optimize database...");
            if (sqlite3_exec(database, optimize_sql, NULL, NULL, &errmsg) != SQLITE_OK) {
                NSLog(@"Error: failed to cleanup chache (%s)", errmsg);
            }
            launchCount = 50;
        }
        [[NSUserDefaults standardUserDefaults] setInteger:launchCount forKey:@"launchCount"];
        [[NSUserDefaults standardUserDefaults] synchronize];        
        sqlite3_close(database);
    }
}

- (void)beginTransaction:(NSString *)dbName
{
    char *errmsg;     
    sqlite3_exec(theDatabase, "BEGIN", NULL, NULL, &errmsg);     
}

- (void)commitTransaction:(NSString *)dbName
{
    char *errmsg;     
    sqlite3_exec(theDatabase, "COMMIT", NULL, NULL, &errmsg);     
}

- (Statement*)statementWithQuery:(const char *)sql
{
    Statement* stmt = [Statement statementWithDB:theDatabase query:sql];
    return stmt;
}

@end
