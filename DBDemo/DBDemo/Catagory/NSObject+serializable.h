//
//  NSObject+serializable.h
//  DBDemo
//
//  Created by Gerry on 14-9-21.
//  Copyright (c) 2014年 Gerry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "GXHeader.h"
#import "GXCache.h"

@interface NSObject (serializable)

- (NSMutableDictionary *)dictionary;

+ (NSString *)memberNameWithIvars:(Ivar *)vars atIndex:(NSInteger) index;
+ (NSString *)memberTypeWithIvars:(Ivar *) vars atIndex:(NSInteger) index;

@end
