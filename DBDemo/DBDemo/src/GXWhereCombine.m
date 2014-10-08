//
//  GXWhereCombine.m
//  DBDemo
//
//  Created by Gerry on 14-9-26.
//  Copyright (c) 2014年 Gerry. All rights reserved.
//

#import "GXWhereCombine.h"

@implementation GXWhereCombine

+ (NSString *)combinationWhere:(NSString *)c1 withLogic:(NSString *)logic andOtherWhere:(NSString *)c2 {
    
    NSString *str = [NSString stringWithFormat:@"%@ %@ %@", c1, logic, c2];
    
    return str;
}

@end
