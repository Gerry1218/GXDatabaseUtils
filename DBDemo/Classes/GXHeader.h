//
//  GXHeader.h
//  DBDemo
//
//  Created by Gerry on 14-9-21.
//  Copyright (c) 2014年 Gerry. All rights reserved.
//

#ifndef DBDemo_GXHeader_h
#define DBDemo_GXHeader_h

// 打印sql语句
#define ENABLED_SQL_STATEMENT    1
// 打印错误日志
#define ENABLED_SQL_ERROR_LOG    1


#define kObjC_BOOL              "c"               // BOOL
#define kObjC_Unsigned_Int      "I"               // unsigned int
#define kObjC_NSInteger         "i"               // int
#define kObjC_Long_long         "q"               // long long
#define kObjC_CGFloat           "f"               // float
#define kObjC_Double            "d"               // double
#define kObjC_NSString          "@\"NSString\""   // NSString

#define kObjC_BOOL_iOS8         "B"
#define kObjC_Enum_iOS8         "Q"
//
// NULL:    a NULL value
// NUMERIC: a NUMERIC column, the storage class of the text is converted to INTEGER or REAL
// REAL:    an 8-byte IEEE floating point number.
// BLOB:    a blob of data
//
#define kSqlite_BOOL            "INTEGER"
#define kSqlite_Unsigned_Int    "INTEGER"
#define kSqlite_Integer         "INTEGER"
#define kSqlite_Long_long       "INTEGER"
#define kSqlite_CGFloat         "FLOAT"
#define kSqlite_Double          "DOUBLE"
#define kSqlite_NSString        "TEXT"


typedef struct _ObjCSqliteTypeMap {
    
    const char *objCType;
    const char *sqliteType;
    const char *typeDescription;
    
} ObjCSqliteTypeMap;


#define kKeyMemberName   @"memberName"
#define kKeyMemberType   @"memberType"
#define kKeySqliteType   @"sqliteType"

#define StringWithUTF8String(s)  [NSString stringWithUTF8String:s]

//
// compare: LIKE, NOT LIKE, >, <, >=, <=, =
//
#define kWhereString(name, compare)          [NSString stringWithFormat:@"%@ %@ ?", name, compare]

//
// logic: AND, OR
//
#define kWhereCombination(n1, logic, n2)   [NSString stringWithFormat:@"%@ %@ %@", n1, logic, n2]

#endif
