//
//  SmartDBHandler.m
//  AccountabilityAppNew
//
//  Created by Verve on 04/08/12.
//  Copyright (c) 2012 __Verve Mobile Labs__. All rights reserved.
//

#import "SmartDBHandler.h"

#import "Match.h"

@implementation SmartDBHandler

static SmartDBHandler *sharedInstance = nil;
@synthesize shouldCreateNewDB = _shouldCreateNewDB;
@synthesize shouldDeleteOldDBFile = _shouldDeleteOldDBFile;
@synthesize createDBScriptFileName = _createDBScriptFileName;
@synthesize updateDBScriptFileName = _updateDBScriptFileName;
@synthesize newDbVersion = _newDBVersion;
#pragma mark
#pragma mark Initialization

/**
 * First initialization of SmartDBHandler here
 */
-(id)init {
    if (self = [super init]) {
        [self initializeHandler];
        if (self.shouldCreateNewDB) {
            [self createNewDB];
        } else {
            [self connectToExistingDB];
        }
    }
    return self;
}

-(id) initWithShouldCreateNewDBFlag : (BOOL) shouldCreateNewDB {
    self.shouldCreateNewDB = shouldCreateNewDB;
    return [self init];
}

-(void)initializeHandler {
    
    currentConnectedDB = nil;
    
    self.newDbVersion = 0;
    self.shouldDeleteOldDBFile = NO;
    self.createDBScriptFileName = @"createDBScript.txt";
    self.updateDBScriptFileName = @"udpateDBScript.txt";
}

+(SmartDBHandler *)getInstance {
    if(sharedInstance == nil) {
        sharedInstance  = [[SmartDBHandler alloc] init];
    } 
    return sharedInstance;
}

+(SmartDBHandler *)getInstanceWithNewDBFlag : (BOOL) shouldCreateNewDB {
    if(sharedInstance == nil) {
        sharedInstance  = [[SmartDBHandler alloc] initWithShouldCreateNewDBFlag:shouldCreateNewDB];
    } 
    return sharedInstance;
}


-(void)connectToExistingDB {
    
    BOOL isOperationSuccessful = NO;
    
    NSError *fileCopyError = nil;
    NSError *fileDeleteError = nil;
    
    NSString *currentProjectName = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString*) kCFBundleNameKey];
    
    //Build the path to existing prepacked db from app package
	NSString *sourceDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db", currentProjectName]];
    
    //Build the path to the app's documents directory where the existing db will be copied
    NSString *destinationDBPath = [[NSString alloc] initWithString: [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.db", currentProjectName]]];
    
    NSLog(@"Destination Db Path :: %@", destinationDBPath);
    
	//Copy the database file to the app's document directory.
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: destinationDBPath] == NO) {
        isOperationSuccessful = [filemgr copyItemAtPath:sourceDBPath toPath:destinationDBPath error:&fileCopyError];
    } else if(self.shouldDeleteOldDBFile) {
        if ([filemgr removeItemAtPath:destinationDBPath error:&fileDeleteError]) {
            isOperationSuccessful = [filemgr copyItemAtPath:sourceDBPath toPath:destinationDBPath error:&fileCopyError];
        } else {
            NSLog(@"DB file delete error.");
            NSLog(@"%@", [fileDeleteError description]);
        }
    } else {
        isOperationSuccessful = YES;
    }
    [filemgr release];
    
    if (!isOperationSuccessful) {
        NSLog(@"DB file copy error.");
        NSLog(@"%@", [fileCopyError description]);
    } else {
        
        if (sqlite3_open([destinationDBPath UTF8String], &currentConnectedDB) == SQLITE_OK) {
        
            if (self.newDbVersion > 0) {
                [self setDBVersion:self.newDbVersion];
            }
            
        } else {
            NSLog(@"Failed to open/create database");
        }
        
    }
    
}

