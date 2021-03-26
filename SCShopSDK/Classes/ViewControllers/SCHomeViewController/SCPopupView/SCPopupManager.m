//
//  SCPopupManager.m
//  shopping
//
//  Created by gejunyu on 2020/10/26.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCPopupManager.h"
#import <FMDB/FMDB.h>

//总表
static NSString *kTableName  = @"popup_records";
static NSString *kId         = @"id";
static NSString *kAdId       = @"adId";
static NSString *kPopupType  = @"popupType";
static NSString *kDateKey    = @"date";
static NSString *kPeriodType = @"periodType";

//只储存id且永不删除
static NSString *kIdsTable   = @"popup_ids";

@interface SCPopupManager ()
AS_SINGLETON(SCPopupManager)
@property (nonatomic, strong) FMDatabase *db;

@end

@implementation SCPopupManager
DEF_SINGLETON(SCPopupManager)

+ (BOOL)validPopup:(SCHomeTouchModel *)touchModel type:(SCPopupType)type
{
    //目前侧边弹窗没有限制
    if (type == SCPopupTypeSide) {
        return YES;
    }
    
    
    SCPopupManager *m = [SCPopupManager sharedInstance];
    
    //查找该广告有没有展示过
    BOOL hasShowed = [m hasShowed:touchModel type:type];
    //展示过则不再展示
    if (hasShowed) {
        return NO;
    }
    
    
    //没有展示过，则去数据库中查找当天和周期内打开次数是否已经到了限制
    BOOL show = [m executeQuery:touchModel type:type];
    
    if (show) {
        [m saveShowRecord:touchModel type:type];
        
        //清理一次旧数据,防止数据库膨胀
        [m cleanData:type periodType:touchModel.extraParam[@"periodType"]];
    }
    
    return show;
}


- (BOOL)hasShowed:(SCHomeTouchModel *)touchModel type:(SCPopupType)type
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? AND %@ = ?",kIdsTable, kAdId, kPopupType];

    FMResultSet *rs = [self.db executeQuery:sql, touchModel.contentNum, @(type)];

    BOOL hasShowed = NO;
    while ([rs next]) {
        hasShowed = YES;
        break;
    }
    return hasShowed;
}

- (BOOL)executeQuery:(SCHomeTouchModel *)touchModel type:(SCPopupType)type
{
    if (!touchModel || !touchModel.extraParam) {
        return NO;
    }
    
    NSString *periodType     = [touchModel.extraParam safeStringValueForKey:@"periodType"];        //周期类型 eg:MONTH
    NSInteger periodMaxCount = [touchModel.extraParam safeIntegerValueForKey:@"integerValue"];     //周期内最大次数
    NSInteger dayMaxCount    = [touchModel.extraParam safeIntegerValueForKey:@"cpmMax"];           //每天显示最大次数
    
    if (periodType.length == 0) {
        return NO;
    }
    
    //检测周期有没有更改,周期更改数据需要清理
    if ([self checkPeriodType:periodType popupType:type]) {
        [self cleanData:type periodType:nil];
    }

    NSInteger periodShowCount = 0;   //周期内已显示次数
    NSInteger dayShowCount   = 0;    //当天已显示次数
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?",kTableName, kPopupType];
    
    FMResultSet *rs = [self.db executeQuery:sql, @(type)];
    
    while ([rs next]) {
        NSString *dateStr = [rs stringForColumn:kDateKey];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateStr.integerValue];
        
        if ([self dateHasShowed:date inPeriod:periodType]) {
            periodShowCount++;
        }
        
        if ([date isToday]) {
            dayShowCount++;
        }
   
    }
    
    BOOL show = (periodShowCount < periodMaxCount && dayShowCount < dayMaxCount);
    
    return show;
}

//检测周期有没有更改,周期更改数据需要清理
- (BOOL)checkPeriodType:(NSString *)periodType popupType:(SCPopupType)type
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? ORDER BY %@ DESC LIMIT 0,1",kTableName, kPopupType, kDateKey];
        
    FMResultSet *rs = [self.db executeQuery:sql,@(type)];
    
    
    NSString *lastPeriod;
    while ([rs next]) {
        lastPeriod = [rs stringForColumn:kPeriodType];
    }
    
    if (lastPeriod) {
        return ![lastPeriod isEqualToString:periodType];
    }else {
        return NO;
    }
}


- (BOOL)dateHasShowed:(NSDate *)date inPeriod:(NSString *)periodType
{
    if ([periodType isEqualToString:@"MONTH"]) { //月
        if ([date isCurrentMonth]) {
            return YES;
        }
        
    }else if ([periodType isEqualToString:@"WEEK"]) { //周
        if ([date isCurrentWeek]) {
            return YES;
        }
        
    }else if ([periodType isEqualToString:@"DAY"]) { //天
        if ([date isToday]) {
            return YES;
        }
        
    }else if ([periodType isEqualToString:@"YEAR"]) { //年
        if ([date isCurrentYear]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)saveShowRecord:(SCHomeTouchModel *)touchModel type:(SCPopupType)type
{
    NSString *periodType = touchModel.extraParam[@"periodType"];
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@,%@,%@,%@) VALUES (?,?,?,?)", kTableName, kAdId, kPopupType, kDateKey, kPeriodType];
    
    [self.db executeUpdate:sql, touchModel.contentNum, @(type), [NSDate date], periodType];
    
    
    NSString *idsSql = [NSString stringWithFormat:@"INSERT INTO %@ (%@,%@) VALUES (?,?)", kIdsTable, kAdId, kPopupType];
    
    [self.db executeUpdate:idsSql, touchModel.contentNum, @(type)];
    
}

- (void)cleanData:(SCPopupType)popupType periodType:(nullable NSString *)periodType
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?",kTableName, kPopupType];
    FMResultSet *rs = [self.db executeQuery:sql,@(popupType)];
    
    NSMutableArray *deleteList = [NSMutableArray array];
    
    while ([rs next]) {
        NSNumber *nId = @([rs intForColumn:kId]);
        
        if (!periodType) {
            [deleteList addObject:nId];
            
        }else {
            NSString *dateStr = [rs stringForColumn:kDateKey] ?:@"";
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateStr.integerValue];
            
            if (![self dateHasShowed:date inPeriod:periodType]) {
                
                [deleteList addObject:nId];
            }
        }

    }
    
    if (deleteList.count == 0) {
        return;
    }
    
    //开启事务
    [self.db beginTransaction];
    BOOL isRollBack = NO;
    
    @try {
        for (NSNumber *nId in deleteList) {
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?",kTableName, kId];
            [self.db executeUpdate:sql, nId];
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


- (FMDatabase *)db
{
    if (!_db) {
        //获取数据库文件的路径
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [docPath stringByAppendingPathComponent:@"SCPopupRecords.sqlite"];
        
        // 1.创建数据库对象
        _db = [FMDatabase databaseWithPath:path];
        // 2.打开数据库
        if ([_db open]) {
            NSString *createTableSqlString = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ integer PRIMARY KEY AUTOINCREMENT, %@ text, %@ integer, %@ text, %@ text)", kTableName, kId, kAdId, kPopupType, kDateKey, kPeriodType];
            
            [_db executeUpdate:createTableSqlString];
            
            NSString *createIdsSqlString = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ text, %@ integer)", kIdsTable, kAdId, kPopupType];
            [_db executeUpdate:createIdsSqlString];
        }

        
    }
    return _db;
}

- (void)dealloc
{
    
    [_db close];
}

@end


