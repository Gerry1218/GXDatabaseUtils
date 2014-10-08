//
//  FtChatMessageDBEntity.h
//  FetionHDLogic
//
//  Created by Gerry on 14-5-30.
//  Copyright (c) 2014年 GErry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GXMessage.h"

@interface GXMessageDBEntity : NSObject


@property(nonatomic,strong)NSString *sessionUri;
@property(nonatomic,strong)NSString *sessionUserid;
@property(nonatomic,assign)ChatSessionType sessionType;

@property(nonatomic,strong)NSString *speakerName;
@property(nonatomic,strong)NSString *speakerUri;
@property(nonatomic,strong)NSString *speakerUserID;

@property(nonatomic,assign)NSTimeInterval  msgTime;
@property(nonatomic,strong)NSString *msgId;
@property(nonatomic,strong)NSString *msgContent;
@property(nonatomic,strong)NSString *originalContent;
@property(nonatomic,strong)NSString *supportLists;

@property(nonatomic,assign)long long rqMsgId;
@property(nonatomic,assign)BOOL isRead;
@property(nonatomic,assign)MessageStatus status;
@property(nonatomic,assign)BOOL isReceive;
@property(nonatomic,assign)BOOL isResendMessage;
@property(nonatomic,assign)BOOL isCC;
@property(nonatomic,assign)CGFloat cellHeight;
@property(nonatomic,assign)MessageType msgType;

@property(nonatomic,strong)NSString *fontName;

@property(nonatomic,assign)BOOL bSending;
@property(nonatomic,assign)BOOL isSmsMsg;
@property(nonatomic,assign)BOOL isCloudBackupMsg;

@property(nonatomic,strong)NSString* rmsId;
@property(nonatomic,assign)ThumbDownloadState dowloadState;
@property (nonatomic, copy) NSString *contentType;


@property (nonatomic, copy) NSString *strThumbLocalPath;


@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *emotionShutcut;
@property (nonatomic, strong) NSString *emotionName;
@property (nonatomic, strong) NSString *downloadUrl;

@property(nonatomic,assign)EAVPromptType   avPromptMsgType;


@end
