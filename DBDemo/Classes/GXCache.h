//
//  GXCache.h
//  DBDemo
//
//  Created by Gerry on 14-9-21.
//  Copyright (c) 2014年 Gerry. All rights reserved.
//

#import <Foundation/Foundation.h>

// for memberListCacheDictionary
#define kKeyClassName @"className"
#define kKeyMemberList @"memberList"



@interface GXCache : NSObject {
    
    NSMutableDictionary *_memberListCacheDictionary;
}

+ (instancetype) defaultCache;

- (NSArray *)memberListByName:(NSString *)className;
- (NSArray *)memberListByClass:(Class)cls;


@end
