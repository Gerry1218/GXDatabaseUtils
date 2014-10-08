//
//  GXMember.m
//  DBManager
//
//  Created by Gerry on 14-9-21.
//  Copyright (c) 2014年 Gerry. All rights reserved.
//

#import "GXMember.h"

@implementation GXMember

- (void) dealloc {
    
    _memberName = nil;
    _memberType = nil;
    _sqlType = nil;
    _memberValue = nil;
}

@end

@implementation GXLogic

- (void) dealloc {
    _whereName = nil;
    _whereValue = nil;
    _logicOperation = nil;
}

@end