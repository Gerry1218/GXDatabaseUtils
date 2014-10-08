//
//  GXWhere.m
//  DBDemo
//
//  Created by Gerry on 14-9-26.
//  Copyright (c) 2014年 Gerry. All rights reserved.
//

#import "GXWhere.h"

@implementation GXWhere

- (instancetype)initWithName:(NSString *)name withLogic:(NSString *)logic {
    
    self = [super init];
    
    if (self) {
        
        _whereName = name;
        _whereLogic = logic;
    }
    
    return self;
}

- (NSString *)string {
    
    if (_whereString == nil)
        _whereString = [NSMutableString stringWithFormat:@"%@ %@ ?", _whereName, _whereLogic];
    
    return _whereString;
}

+ (instancetype)whereString:(NSString *)name withLogic:(NSString *)logic {
    
    GXWhere *w = [[GXWhere alloc] initWithName:name withLogic:logic];
    return w;
}
@end
