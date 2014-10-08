//
//  FtChatMessageDBEntity.m
//  FetionHDLogic
//
//  Created by Gerry on 14-5-30.
//  Copyright (c) 2014年 Gerry. All rights reserved.
//

#import "GXMessageDBEntity.h"


@implementation GXMessageDBEntity


- (void) dealloc {
    
    self.sessionUri = nil;
    self.sessionUserid = nil;
    self.speakerName = nil;
    self.speakerUri = nil;
    self.speakerUserID = nil;
  
    self.msgId = nil;
    self.msgContent = nil;
    self.originalContent = nil;
    self.supportLists = nil;
    
    self.fontName = nil;
    self.rmsId = nil;
    self.contentType = nil;
    
    
    self.fileName = nil;
    self.emotionShutcut = nil;
    self.emotionName = nil;
    self.downloadUrl = nil;
}

@end
