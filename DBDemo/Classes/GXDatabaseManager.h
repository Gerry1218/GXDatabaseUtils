//
//  GXDatabaseManager.h
//  GXDatabaseManager
//
//  Created by Gerry on 14-9-21.
//  Copyright (c) 2014年 Gerry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GXHeader.h"

@interface GXDatabaseManager : NSObject

+ (BOOL) databaseWithPath:(NSString *)path;
+ (void) closeDatabase;

+ (BOOL) createTable:(NSString *)tableName withClass:(Class)cls withPrimaryKey:(NSString *)primaryKey;

+ (BOOL) replaceInto:(NSString *)tableName withObject:(id)object;

+ (BOOL)updateTable:(NSString *)tableName set:(NSArray *)params where:(NSString *)whereString withParams:(NSArray *)values;

+ (NSArray *)selectObjects:(Class)cls fromTable:(NSString *)tableName where:(NSString *)whereString withParams:(NSArray *)params orderBy:(NSString *)obString withSortType:(NSString *)type withRange:(NSRange)range;

+ (NSInteger)selectCountFrom:(NSString *)tableName where:(NSString *)whereString withParams:(NSArray *)params;

+ (BOOL)deleteTable:(NSString *)tableName where:(NSString *)whereString withParams:(NSArray *)params;
@end
