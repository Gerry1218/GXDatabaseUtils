GXDatabaseUtils
===============

- simplify sqlite database CRUD operation. 
- Support ARC.
- Support ios8 and before.

![](http://e.picphotos.baidu.com/album/s%3D680%3Bq%3D90/sign=16e1de60532c11dfdad1bc2b531c13ed/0823dd54564e9258a5319f6d9882d158ccbf4e2f.jpg)

## How To Get Started
 - Copy file under src and catagory directory to your project
 - [Download fmdb](https://github.com/ccgus/fmdb) relevant file
 - Add libsqlite3.dylib to project
 
## Support data types
 - BOOL
 - unsigned int
 - NSInteger
 - long long
 - CGFloat
 - double
 - NSString
 - BOOL for ios8
 - Enum for ios8
 
## Support iOS version
 iOS5 later

## Relationship class Member and column name
`RULE:` column name is member name of class.

For example:
```objective-c
// class
@interface GXBaseMessage : NSObject {
    
    NSString *address;
}

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *datas;
@end
```

| member name  | column name |
|:-------------:|:-----------:|
| address | address |
| count | _count|
| name | _name|
| datas | - |


## Dependencies
  - [fmdb](https://github.com/ccgus/fmdb) needed
  - NSObject subclass
  
## Architecture
* `<catagory>`
 - `NSObject+serializable` 

* `<src>`
 - `GXDatabaseManager`
 - `GXSQLStatementManager`
 - `GXCache`

## Usage

### CRUD operation
 - `C-Create`  
 - `R-Retrieve` 
 - `U-Update` 
 - `D-Delete`

#### Create
```objective-c
NSString *dbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"testDB.sqlite"];
BOOL res = [GXDatabaseManager databaseWithPath:dbPath];
res = [GXDatabaseManager createTable:@"t_message" withClass:[GXMessage class] withPrimaryKey:@"_msgId"];
```

#### Retrieve
```objective-c
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
```

#### Update
```objective-c
// replace into
NSString *dbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"testDB.sqlite"];
BOOL res = [GXDatabaseManager databaseWithPath:dbPath];

// create table
res = [GXDatabaseManager createTable:@"t_message" withClass:[GXMessage class] withPrimaryKey:@"_msgId"];
    
[GXDatabaseManager replaceInto:@"t_message" withObject:msg];
```
```objective-c
// update
NSString *dbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"testDB.sqlite"];
BOOL res = [GXDatabaseManager databaseWithPath:dbPath];
    
if (!res) NSLog(@"ERROR");
    
    
NSString *w = kWhereString(@"_msgId", @"=");
[GXDatabaseManager updateTable:@"t_message"
                           set:@[@"_fontName"]
                         where:w
                    withParams:@[@"黑体", @"1ccaf308-8bb0-1e44-2f0b-98f308d03d57"]];
```

#### Delete
```objective-c
NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"db" ofType:@"sqlite"];
BOOL res = [GXDatabaseManager databaseWithPath:dbPath];
if (!res) NSLog(@"ERROR...");
    
[GXDatabaseManager deleteTable:@"t_message_chat" where:@"_msgId=?" withParams:@[@"1ccaf308-8bb0-1e44-2f0b-98f308d03d57"]];
```

---

## License

GXDatabaseUtils is available under the MIT license. See the LICENSE file for more info.

