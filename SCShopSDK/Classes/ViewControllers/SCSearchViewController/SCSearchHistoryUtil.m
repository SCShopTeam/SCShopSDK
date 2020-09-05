//
//  SCSearchHistoryUtil.m
//  shopping
//
//  Created by gejunyu on 2020/7/10.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCSearchHistoryUtil.h"
#import <FMDB/FMDB.h>

static NSString *kTableName = @"search_records";
static NSString *kRecordKey = @"record";
static NSString *kDateKey   = @"date";

@interface SCSearchHistoryUtil ()
@property (nonatomic, strong) FMDatabase *db;

@end

@implementation SCSearchHistoryUtil

DEF_SINGLETON(SCSearchHistoryUtil)

- (void)addSearchRecord:(NSString *)record
{
    if (!VALID_STRING(record)) {
        return;
    }
    
    //先查询是否已经有这条记录
    BOOL hasRecord = [self queryRecord:record];
    
    if (hasRecord) { //已经存在则只更新下时间
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@ = ?", kTableName, kDateKey, kRecordKey];
        [self.db executeUpdate:sql, [NSDate date], record];
        
    }else { //不存在则添加新数据
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@,%@) VALUES (?,?)", kTableName, kRecordKey, kDateKey];
        [self.db executeUpdate:sql, record, [NSDate date]];
        
        //检测数据数量
        [self checkDataValid];
    }

}

- (BOOL)queryRecord:(NSString *)record
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?", kTableName, kRecordKey];
    FMResultSet *rs = [self.db executeQuery:sql,record];
    
    BOOL hasRecord = NO;
    while ([rs next]) {
        hasRecord = YES;
        break;
    }
    return hasRecord;
}

- (void)checkDataValid
{
    //每次只取10条数据，防止数据积累太多，设定达到50条，清除一次多余数据
    NSString *countSql = [NSString stringWithFormat:@"select count(*) from %@",kTableName];
    NSUInteger count = [self.db intForQuery:countSql];
    
    if (count < kMaxRecordsNum*5) {
        return;
    }
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@ DESC LIMIT %lu,%lu", kTableName, kDateKey, kMaxRecordsNum,(count-kMaxRecordsNum)];
    FMResultSet *rs = [self.db executeQuery:sql];
    
    NSMutableArray *mulArr = [NSMutableArray array];
    while ([rs next]) {
        NSString *record = [rs stringForColumn:kRecordKey];
        [mulArr addObject:record];
    }
    
    [self deleteRecords:mulArr];
}

- (void)deleteRecords:(NSArray *)list
{
    //开启事务
    [self.db beginTransaction];
    BOOL isRollBack = NO;
    
    @try {
        for (NSString *record in list) {
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?",kTableName, kRecordKey];
            [self.db executeUpdate:sql, record];
        }
    } @catch (NSException *exception) {
        isRollBack = YES;
        [self.db rollback];
        
    } @finally {
        if (!isRollBack) {
            [self.db commit];
        }
    }
}

- (void)deleteAllRecords
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@",kTableName];
    [self.db executeUpdate:sql];
}


- (NSArray <NSString *> *)queryAllRecords
{
    NSMutableArray *mulArr = [NSMutableArray array];
    
    //按时间倒序取出前10条数据
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@ DESC LIMIT 0,%lu", kTableName, kDateKey, kMaxRecordsNum];
    FMResultSet *rs = [self.db executeQuery:sql];
    
    while ([rs next]) {
        NSString *record = [rs stringForColumn:kRecordKey];
        [mulArr addObject:record];
    }
    
    return mulArr.copy;
    
}


- (FMDatabase *)db
{
    if (!_db) {
        // 获取数据库文件的路径
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [docPath stringByAppendingPathComponent:@"SCSearchHistory.sqlite"];
        // 1..创建数据库对象
        _db = [FMDatabase databaseWithPath:path];
        // 2.打开数据库
        if ([_db open]) {
            //        DDLOG(@"Open database Success");
        } else {
            DDLOG(@"fail to open database:SCSearchHistory.sqlite");
        }
        
        NSString *createTableSqlString = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer PRIMARY KEY AUTOINCREMENT, %@ text NOT NULL, %@ text NOT NULL)", kTableName, kRecordKey, kDateKey];
        
        [_db executeUpdate:createTableSqlString];
    }
    return _db;
}

- (void)dealloc
{
    [_db close];
}

@end