-(void)createNewDB {
    NSString *currentProjectName = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString*) kCFBundleNameKey];
    
    // Get the documents directory and Build the path to for the database file into the documents directory
    NSString *databasePath = [[NSString alloc] initWithString: [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.db", currentProjectName]]];
    
    NSString *dbScript;
    
    NSError *dbScriptFileError = nil;
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO) {
        dbScript = [NSString stringWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.createDBScriptFileName] encoding:NSUTF8StringEncoding error:&dbScriptFileError];
    } else {
        dbScript = [NSString stringWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.updateDBScriptFileName] encoding:NSUTF8StringEncoding error:&dbScriptFileError];
    }
    [filemgr release];
    
    if (dbScriptFileError) {
        NSLog(@"DB Script file error.");
        NSLog(@"%@", [dbScriptFileError description]);
    } else if ([dbScript length] > 0) {
        
        if (sqlite3_open([databasePath UTF8String], &currentConnectedDB) == SQLITE_OK) {
            
            const char *sql_stmt = [dbScript cStringUsingEncoding:NSUTF8StringEncoding];
            
            char *errMsg;
            if (sqlite3_exec(currentConnectedDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to execute dbScript.");
                NSLog(@"%@", [NSString stringWithCString:errMsg encoding:NSUTF8StringEncoding]);
            } else if (self.newDbVersion > 0) {
                [self setDBVersion:self.newDbVersion];
            }
            
        } else {
            NSLog(@"Failed to open/create database");
        }
        
    } else {
        NSLog(@"dbScript Empty.");
    }
    
}

#pragma mark
#pragma mark DBOperations


-(int) getDBVersion {
    int currentVersion = 0;
    
    if (currentConnectedDB) {
        NSMutableArray *resultSet = [self executeSelectQuery:@"PRAGMA user_version;"];
        
        NSMutableDictionary *rowDict = [resultSet objectAtIndex:0];
        currentVersion = [(NSNumber *)[rowDict objectForKey:@"user_version"] intValue];
    }
    
    return currentVersion;
}

-(BOOL) setDBVersion :(int) newDBVersion {
    
    BOOL isOperationSuccessful = NO;
    
    int currentDBVersion = [self getDBVersion];
    
    if (currentDBVersion > newDBVersion) {
        isOperationSuccessful = [self executeNonSelectQuery:[NSString stringWithFormat:@"PRAGMA user_version = %d", newDBVersion]]; 
    }
    return isOperationSuccessful;
}

-(NSMutableArray *) executeSelectQuery :(NSString *) selectQuery {
    NSMutableArray *resultSet = nil;
    
        const char *query_stmt = [selectQuery UTF8String];
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(currentConnectedDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            resultSet = [[NSMutableArray alloc] init];
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSMutableDictionary *rowDict = [[NSMutableDictionary alloc] init];
                for (int i = 0; i < sqlite3_column_count(statement); i++)
                {
                    const char *currentColName = sqlite3_column_name(statement, i);
                    NSString *nsCurrentColName = [NSString stringWithCString:currentColName encoding:NSUTF8StringEncoding];
                    
                    switch (sqlite3_column_type(statement, i)) {
                        case SQLITE_INTEGER:
                            [rowDict setObject:[NSNumber numberWithInt:(int)sqlite3_column_int(statement, i)] forKey:nsCurrentColName];
                            break;
                            
                        case SQLITE_FLOAT:
                            [rowDict setObject:[NSNumber numberWithDouble:(double)sqlite3_column_double(statement, i)] forKey:nsCurrentColName];
                            break;
                            
                        case SQLITE_TEXT:
                            [rowDict setObject:[NSString stringWithCString:(const char *)sqlite3_column_text(statement, i) encoding:NSUTF8StringEncoding] forKey:nsCurrentColName];
                            break;
                            
//                        case SQLITE_BLOB:
//                            [rowDict setObject:[NSString stringWithCString:(const char *)sqlite3_column_value(statement, i) encoding:NSUTF8StringEncoding] forKey:nsCurrentColName];
//                            break;
                            
                        case SQLITE_BLOB:
                            [rowDict setObject:[NSData dataWithBytes:sqlite3_column_blob(statement, i) length:sqlite3_column_bytes(statement, i)] forKey:nsCurrentColName];
                            break;
                            
                        case SQLITE_NULL:
                            [rowDict setObject:@"" forKey:nsCurrentColName];
                            break;
                            
                        default:
                            [rowDict setObject:[NSString stringWithCString:(const char *)sqlite3_column_value(statement, i) encoding:NSUTF8StringEncoding] forKey:nsCurrentColName];
                            break;
                    }
                
                }
                [resultSet addObject:rowDict];
            }
            
        } else {
            NSLog(@"Error executing sql\n%@", selectQuery);
        }

        sqlite3_finalize(statement);
    
    return resultSet;
}

