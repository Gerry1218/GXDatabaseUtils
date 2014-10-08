//
//  GChatMessage.h
//  DBDemo
//
//  Created by Gerry on 14-9-4.
//  Copyright (c) 2014年 Gerry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

enum {
    EChatSessionUnKown          = 0,
    EChatSessionNormal          = 1,
    EChatSessionPgGroup         = 2,
    EChatSessionDgGroup         = 3,
    EChatSessionSystem          = 4,
    EChatSessionPublicPlatform  = 5
};
typedef NSUInteger ChatSessionType;



enum
{
    EUnknownMessage         = 0xFFFF,
    ETextMessage            = 0,
    EPicMessage             = 1,
    EMultiplepicMessage     = 2,
    EAudioMessage           = 3,
    EVedioMessage           = 4,
    EAudiolinkMessage       = 5,
    EVediolinkMessage       = 6,
    EOutcardMessage         = 7,
    ELocationMessage        = 8,
    ECardMessage            = 9,
    EEmotionMessage         = 10,
    ESinglepictextMessage   = 11,
    EMultpictextMessage     = 12,
    EEmailMessage           = 13,
    ECeTextMessage          = 14,
    EGamelinkMessage        = 15,
    EMixpictextMessage      = 16,
    EHyperlinkMessage       = 17,
    ETextlinkMessage        = 18,
    ECeaudioMessage         = 19,
    EReadbumobjMessage      = 20,
    EPromptMessage          = 21,
    EVideoPromptMessage     = 22,
    EVoipPromptMessage      = 23,
    EAudioChatPromptMessage = 24,
    ETimeMessage            = 25,
    ECreateDGMessage        = 26,
};
typedef NSUInteger MessageType;

enum
{
    EThumbStateDownloading  = 0,
    EThumbstateDownloaded   = 1,
};
typedef NSUInteger ThumbDownloadState; 


enum
{
    EMessageStatusWaitForSend    = 0,
    EMessageStatusSending        = 1,
    EMessageStatusUploaded       = 2,
    EMessageStatusSentOk         = 3,
    EMessageStatusSendFail       = 4,
    
    EMessageStatusRcvOk          = 5,
    EMessageStatusDownloading    = 6,
    EMessageStatusDownloadOk     = 7,
    EMessageStatusDownloadFailed = 8,
    
    EMessageStatusTimeout
    
};
typedef NSUInteger MessageStatus;

enum{
    EAVPromptOutSession = 0,
    EAVPromptInSession  = 1,
    EAVPromptMiddle     = 2,
};
typedef NSUInteger EAVPromptType;

// 4-1
@interface GXBaseMessage : NSObject {
    
    NSString *address;
}

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *datas;


@end

// 26-2
@interface GXMessage : GXBaseMessage {
    
    // 3
    BOOL                  isReSendMessage;
    CGFloat cellHeight;
    NSMutableDictionary*  thumbDownloadDictionary;
    
}

// 1
@property(nonatomic, strong) NSString *company;

// 5
@property(nonatomic,strong)NSString*       sessionUri;
@property(nonatomic,strong)NSString*       sessionUserid;
@property(nonatomic,strong)NSString*       speakerName;
@property(nonatomic,strong)NSString*       speakerUri;
@property(nonatomic,strong)NSString*       speakerUserID;

// 6
@property(nonatomic,strong)NSString*       msgId;
@property(nonatomic,strong)NSString*       msgContent;
@property(nonatomic,strong)NSString*       originalContent;
@property(nonatomic,strong)NSString*       supportLists;
@property(nonatomic,strong)NSString*       fontName;
@property(nonatomic,strong)NSString*       rmsId;

// 3
@property(nonatomic,assign)long long       rqMsgId;
@property(nonatomic,assign)NSTimeInterval  msgTime;
@property(nonatomic,strong, readonly)NSMutableArray* elements;

// 3
@property(nonatomic,assign)ChatSessionType  sessionType;
@property(nonatomic,assign)MessageStatus    status;
@property(nonatomic,assign)EAVPromptType    avPromptMsgType;

// 5
@property(nonatomic,assign)BOOL             isReceive;
@property(nonatomic,assign)BOOL             isCC;
@property(nonatomic,assign)BOOL             bSending;
@property(nonatomic,assign)BOOL             isSmsMsg;
@property(nonatomic,assign)BOOL             isCloudBackupMsg;



@end
