//
//  NSObject+serializable.m
//  DBDemo
//
//  Created by Gerry on 14-9-21.
//  Copyright (c) 2014年 Gerry. All rights reserved.
//

#import "NSObject+serializable.h"

@implementation NSObject (serializable)

- (NSMutableDictionary *)dictionary {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    Class cls = [self class];
    NSArray *arr = [[GXCache defaultCache] memberListByClass:cls];
    
    [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       
        if ([obj isKindOfClass:[NSDictionary class]]) {
            
            NSString *mName = obj[kKeyMemberName];
            NSString *mType = obj[kKeyMemberType];
            id mValue = [self valueForKey:mName];
            
            if (!mValue && [mType isEqualToString:[NSString stringWithFormat:@"%s", kObjC_NSString]]) {
                mValue = @"";
            }
            
            [dict setObject:mValue forKey:mName];
        }
    }];
    
    return dict;
}

#pragma mark - Utils
+ (NSString *)memberNameWithIvars:(Ivar *)vars atIndex:(NSInteger) index {
    
    const char *name = ivar_getName(vars[index]);
    NSString *mName = [NSString stringWithFormat:@"%s", name];
    
    return mName;
}


+ (NSString *)memberTypeWithIvars:(Ivar *) vars atIndex:(NSInteger) index {
    
    const char *type = ivar_getTypeEncoding(vars[index]);
    NSString *mType = [NSString stringWithFormat:@"%s", type];
    
    return mType;
}

@end
