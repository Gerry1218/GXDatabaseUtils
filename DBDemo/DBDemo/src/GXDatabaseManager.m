//
//  GXDatabaseManager.m
//  GXDatabaseManager
//
//  Created by Gerry on 14-9-21.
//  Copyright (c) 2014年 Gerry. All rights reserved.
//

#import "GXDatabaseManager.h"
#import "FMDatabase.h"
#import "GXSQLStatementManager.h"
#import "NSObject+serializable.h"
#import "GXCache.h"


static FMDatabase *database = nil;

@implementation GXDatabaseManager

+ (BOOL) databaseWithPath:(NSString *)path {
    
    if (!database) {
        database = [FMDatabase databaseWithPath:path];
    }
    
    if (![database open]) {
        NSLog(@"open database failure.");
        return NO;
    }
    
    return YES;
}


+ (void) closeDatabase {
    
    if (database) {
        [database close];
        database = nil;
    }
}

// 创建
+ (BOOL) createTable:(NSString *)tableName withClass:(Class)cls withPrimaryKey:(NSString *)primaryKey {
    
    NSString *createSQL = [GXSQLStatementManager create:tableName
                                              withClass:cls
                                         withPrimaryKey:primaryKey];
    
    BOOL res = [database executeUpdate:createSQL];
    
    if (!res) {
#if ENABLED_SQL_ERROR_LOG
        NSLog(@"DB CREATE TABLE %@(%@)", tableName, [database lastErrorMessage]);
#endif
    }
    
    return res;
}

//
// insert into users values(:id, :name, :age)
//
+ (BOOL) replaceInto:(NSString *)tableName withObject:(id)object {
    
    NSDictionary *dict = [object dictionary];
    
    NSArray *memberList = [[GXCache defaultCache] memberListByClass:[object class]];
    
    if (!memberList || 0 ==  memberList.count) {
        return NO;
    }
    
    NSMutableString *paramList = [NSMutableString string];
    [memberList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dict = memberList[idx];
        NSString *mName = dict[kKeyMemberName];
        
        [paramList appendString:[NSString stringWithFormat:@":%@", mName]];
        
        if (idx != memberList.count - 1) {
            [paramList appendString:@","];
        }
    }];
    

    NSString *sql = [GXSQLStatementManager replaceInto:tableName withParameterList:paramList];
    BOOL res = [database executeUpdate:sql withParameterDictionary:dict];

    if (!res) {
#if ENABLED_SQL_ERROR_LOG
        NSLog(@"DB REPLACE INTO %@(%@)", tableName, [database lastErrorMessage]);
#endif
    }
    
    return res;
}


+ (BOOL)updateTable:(NSString *)tableName set:(NSArray *)params where:(NSString *)whereString withParams:(NSArray *)values {
    
    NSString *updateSQL = [GXSQLStatementManager update:tableName set:params where:whereString];
    if (!updateSQL) return NO;
    
    BOOL res = [database executeUpdate:updateSQL withArgumentsInArray:values];
    if(!res) {
#if ENABLED_SQL_ERROR_LOG
        NSLog(@"DB UPDATE TABLE %@(%@)", tableName, [database lastErrorMessage]);
#endif
    }
    
    return res;
}


