//
//  SmartDBHandler.h
//  AccountabilityAppNew
//
//  Created by Verve on 04/08/12.
//  Copyright (c) 2012 __Verve Mobile Labs__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "sqlite3.h"

@interface SmartDBHandler : NSObject {
    //Private Area
    
    sqlite3 *currentConnectedDB;
    
    int _newDBVersion;
    BOOL _shouldCreateNewDB;
    BOOL _shouldDeleteOldDBFile;
    NSString *_createDBScriptFileName;
    NSString *_updateDBScriptFileName;
}

//Public Area for propery declaration
@property (nonatomic, assign) int newDbVersion;
@property (nonatomic, assign) BOOL shouldCreateNewDB;
@property (nonatomic, assign) BOOL shouldDeleteOldDBFile;
@property (nonatomic, retain) NSString *createDBScriptFileName;
@property (nonatomic, retain) NSString *updateDBScriptFileName;

//Public Area for method declaration

/**
 * Class Level Methods
 */

+(SmartDBHandler *)getInstanceWithNewDBFlag : (BOOL) shouldCreateNewDB;


/**
 * Instance Level Methods
 */
+(SmartDBHandler *)getInstance;
+(NSString *) toValidSQLiteString :(NSString *) rawString;

-(id) initWithShouldCreateNewDBFlag : (BOOL) shouldCreateNewDB;
-(void)initializeHandler;
-(void)connectToExistingDB;
-(void)createNewDB;
-(int)getDBVersion;
-(BOOL)setDBVersion :(int) newDBVersion;
-(NSMutableArray *)executeSelectQuery :(NSString *) strQuery;
-(BOOL)executeNonSelectQuery :(NSString *) nonSelectQuery;

-(BOOL) insertMatchObjectWithIndex :(int) index :(NSData *) data;
-(BOOL) updateMatchObjectWithIndex :(int) index :(NSData *) data;

-(BOOL) insertMasterDataObject :(NSData *) data;
-(BOOL) updateMasterDataObject :(NSData *) data;

-(void)closeDatabase;

@end
