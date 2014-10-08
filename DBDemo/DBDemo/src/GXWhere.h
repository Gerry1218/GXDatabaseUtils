//
//  GXWhere.h
//  DBDemo
//
//  Created by Gerry on 14-9-26.
//  Copyright (c) 2014年 Gerry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXWhere : NSObject {
    
    NSMutableString *_whereString;
}

@property (nonatomic, strong, readonly) NSString *whereName;

//
// NOT LIKE
// LIKE
// =
// >
// <
// >=
// <=
//
@property (nonatomic, strong, readonly) NSString *whereLogic;

- (instancetype)initWithName:(NSString *)name withLogic:(NSString *)logic;
- (NSString *)string;


+ (instancetype)whereString:(NSString *)name withLogic:(NSString *)logic;
@end