//
// SELECT * FROM film WHERE starring LIKE 'Jodie%' AND year >= 1985 ORDER BY year DESC LIMIT 10;
//
// SELECT COUNT(*) FROM film;
// SELECT COUNT(*) FROM film WHERE year >= 1985;
//
// SELECT * FROM person WHERE name LIKE ? and AND age=?", @"gerry", @(20)
//
// SELECT * FROM film WHERE starring = 'Jodie Foster' AND year >= 1985 ORDER BY year DESC LIMIT 10;
//               ----       -------- ~  ============= ~~~ ---- ~~ ====          ---- ----       ==
//                 |       |   |     |         |       |                          |    |         |
//              tableName  |   |   operator    |     logic operator   |       obString |       range
//                         |columnName     columnValue                |                sType
//                         -------------------------------------------
//                              whereString
//
//
+ (NSArray *)selectObjects:(Class)cls fromTable:(NSString *)tableName where:(NSString *)whereString withParams:(NSArray *)params orderBy:(NSString *)obString withSortType:(NSString *)type withRange:(NSRange)range {
    
    NSMutableArray *arr = [NSMutableArray array];
    
    NSString *selectSQL = [GXSQLStatementManager select:tableName where:whereString orderBy:obString sortType:type limit:range];
    
    FMResultSet *rs = [database executeQuery:selectSQL withArgumentsInArray:params];
    
    if (!rs) {
#if ENABLED_SQL_ERROR_LOG
        NSLog(@"DB SELECT TABLE %@(%@)", tableName, [database lastErrorMessage]);
#endif
    }
    
    // 通过Class获取类成员名及成员类型
    NSArray *members = [[GXCache defaultCache] memberListByClass:cls];
    
    while (rs.next) {

        id item = [[cls alloc] init];
        
        [members enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
           
            if ([obj isKindOfClass:[NSDictionary class]]) {
                
                NSString *mName = obj[kKeyMemberName];
                id value = [GXDatabaseManager valueForDictionary:obj inFMResutSet:rs];
                if (value) {
                    [item setValue:value forKey:mName];
                }
            }
        }];
        
        [arr addObject:item];
    }
    
    return arr;
}

//
//
// example: SELECT COUNT(*) AS rowcount FROM film WHERE _shedualTime > ? AND _bShedualSms = ? AND _sendStatus = ?
//
+ (NSInteger)selectCountFrom:(NSString *)tableName where:(NSString *)whereString withParams:(NSArray *)params {
    
    NSString *selectCountSQL = [GXSQLStatementManager selectCount:tableName where:whereString];
    
    FMResultSet *rs  = [database executeQuery:selectCountSQL withArgumentsInArray:params];
    
    if (!rs) {
#if ENABLED_SQL_ERROR_LOG
        NSLog(@"DB SELECT COUNT %@(%@)", tableName, [database lastErrorMessage]);
#endif
    }
    
    while (rs.next) {
        NSInteger rowCount = [rs intForColumn:@"rowcount"];
        return rowCount;
    }
    
    return 0;
}


+ (BOOL)deleteTable:(NSString *)tableName where:(NSString *)whereString withParams:(NSArray *)params {
    
    NSString *deleteSQL = [GXSQLStatementManager delete:tableName where:whereString];
    BOOL res = [database executeUpdate:deleteSQL withArgumentsInArray:params];
    
    if (!res) {
#if ENABLED_SQL_ERROR_LOG
        NSLog(@"DB DELETE TABLE %@(%@)", tableName, [database lastErrorMessage]);
#endif
    }
    return res;
}

#pragma mark - Utils
+ (id)valueForDictionary:(NSDictionary *)dict inFMResutSet:(FMResultSet *)rs {
    
    id value = nil;
    
    NSString *mName = dict[kKeyMemberName];
    NSString *mType = dict[kKeyMemberType];
    
    if ([mType isEqualToString:StringWithUTF8String(kObjC_BOOL)] ||
        [mType isEqualToString:StringWithUTF8String(kObjC_BOOL_iOS8)]) {
        
        BOOL bVal = [rs boolForColumn:mName];
        value = @(bVal);
        
    } else if ([mType isEqualToString:StringWithUTF8String(kObjC_CGFloat)] ||
               [mType isEqualToString:StringWithUTF8String(kObjC_Double)]) {
        
        double f = [rs doubleForColumn:mName];
        value = @(f);
        
    } else if ([mType isEqualToString:StringWithUTF8String(kObjC_Enum_iOS8)]) {
        
        NSUInteger u = [rs longForColumn:mName];
        value = @(u);
        
    } else if ([mType isEqualToString:StringWithUTF8String(kObjC_Long_long)]) {
        
        long long ll = [rs longLongIntForColumn:mName];
        value = @(ll);
        
    } else if ([mType isEqualToString:StringWithUTF8String(kObjC_NSInteger)]) {
        
        NSInteger i = [rs intForColumn:mName];
        value = @(i);
        
    } else if ([mType isEqualToString:StringWithUTF8String(kObjC_NSString)]) {
        
        value = [rs objectForColumnName:mName];
        
    } else if ([mType isEqualToString:StringWithUTF8String(kObjC_Unsigned_Int)]) {
        
        unsigned int ui = [rs intForColumn:mName];
        value = @(ui);
        
    } else {
        
    }
    
    return value;
}


@end
