//
//  SQLiteManager.m
//  IFoundU
//
//  Created by Tom-Li on 2019/4/17.
//  Copyright © 2019 litong. All rights reserved.
//

#import "SQLiteManager.h"


#import <sqlite3.h>

@interface SQLiteManager() {
    sqlite3 *_db;
}

@end

@implementation SQLiteManager

+ (instancetype)share {
    static dispatch_once_t onceToken;
    static SQLiteManager *sqliteManager;
    dispatch_once(&onceToken, ^{
        sqliteManager = [[SQLiteManager alloc]init];
        [sqliteManager initDatabase];
    });
    return sqliteManager;
}

- (void)initDatabase {
    //1.获取沙盒文件名
    NSString *fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Merchant.sqlite"];
    NSLog(@"fileName = %@",fileName);
    
    int result = sqlite3_open(fileName.UTF8String, &_db);
    if (result == SQLITE_OK) {
        
        NSLog(@"成功打开数据库");
        
        // 创表
        const char *sql = "create table if not exists t_merchant (id integer primary key autoincrement, name text, addr text, phone text, province text, city text, area text, detailInfo text, latitude TEXT, longtitude TEXT);";
        
        char *errorMesg = NULL; // 用来存储错误信息
        //sqlite3_exec()可以执行任何SQL语句，比如创表、更新、插入和删除操作。但是一般不用它执行查询语句，因为它不会返回查询到的数据
        int result = sqlite3_exec(_db, sql, NULL, NULL, &errorMesg);
        
        if (result == SQLITE_OK) {
            
            NSLog(@"成功创建t_student表");
            
        }else {
            
            NSLog(@"创建 t_student失败:%s",errorMesg);
        }
        
    }else {
        
        NSLog(@"打开数据库失败");
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
    
    NSUInteger tempFlag = [dic[@"phone"] rangeOfString:@")"].location;

    [NSString stringWithFormat:@"\'%@\'", dic[@"phone"]];
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO t_merchant (name, addr, phone, province, city, area, detailInfo, latitude, longtitude) VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", dic[@"name"], dic[@"addr"], dic[@"phone"], dic[@"province"], dic[@"city"], dic[@"area"], dic[@"detailInfo"], dic[@"latitude"], dic[@"longtitude"]];
    
    char *erroMsg = NULL;
    //2.执行sql语句
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
    const char * sql = "SELECT name,score FROM t_merchant;";
    
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
@end