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
#import "GXSQLStatementManager.h"

@interface ViewController ()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) GXMessage *testMessage;

@property (nonatomic, retain) FMDatabase *database;      // used to load test data 加载测试数据用
@property (nonatomic, retain) FMDatabase *testDatabase;  // CRUD
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self addView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)addView {
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 40, CGRectGetWidth(bounds)-10, 200)];
    self.textView.layer.borderColor = [UIColor orangeColor].CGColor;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.cornerRadius = 4;
    self.textView.editable = NO;
    [self.view addSubview:self.textView];

    CGFloat gap = 10;
    
    CGFloat posX = 10;
    CGFloat posY = 250;
    CGFloat width = (CGRectGetWidth(bounds)-30)/2;
    CGFloat height = 40;
    
    // 1
    CGRect frame = CGRectMake(posX, posY, width, height);
    UIButton *loadTestDataBtn = [self buttonWithFrame:frame withTitle:@"读取测试数据" withSelector:@selector(loadTestDataBtnPressed:)];
    [self.view addSubview:loadTestDataBtn];
    
    // 2
    posX += width + gap;
    frame.origin.x = posX;
    UIButton *insertTestDataBtn = [self buttonWithFrame:frame withTitle:@"创建表并插入测试数据" withSelector:@selector(insertTestDataBtnPressed:)];
    [self.view addSubview:insertTestDataBtn];
    
    // 3
    width = (CGRectGetWidth(bounds)-40)/3;
    posX = gap;
    posY += height + gap;
    frame.origin.x = posX;
    frame.origin.y = posY;
    frame.size.width = width;
    UIButton *selectDataBtn = [self buttonWithFrame:frame withTitle:@"查询数据" withSelector:@selector(selectDataBtnPressed:)];
    [self.view addSubview:selectDataBtn];
    
    // 4
    posX += width + gap;
    frame.origin.x = posX;
    UIButton *updateDataBtn = [self buttonWithFrame:frame withTitle:@"更新数据" withSelector:@selector(updateDataBtnPressed:)];
    [self.view addSubview:updateDataBtn];
    
    // 5
    posX += width + gap;
    frame.origin.x = posX;
    UIButton *deleteDataBtn = [self buttonWithFrame:frame withTitle:@"删除数据" withSelector:@selector(deleteDataBtnPressed:)];
    [self.view addSubview:deleteDataBtn];
}

- (UIButton *)buttonWithFrame:(CGRect)frame withTitle:(NSString *)title withSelector:(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.backgroundColor = [UIColor purpleColor];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 4;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

#pragma mark - UIButton event
-(void)loadTestDataBtnPressed:(id)sender {
    [self loadTestDataFromTestDB];
}

-(void)insertTestDataBtnPressed:(id)sender {
    if (self.testMessage) {
        [self testReplaceIntoSQL:self.testMessage];
    } else {
        NSLog(@"未加载测试数据");
    }
}

-(void)selectDataBtnPressed:(id)sender {
    [self testSelectSQL];
}

-(void)updateDataBtnPressed:(id)sender {
    [self testUpdateSQL];
}

-(void)deleteDataBtnPressed:(id)sender {
    [self testDeleteSQL];
}

#pragma mark - load test data
- (void)loadTestDataFromTestDB {
    
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
    
    if (arr.count > 6) {
        self.testMessage = arr[6];
        self.textView.text = @"加载测试数据成功";
    }
    else {
        NSLog(@"load test data failure.");
        self.textView.text = @"加载测试数据失败";
    }
}

#pragma mark - db
- (FMDatabase *)database {
    if (!_database) {
        NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"db" ofType:@"sqlite"];
        _database = [FMDatabase databaseWithPath:databasePath];
    }
    
    if (![_database open]) {
        NSLog(@"open database failure.");
        self.textView.text = @"打开本地测试数据库失败";
        return nil;
    }
    return _database;
}

- (NSString *)stringWithRes:(BOOL)res {
    return (res ? @"成功" : @"失败");
}

#pragma mark - Use GXDatabaseUtils
- (void)testReplaceIntoSQL:(GXMessage *)msg {
    
    NSString *dbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"testDB.sqlite"];
    BOOL res = [GXDatabaseManager databaseWithPath:dbPath];
    
    // create table
    res = [GXDatabaseManager createTable:@"t_message" withClass:[GXMessage class] withPrimaryKey:@"_msgId"];
    
    // test sql
    NSString *createSQL = [GXSQLStatementManager create:@"t_message"
                                              withClass:[GXMessage class]
                                         withPrimaryKey:@"_msgId"];
    self.textView.text = [NSString stringWithFormat:@"%@,表创建%@", createSQL, [self stringWithRes:res]];
    
    // replace into
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
    
    // select * from table
    NSArray*arr= [GXDatabaseManager selectObjects:[GXMessageDBEntity class]
                                        fromTable:@"t_message_chat"
                                            where:w
                                       withParams:@[@"1525851662", @"0b178efa-eb51-4e14-a863-78afd8b9d5ad"]
                                          orderBy:@"_msgTime"
                                     withSortType:@"DESC"
                                        withRange:NSMakeRange(0, 5)];
    // test sql
    NSString *selectSQL = [GXSQLStatementManager select:@"t_message_chat"
                                                  where:w
                                                orderBy:@"_msgTime"
                                               sortType:@"DESC"
                                                  limit:NSMakeRange(0, 5)];
    self.textView.text = [NSString stringWithFormat:@"%@,数据:%@", selectSQL, arr];
}

- (void)testUpdateSQL {
    
    NSString *dbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"testDB.sqlite"];
    BOOL res = [GXDatabaseManager databaseWithPath:dbPath];
    
    if (!res) NSLog(@"ERROR");
    
    // update table
    NSString *w = kWhereString(@"_msgId", @"=");
    res = [GXDatabaseManager updateTable:@"t_message"
                                     set:@[@"_fontName"]
                                   where:w
                              withParams:@[@"Arial", @"0b178efa-eb51-4e14-a863-78afd8b9d5ad"]];

    // test sql
    NSString *updateSQL = [GXSQLStatementManager update:@"t_message"
                                                    set:@[@"_fontName"] where:w];
    self.textView.text = [NSString stringWithFormat:@"%@,更新数据:%@", updateSQL, [self stringWithRes:res]];
}

- (void)testDeleteSQL {
    
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"db" ofType:@"sqlite"];
    BOOL res = [GXDatabaseManager databaseWithPath:dbPath];
    if (!res) NSLog(@"ERROR...");
    
    // delete talbe
    res = [GXDatabaseManager deleteTable:@"t_message_chat"
                                   where:@"_msgId=?"
                              withParams:@[@"0b178efa-eb51-4e14-a863-78afd8b9d5ad"]];
    
    // test sql
    NSString *deleteSQL = [GXSQLStatementManager delete:@"t_message_chat"
                                                  where:@"_msgId=?" ];
    self.textView.text = [NSString stringWithFormat:@"%@,删除数据:%@", deleteSQL, [self stringWithRes:res]];
    
    // select count
//    [GXDatabaseManager selectCount:@"t_message_chat" where:@"_sessionUserid=?" withParams:@[@"1472516850"]];
}

@end
