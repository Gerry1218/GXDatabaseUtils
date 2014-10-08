//
//  GXWhereCombine.h
//  DBDemo
//
//  Created by Gerry on 14-9-26.
//  Copyright (c) 2014年 Gerry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXWhereCombine : NSObject

+ (NSString *)combinationWhere:(NSString *)c1 withLogic:(NSString *)logic andOtherWhere:(NSString *)c2;

@end
