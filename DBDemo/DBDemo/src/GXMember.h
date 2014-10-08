//
//  GXMember.h
//  DBManager
//
//  Created by Gerry on 14-9-21.
//  Copyright (c) 2014年 Gerry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXMember : NSObject

@property(nonatomic, strong) NSString *memberName;
@property(nonatomic, strong) NSString *memberType;
@property(nonatomic, strong) NSString *sqlType;
@property(nonatomic, strong) id memberValue;

@end



// FOr logicOperation
#define LogicEqual          @"="
#define LogicLessThan       @"<"
#define LogicMoreThan       @">"
#define LogicLessThanEqual  @"<="
#define LogicMoreThanEqual  @">="
#define LogicLike           @"LIKE"

@interface GXLogic : NSObject

@property(nonatomic, strong) NSString *whereName;
@property(nonatomic, strong) id whereValue;
@property(nonatomic, strong) NSString *logicOperation;
@end

