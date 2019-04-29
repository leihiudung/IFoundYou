//
//  SQLiteManager.m
//  IFoundU
//
//  Created by Tom-Li on 2019/4/17.
//  Copyright © 2019 litong. All rights reserved.
//

#import "SQLiteManager.h"


#import <sqlite3.h>
static NSString *APP_DB_IDENTIFIER = @"iOS_DatabaseUpdateDemo";
@interface SQLiteManager() {
    sqlite3 *_db;
    
    NSString *databasePath; // 数据库路径
}

@end

@implementation SQLiteManager

static NSString *databaseFilePath() {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *directory = [paths objectAtIndex:0];
    NSString *dbPath = [directory stringByAppendingPathComponent:[[[NSBundle mainBundle] bundleIdentifier] stringByAppendingString:@".db"]];
    
    NSLog(@"dbPath:%@",dbPath);
    
    [[NSFileManager defaultManager] createDirectoryAtPath:dbPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    return [[dbPath stringByAppendingPathComponent:APP_DB_IDENTIFIER] stringByAppendingString:@".sqlite"];
}

+ (instancetype)share {
    static dispatch_once_t onceToken;
    static SQLiteManager *sqliteManager;
    dispatch_once(&onceToken, ^{
        sqliteManager = [[SQLiteManager alloc]init];
        
        NSString *tempString= databaseFilePath();
        
    });
    return sqliteManager;
    
}

- (instancetype)init {
    databasePath = databaseFilePath();
    NSInteger databaseVersion = 1;
    
    if (self = [super init]) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:databasePath]) {
            // initDatabase做了2件事
            // 1.创建数据库
            // 2.创建表
            BOOL flag = [self initDatabase];
            if (flag) {
                // 初始化数据库成功
                [self openDatabase];
            }
        } else {
            [self openDatabase];
            databaseVersion = [self getDatabaseVersion];
        }
        // insert into t_district (name, sub_district_id) values ('福田', select id from t_city where area_code = '440300');
        switch (databaseVersion) {
            case 1:
                if (![self isExistDatabaseVersion]) {
                    [self insertDatabaseVersion:databaseVersion + 1];
                } else {
                    [self updateDatabaseVersion:databaseVersion + 1];
                }
                databaseVersion += 1;
            case 2:
                [self updateDatabase:databaseVersion];
                [self updateDatabaseVersion:databaseVersion + 1];
                databaseVersion += 1;
            default:
                break;
        }
    }
    return self;
}

- (BOOL)initDatabase {
    
    
    // 判断是否有数据库存在
    
    // 不存在,就是首次使用该App.
        // 生成数据库
        // 把这次的版本号+1,保存到数据库中的数据库表中
        // 通过switch依次修改数据库
    // 存在,到数据库表中,取出版本号
        // 通过switch依次q修改数据库
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sql_default" ofType:@"plist"];
    NSArray *array = [[NSArray alloc]initWithContentsOfFile:path];

    if (array != nil) {
        // 内部没有.sqlite文件.sqlite3_open如果有就打开,没有就新建
        if (sqlite3_open([databasePath UTF8String], &_db) != SQLITE_OK) {
            sqlite3_close(_db);
            return NO;
        } else {
            char *errorMsg = nil;
            for (NSString *tableStr in array) {
                if (sqlite3_exec(_db, [tableStr UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
                    // 这里之所以调用sqlite3_free().是因为当发生错误时,errorMsg会被分配内存,填写错误信息.所以调用者有需要调用这个函数来释放该内存
                    sqlite3_free(errorMsg);
                    return NO;
                }

            }
            
            return YES;
        }
        
        
    }
    return NO;

}

- (BOOL)openDatabase {
    if (sqlite3_open([databasePath UTF8String], &_db)  != SQLITE_OK) {
        sqlite3_close(_db);
        return NO;
    } else {
        return YES;
    }
    
}

- (BOOL)isExistDatabaseVersion {
    const char *querySql = "select count(*) from t_database_version;";
    char *errormsg = nil;

    sqlite3_stmt* stmt = NULL;
    if (sqlite3_prepare_v2(_db, querySql, -1, &stmt, nil) == SQLITE_OK) {
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            if (sqlite3_column_int(stmt, 0) == 1) {
                sqlite3_finalize(stmt);
                return YES;
            }
            
        }
    }
    sqlite3_finalize(stmt);
    return NO;
}

- (void)insertDatabaseVersion:(NSInteger)version {
    sqlite3_stmt *stmt;
    const char *insertSql = "insert into t_database_version(version) values(?)";
    if (sqlite3_prepare_v2(_db, insertSql, -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_int64(stmt, 1, version);
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            
        }
        
    }
    // 调用sqlite3_finalize函数释放所有的内部资源和sqlite3_stmt数据结构，有效删除prepared语句
    sqlite3_finalize(stmt);
}

- (void)updateDatabaseVersion:(NSInteger)version {
    sqlite3_stmt *stmt = NULL;
    const char *updateSql = "update t_database_version set version = ?";
    if (sqlite3_prepare_v2(_db, updateSql, -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_int64(stmt, 1, version);
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            
        }
    }
    sqlite3_finalize(stmt);
    
}

- (void)updateDatabase:(NSInteger)version {
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"sql_update_%ld", version] ofType:@"plist"];
    // 1.检查文件是否存在
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSArray *array = [[NSArray alloc]initWithContentsOfFile:path];
        if (sqlite3_open([databasePath UTF8String], &_db) != SQLITE_OK) {
            sqlite3_close(_db);
            return;
        } else {
            char *errorMsg = nil;
            NSDictionary *temp = @{@"name": @"li", @"addr": @"深圳"};
        
            for (NSString *updateStr in array) {
                if (sqlite3_exec(_db, [updateStr UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
                    sqlite3_free(errorMsg);
                    return;
                }
                sqlite3_free(errorMsg);
                
            }
        }
        
    }
    
    //
}

