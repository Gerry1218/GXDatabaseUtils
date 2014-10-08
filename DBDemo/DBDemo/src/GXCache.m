//
//  GXCache.m
//  DBDemo
//
//  Created by Gerry on 14-9-21.
//  Copyright (c) 2014年 Gerry. All rights reserved.
//

#import "GXCache.h"
#import <objc/runtime.h>
#import "NSObject+serializable.h"
#import "GXSQLStatementManager.h"

@implementation GXCache

+ (instancetype) defaultCache {
    
    static GXCache *cache = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (!cache) {
            cache = [[self alloc] init];
        }
    });
    
    return cache;
}

- (id) init {
    
    self = [super init];
    
    if (self) {
        _memberListCacheDictionary = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}


- (NSArray *)memberListByName:(NSString *)className {
    
    NSArray *arr = _memberListCacheDictionary[className];
    
    if (!arr) {
        arr = [GXCache generateMemberListByClass:NSClassFromString(className)];
        if (arr) {
            [_memberListCacheDictionary setObject:arr forKey:className];
        }
    }
    
    return arr;
}

- (NSArray *)memberListByClass:(Class)cls {
    
    NSString *clsName = NSStringFromClass(cls);
    return [self memberListByName:clsName];
}

+ (NSArray *)generateMemberListByClass:(Class) cls {
    
    NSMutableArray *members = [NSMutableArray array];
    
    //
    // 枚举cls的成员及类型
    //
    NSString *clsName = NSStringFromClass(cls);
    
    while (![clsName isEqualToString:NSStringFromClass([NSObject class])]) {
        
        unsigned count = 0;
        Ivar *vars = class_copyIvarList(cls, &count);
        
        NSLog(@"------------------Class %@ start-----------------------", clsName);
        
        for (int i = 0; i < count; i++) {
            
            NSString *mName = [NSObject memberNameWithIvars:vars atIndex:i];
            NSString *mType = [NSObject memberTypeWithIvars:vars atIndex:i];
            NSString *sType = [GXSQLStatementManager sqlTypeWithMemberType:mType];
            
            if (nil == sType) {
                NSLog(@"ERROR:Skipped not supported(Member Name:%@, Member Type:%@)", mName, mType);
                continue;
            }
            
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
            [dictionary setObject:mName forKey:kKeyMemberName];
            [dictionary setObject:mType forKey:kKeyMemberType];
            [dictionary setObject:sType forKey:kKeySqliteType];
            
            [members addObject:dictionary];
            
        }
        
        NSLog(@"------------------Class %@ end-----------------------", clsName);
        
        cls = [cls superclass];
        clsName = NSStringFromClass(cls);
    }
    
    return members;
}

@end
