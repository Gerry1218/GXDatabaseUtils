//
//  GXSQLStatementManager.m
//  DBManager
//
//  Created by Gerry on 14-9-21.
//  Copyright (c) 2014年 Gerry. All rights reserved.
//

#import "GXSQLStatementManager.h"
#import <objc/runtime.h>
#import "NSObject+serializable.h"
#import "GXCache.h"


/*
 * 支持的数据类型
 *
 */
static ObjCSqliteTypeMap ObjCSqliteTypeMapTable[] = {
    
    {kObjC_BOOL,          kSqlite_BOOL,          "objc的BOOL类型"},
    {kObjC_Unsigned_Int,  kSqlite_Unsigned_Int,  "unsigned int 无符号整形"},
    {kObjC_NSInteger,     kSqlite_Integer,       "NSInteger 整形"},
    {kObjC_Long_long,     kSqlite_Long_long,     "long long 64位整形"},
    {kObjC_CGFloat,       kSqlite_CGFloat,       "CGFloat 单精度浮点型"},
    {kObjC_Double,        kSqlite_Double,        "double 双精度浮点型"},
    {kObjC_NSString,      kSqlite_NSString,      "NSString objc字符串"},
    
    {kObjC_BOOL_iOS8,     kSqlite_BOOL,          "ios8中BOOL类型的编码，和之前版本有差别"},
    {kObjC_Enum_iOS8,     kSqlite_Long_long,     "iOS8中枚举类型的编码，和之前版本有差别"}
};


#define ObjCSqliteTypeMapSize sizeof(ObjCSqliteTypeMapTable)/sizeof(ObjCSqliteTypeMapTable[0])


@implementation GXSQLStatementManager

//
// 根据tableName、cls、primaryKey生成创建表的sql语句
//
//   @"CREATE TABLE IF NOT EXISTS MyTable(aa FLOAT PRIMARY KEY,bb TEXT,cc INTEGER,dd INTEGER,ee TEXT)
//
+ (NSString *)create:(NSString *)tableName withClass:(Class)cls withPrimaryKey:(NSString *)primaryKey {
    
    NSArray *members = [[GXCache defaultCache] memberListByClass:cls];
    
    __block NSMutableString *sql = [NSMutableString string];
    [members enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            
            NSString *mName = obj[kKeyMemberName];
            NSString *sType = obj[kKeySqliteType];
            
            NSString *sqlSection = [NSString stringWithFormat:@"%@ %@", mName, sType];
            
            if ([primaryKey isEqualToString:mName]) {
                sqlSection = [sqlSection stringByAppendingString:@" PRIMARY KEY"];
            }
            
            [sql appendString:sqlSection];
            
            if (idx < members.count - 1) {
                [sql appendString:@","];
            }
        }
    }];
    
    NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@)", tableName, sql];
#if ENABLED_SQL_STATEMENT
    NSLog(@"SQL CREATE:%@", createSQL);
#endif
    return createSQL;
}


+ (NSString *) replaceInto:(NSString *)tableName withParameterList:(NSString *) paramList {
    
    NSString *replaceIntoSQL = [NSString stringWithFormat:@"REPLACE INTO %@ VALUES(%@)", tableName, paramList];
#if ENABLED_SQL_STATEMENT
    NSLog(@"SQL REPLACE INTO:%@", replaceIntoSQL);
#endif
    return replaceIntoSQL;
}


/**
 *	@brief	查询数据库
 *
 *	@param 	tableName 	表名
 *	@param 	whereString 	where子句
 *	@param 	obString 	order by字段
 *	@param 	sType 	排序类型: DESC or ASC
 *	@param 	range 	查找范围
 *
 *	@return	返回查询sql
 */