- (void)initTables2:(const char *)sql {
    char *errorMesg = NULL; // 用来存储错误信息
    //sqlite3_exec()可以执行任何SQL语句，比如创表、更新、插入和删除操作。但是一般不用它执行查询语句，因为它不会返回查询到的数据
    int result = sqlite3_exec(_db, sql, NULL, NULL, &errorMesg);
    
    if (result == SQLITE_OK) {
        
        NSLog(@"成功创建t_student表");
        
    }else {
        
        NSLog(@"创建 t_student失败:%s",errorMesg);
    }
    
}

- (void)insertInteractionType {
    NSArray *arr = @[@{@"name": @"Foods"}, @{@"name": @"Drinks"}, @{@"name": @"Banks"}, @{@"name": @"Metro"}];
    
    sqlite3_stmt* stmt = NULL;/* OUT: Statement handle */
    NSString *sql = @"INSERT INTO t_interaction_type (name) VALUES (?)";
    sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, nil);
    

    for (NSDictionary *dic in arr) {
        sqlite3_bind_text(stmt, 1, [dic[@"name"] UTF8String], -1, NULL);

        //2.执行sql语句
        int result = sqlite3_step(stmt);
        NSLog(@"result: %d", result);
        sqlite3_reset(stmt);

    }

}

- (void)insertData:(NSDictionary *)dic {
    
    // 检测是否已存在
    BOOL flag = [self getRowsByCondition:dic[@"latitude"] compareWith:@"latitude"];
    if (flag) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"InsertCompletedNotification" object:nil userInfo:@{@"flag": @(Normal)}];
        return;
    }
    //1.创建插入数据的sql语句
    //===========插入单条数据=========
    // create table if not exists t_city (id integer primary key autoincrement, name text);

    // create table if not exists t_district (id integer primary key autoincrement, name text, sub_district_id integer, foreign key(sub_district_id) references t_city(id));
    
    NSUInteger tempFlag = [dic[@"phone"] rangeOfString:@")"].location;
    // insert into t_city (name, area_code) values ('深圳', '440300');
    // select id from t_city where area_code = '440300';
    // insert into t_district (name, sub_district_id) values ('福田', select id from t_city where area_code = '440300');
    [NSString stringWithFormat:@"\'%@\'", dic[@"phone"]];
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO t_merchant (name, addr, phone, province, city, area, detailInfo, latitude, longtitude) VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", dic[@"name"], dic[@"addr"], dic[@"phone"], dic[@"province"], dic[@"city"], dic[@"area"], dic[@"detailInfo"], dic[@"latitude"], dic[@"longtitude"]];
    
    char *erroMsg = NULL;
    // 2.执行sql语句
    int ret = sqlite3_exec(_db, insertSql.UTF8String, NULL, NULL, &erroMsg);
    
//    //==========同时插入多条数据=======
//    NSMutableString * mstr = [NSMutableString string];
//    for (int i = 0; i < 50; i++) {
//        NSString * name = [NSString stringWithFormat:@"name%d", i];
//        CGFloat score = arc4random() % 101 * 1.0;
//        NSString * sex = arc4random() % 2 == 0 ? @"男" : @"女";
//        NSString * tsql = [NSString stringWithFormat:@"INSERT INTO t_Student (name,score,sex) VALUES ('%@',%f,'%@');", name, score, sex];
//        [mstr appendString:tsql];
//    }
//    //将OC字符串转换成C语言的字符串
//    sql = mstr.UTF8String;
    //2.执行sql语句