-(BOOL) executeNonSelectQuery :(NSString *) nonSelectQuery {
    
    BOOL isExecutionSuccessful = NO;
    
    const char *query_stmt = [nonSelectQuery UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(currentConnectedDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            isExecutionSuccessful = YES;
        }
    }
    
    sqlite3_finalize(statement);
    
    return isExecutionSuccessful;
}

//TODO: Testing Remaining.
-(BOOL) insertMatchObjectWithIndex :(int) index :(NSData *) data {

    BOOL isExecutionSuccessful = NO;
    
    const char *query_stmt = [[NSString stringWithFormat:@"insert into Tbl_MatchList(index, matchObj) values(?, ?)"] UTF8String];
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(currentConnectedDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_int(statement, 1, index);
        sqlite3_bind_blob(statement, 2, [data bytes], [data length], NULL);
        
        if (sqlite3_step(statement) == SQLITE_OK) {
            isExecutionSuccessful = YES;
        } else {
            isExecutionSuccessful = NO;
        }
        
    }
    
    sqlite3_finalize(statement);
    
    return isExecutionSuccessful;
}

-(BOOL) updateMatchObjectWithIndex :(int) index :(NSData *) data {
    
    BOOL isExecutionSuccessful = NO;
    
    const char *query_stmt = [[NSString stringWithFormat:@"update Tbl_MatchList set matchObj = ? where index = %d", index] UTF8String];
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(currentConnectedDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_int(statement, 1, index);
        sqlite3_bind_blob(statement, 2, [data bytes], [data length], NULL);
        if (sqlite3_step(statement) == SQLITE_OK) {
            isExecutionSuccessful = YES;
        } else {
            isExecutionSuccessful = NO;
        }
    }
    
    
    sqlite3_finalize(statement);
    
    return isExecutionSuccessful;
}


-(BOOL) insertMasterDataObject :(NSData *) data {
    
    BOOL isExecutionSuccessful = NO;
    
    const char *query_stmt = [[NSString stringWithFormat:@"insert into Tbl_MasterData(masterDataObj) values(?)"] UTF8String];
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(currentConnectedDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_blob(statement, 1, [data bytes], [data length], NULL);
        if (sqlite3_step(statement) == SQLITE_OK) {
            isExecutionSuccessful = YES;
        } else {
            isExecutionSuccessful = NO;
        }
            
    }
        
    sqlite3_finalize(statement);
    
    return isExecutionSuccessful;
}

-(BOOL) updateMasterDataObject :(NSData *) data {
    
    BOOL isExecutionSuccessful = NO;
    
    const char *query_stmt = [[NSString stringWithFormat:@"update Tbl_MasterData set masterDataObj = ?", index] UTF8String];
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(currentConnectedDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_blob(statement, 1, [data bytes], [data length], NULL);
        
        if (sqlite3_step(statement) == SQLITE_OK) {
            isExecutionSuccessful = YES;
        } else {
            isExecutionSuccessful = NO;
        }
    }
        
    sqlite3_finalize(statement);
    
    return isExecutionSuccessful;
}


-(void) closeDatabase {
    if (currentConnectedDB) {
        if(sqlite3_close(currentConnectedDB) != SQLITE_OK) {
            NSLog(@"DB instance could not be closed as current db is busy.");
        }
    }
}

+(NSString *) toValidSQLiteString :(NSString *) rawString {
    return [rawString stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
}

#pragma mark
#pragma mark Deallocation

/**
 * Deallocation of SmartDBHandler here
 */
-(void)dealloc {    
    if (sharedInstance) {
        
        if (currentConnectedDB) {
            sqlite3_close(currentConnectedDB);
            currentConnectedDB = nil;
        }
        
        [sharedInstance release];
    }
    
    [super dealloc];
}

@end