+ (NSString *) select:(NSString *)tableName where:(NSString *)whereString orderBy:(NSString *)obString sortType:(NSString *)sType limit:(NSRange)range
{

    NSMutableString *selectSQL = [NSMutableString stringWithFormat:@"SELECT * FROM %@ WHERE ", tableName];
    [selectSQL appendString:whereString];
    
    if (obString.length > 0) {
        [selectSQL appendString:[NSString stringWithFormat:@" ORDER BY %@ %@ ", obString, sType]];
    }
    
    if (range.length > 0) {
        [selectSQL appendString:[NSString stringWithFormat:@" LIMIT %lu", (unsigned long)range.length]];
    }
    
#if ENABLED_SQL_STATEMENT
    NSLog(@"SQL SELECT:%@", selectSQL);
#endif
    return selectSQL;
}

+ (NSString *)selectCount:(NSString *)tableName where:(NSString *)whereString {
    
    NSString *selectCountSQL = [NSString stringWithFormat:@"SELECT COUNT(*) AS rowcount FROM %@ WHERE %@", tableName, whereString];
    
#if ENABLED_SQL_STATEMENT
    NSLog(@"SQL SELECT COUNT:%@", selectCountSQL);
#endif
    return selectCountSQL;
}

//
// 修改表名： alter table department rename to dept;
//
//
+ (NSString *)rename:(NSString *)tableName to:(NSString *)newTableName {
    
    NSString *alterSQL = [NSString stringWithFormat:@"ALTER TABLE %@ RENAME TO %@", tableName, newTableName];
#if ENABLED_SQL_STATEMENT
    NSLog(@"SQL ALTER:%@", alterSQL);
#endif
    return alterSQL;
}

//
// 添加一列：alter table employee add column deptid integer;
//
//


//
// 更新数据：update employee set title='Sales Manager' where empid=104;
//         update student_info set stu_no=0001, name=hence where stu_no=0001;
//
+ (NSString *)update:(NSString *)tableName set:(NSArray *)params where:(NSString *)whereString {
    
    if (0 == params.count || 0 == whereString.length) {
        return nil;
    }
    
    NSMutableString *updateSQL = [NSMutableString stringWithFormat:@"UPDATE %@ SET ", tableName];
    
    NSMutableString *paramString = [NSMutableString string];
    [params enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj isKindOfClass:[NSString class]]) {
            
            [paramString appendFormat:@"%@ = ?", obj];
            if (idx != params.count - 1) {
                [paramString appendString:@","];
            }
        }
    }];
    
    [updateSQL appendFormat:@"%@ WHERE %@", paramString, whereString];
    
#if ENABLED_SQL_STATEMENT
    NSLog(@"SQL UPDATE:%@", updateSQL);
#endif
    return updateSQL;
}

//
// 删除数据： delete from student_info where stu_no=0001;
//
//
+ (NSString *)delete:(NSString *)tableName where:(NSString *)whereString {
    
    NSMutableString *deleteSQL = [NSMutableString stringWithFormat:@"DELETE FROM %@ ", tableName];
    
    if (whereString) {
        [deleteSQL appendFormat:@" WHERE %@", whereString];
    }
    
#if ENABLED_SQL_STATEMENT
    NSLog(@"SQL DELETE:%@", deleteSQL);
#endif
    return deleteSQL;
}

//
//  创建索引：create index index_name on table_name(field);
//          create index student_index on student_table(stu_no);
//
//
+ (NSString *)createIndex:(NSString *)indexName onTable:(NSString *)tableName withColumn:(NSString *)field {
    
    NSString *creatIndexSQL = [NSString stringWithFormat:@"CREATE INDEX %@ on %@(%@)", indexName, tableName, field];
    
#if ENABLED_SQL_STATEMENT
    NSLog(@"SQL CREATE INDEX:%@", creatIndexSQL);
#endif
    return creatIndexSQL;
}

#pragma mark  - Utils memthods
+ (NSString *)sqlTypeWithMemberType:(NSString *)mType {
    
    const char *type = mType.UTF8String;
    
    for (int i = 0; i < ObjCSqliteTypeMapSize; i++) {
        
        const char *objcType = ObjCSqliteTypeMapTable[i].objCType;
        
        if (0 == strcmp(objcType, type)) {
            
            const char* sType = ObjCSqliteTypeMapTable[i].sqliteType;
            NSString *sqlType = [NSString stringWithUTF8String:sType];
            
            return sqlType;
        }
    }
    
    return nil;
}


@end