//    int ret = sqlite3_exec(_db, sql, NULL, NULL, NULL);
//    if ([_delegate respondsToSelector:@selector(insertCompleted:)]) {
        //3.判断执行结果
        if (ret==SQLITE_OK) {
            NSLog(@"插入成功");
//            [_delegate insertCompleted:Normal];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"InsertCompletedNotification" object:nil userInfo:@{@"flag": @(Normal)}];
        } else{
            NSLog(@"插入失败");
//            [_delegate insertCompleted:Failure];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"InsertCompletedNotification" object:nil userInfo:@{@"flag": @(Failure)}];
        }
//    }
    
    //
}

- (BOOL)getRowsByCondition:(NSString *)condition compareWith:(NSString *)column {
    const NSString *sql = [NSString stringWithFormat:@"select * from t_merchant where %@ like %@", column, condition];
    sqlite3_stmt *stmt;
    int ret = sqlite3_prepare(_db, sql.UTF8String, -1, &stmt, nil);
    
    if (ret == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const char *name = sqlite3_column_text(stmt, 1);
            return YES;
        }
        return NO;
    } else {
        NSLog(@"non exit");
        return NO;
    }
    
}

- (NSArray<NSDictionary<NSString *, NSString *> *> *)getData {
    //1.创建数据查询的sql语句
    const char * sql = "SELECT * FROM t_merchant;";
    
    //2.执行sql语句
    //参数1:数据库
    //参数2:sql语句
    //参数3:sql语句的长度(-1自动计算)
    //参数4:结果集(用来收集查询结果)
    sqlite3_stmt * stmt;
    //参数5:NULL
    //返回值:执行结果
    int ret = sqlite3_prepare_v2(_db, sql, -1, &stmt, NULL);
    if (ret == SQLITE_OK) {
        NSLog(@"查询成功");
        //遍历结果集拿到查询到的数据
        //sqlite3_step获取结果集中的数据
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            //参数1:结果集
            //参数2:列数
            const unsigned char * name = sqlite3_column_text(stmt, 0);
            double score = sqlite3_column_double(stmt, 1);
            NSLog(@"%s %.2lf", name, score);
        }
    }else{
        NSLog(@"查询失败");
    }
    return nil;
}


- (NSArray<NSDictionary<NSString *, NSString *> *> *)getDataWidhCondition:(NSDictionary *)dic {
    //1.创建数据查询的sql语句
    const char * sql = "SELECT * FROM t_merchant where latitude < ;";
    NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM t_merchant where latitude <= %@ and longtitude <= %@ and latitude >= %@ and longtitude >= %@", [NSString stringWithFormat:@"%f", [dic[@"maxLat"] doubleValue]], [NSString stringWithFormat:@"%f", [dic[@"maxLong"] doubleValue]], [NSString stringWithFormat:@"%f", [dic[@"minLat"] doubleValue]], [NSString stringWithFormat:@"%f", [dic[@"minLong"] doubleValue]]];
    
    //2.执行sql语句
    //参数1:数据库
    //参数2:sql语句
    //参数3:sql语句的长度(-1自动计算)
    //参数4:结果集(用来收集查询结果)
    sqlite3_stmt * stmt;
    //参数5:NULL
    //返回值:执行结果
    int ret = sqlite3_prepare_v2(_db, querySql.UTF8String, -1, &stmt, NULL);
    if (ret == SQLITE_OK) {
        NSLog(@"查询成功");
        NSMutableArray *mutableArray = [NSMutableArray array];
        //遍历结果集拿到查询到的数据
        //sqlite3_step获取结果集中的数据
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            //参数1:结果集
            //参数2:列数
        
            const NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
            const NSString *addr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
            const NSString *phone = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 3)];
            const NSString *latitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 8)];
            const NSString *longtitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 9)];
            
            NSDictionary *tempDic = @{@"name": name, @"addr": addr, @"phone": phone, @"latitude": latitude, @"longtitude": longtitude};
            [mutableArray addObject:tempDic];
            
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DataWidhConditionNotification" object:nil userInfo:@{@"resultArray": mutableArray.copy}];
        
    }else{
        NSLog(@"查询失败");
    }
    return nil;
}

- (NSInteger)getDatabaseVersion {
    sqlite3_stmt *stmt;
    NSInteger version = 0;
    const char *querySql = "select version from t_database_version;";
    if (sqlite3_prepare_v2(_db, querySql, -1, &stmt, nil) == SQLITE_OK) {
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            version  = sqlite3_column_int(stmt, 0);
        }
    }
    sqlite3_finalize(stmt);
    return version;
    
}
@end
