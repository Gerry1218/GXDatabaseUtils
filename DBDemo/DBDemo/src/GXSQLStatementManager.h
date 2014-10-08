//
//  GXSQLStatementManager.h
//  DBManager
//
//  Created by Gerry on 14-9-21.
//  Copyright (c) 2014年 Gerry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GXHeader.h"


@interface GXSQLStatementManager : NSObject

+ (NSString *)create:(NSString *)tableName withClass:(Class)cls withPrimaryKey:(NSString *)primaryKey;

+ (NSString *)replaceInto:(NSString *)tableName withParameterList:(NSString *) paramList;

+ (NSString *)select:(NSString *)tableName where:(NSString *)whereString orderBy:(NSString *)obString sortType:(NSString *)sType limit:(NSRange)range;
+ (NSString *)selectCount:(NSString *)tableName where:(NSString *)whereString;

+ (NSString *)update:(NSString *)tableName set:(NSArray *)params where:(NSString *)whereString;

+ (NSString *)delete:(NSString *)tableName where:(NSString *)whereString;

+ (NSString *)sqlTypeWithMemberType:(NSString *)mType;
@end
