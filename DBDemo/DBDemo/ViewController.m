//
//  ViewController.m
//  DBDemo
//
//  Created by Gerry on 14-9-21.
//  Copyright (c) 2014年 Gerry. All rights reserved.
//

#import "ViewController.h"
#import "FMDatabase.h"
#import "GXMessage.h"
#import "GXDatabaseManager.h"
#import "NSObject+serializable.h"
#import "GXMessageDBEntity.h"

@interface ViewController ()

@property (nonatomic, retain) FMDatabase *database;
@property (nonatomic, retain) FMDatabase *testDatabase;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self addView];
    
    
    [self testReplaceInto];
//    [self testSelectSQL];
//    [self testUpdateSQL];
//    [self testSelect];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)addView {
    
    UIImage *img = [UIImage imageNamed:@"iphone-512"];
    UIImageView *imgView0 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10+50, 25, 25)];
    imgView0.image = img;
    [self.view addSubview:imgView0];
    
    UIImage *img0 = [UIImage imageNamed:@"iphone-25"];
    UIImageView *imgView00 = [[UIImageView alloc] initWithFrame:CGRectMake(10+50, 10+50, 25, 25)];
    imgView00.image = img0;
    [self.view addSubview:imgView00];
    
    UIImageView *imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 45+50, 50, 50)];
    imgView1.image = img;
    [self.view addSubview:imgView1];
    
    UIImageView *imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 105+50, 150, 150)];
    imgView2.image = img;
    [self.view addSubview:imgView2];
    
    UIImageView *imgView3 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 265+50, 200, 200)];
    imgView3.image = img;
    [self.view addSubview:imgView3];
}

- (void) testReplaceInto {
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:10];
    
    FMResultSet *rs = [self.database executeQuery:@"select * from t_message_chat"];
    
    while ([rs next]) {
        
        GXMessage *msg = [[GXMessage alloc] init];
        
        msg.sessionUri = [rs stringForColumn:@"_sessionUri"];
        msg.sessionUserid = [rs stringForColumn:@"_sessionUserid"];
        msg.speakerName = [rs stringForColumn:@"_speakerName"];
        msg.speakerUri = [rs stringForColumn:@"_speakerUri"];
        msg.speakerUserID = [rs stringForColumn:@"_speakerUserID"];
        msg.msgId = [rs stringForColumn:@"_msgId"];
        msg.msgContent = [rs stringForColumn:@"_msgContent"];
        msg.originalContent = [rs stringForColumn:@"_originalContent"];
        msg.supportLists = [rs stringForColumn:@"_supportLists"];
        msg.rmsId = [rs stringForColumn:@"_rmsId"];
        
        msg.rqMsgId = [rs longLongIntForColumn:@"_rqMsgId"];
        msg.msgTime = [rs doubleForColumn:@"_msgTime"];
        
        msg.sessionType = [rs intForColumn:@"_sessionType"];
        msg.status = [rs intForColumn:@"_status"];
        msg.avPromptMsgType = [rs intForColumn:@"_avPromptMsgType"];
        
        msg.isReceive = [rs boolForColumn:@"_isReceive"];
        msg.isCC = [rs boolForColumn:@"_isCC"];
        msg.bSending = [rs boolForColumn:@"_bSending"];
        msg.isSmsMsg = [rs boolForColumn:@"_isSmsMsg"];
        msg.isCloudBackupMsg = [rs boolForColumn:@"_isCloudBackupMsg"];
        
        
        [arr addObject:msg];
    }
    
    GXMessage *msg = arr[6];
    
    [self testReplaceIntoSQL:msg];
}

- (void)testReplaceIntoSQL:(GXMessage *)msg {
    
    NSString *dbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"testDB.sqlite"];
    BOOL res = [GXDatabaseManager databaseWithPath:dbPath];
    res = [GXDatabaseManager createTable:@"t_message" withClass:[GXMessage class] withPrimaryKey:@"_msgId"];
    
    [GXDatabaseManager replaceInto:@"t_message" withObject:msg];
}

- (void) testSelectSQL {
    
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"db" ofType:@"sqlite"];
    BOOL res = [GXDatabaseManager databaseWithPath:dbPath];
    if (!res) {
        NSLog(@"ERROR...");
    }
    
    NSString *w1 = kWhereString(@"_sessionUserid", @"=");
    NSString *w2 = kWhereString(@"_msgId", @"=");
    NSString *w = kWhereCombination(w1, @"AND", w2);
    
    [GXDatabaseManager selectObjects:[GXMessageDBEntity class]
                           fromTable:@"t_message_chat"
                               where:w
                          withParams:@[@"1525851662", @"615734ef-2db1-427a-9505-b49ec6a8628c"]
                             orderBy:@"_msgTime"
                        withSortType:@"DESC"
                           withRange:NSMakeRange(0, 5)];
    

}

- (void)testUpdateSQL {
    
    NSString *dbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"testDB.sqlite"];
    BOOL res = [GXDatabaseManager databaseWithPath:dbPath];
    
    if (!res) NSLog(@"ERROR");
    
    
    NSString *w = kWhereString(@"_msgId", @"=");
    [GXDatabaseManager updateTable:@"t_message"
                               set:@[@"_fontName"]
                             where:w
                        withParams:@[@"黑体", @"1ccaf308-8bb0-1e44-2f0b-98f308d03d57"]];
    
}

- (void)testSelect {
    
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"db" ofType:@"sqlite"];
    BOOL res = [GXDatabaseManager databaseWithPath:dbPath];
    if (!res) NSLog(@"ERROR...");
    

    [GXDatabaseManager deleteTable:@"t_message_chat" where:@"_msgId=?" withParams:@[@"1ccaf308-8bb0-1e44-2f0b-98f308d03d57"]];
    
//    [GXDatabaseManager selectCount:@"t_message_chat" where:@"_sessionUserid=?" withParams:@[@"1472516850"]];
}

@end
