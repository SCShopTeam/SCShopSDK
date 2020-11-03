//
//  SCPopupManager.m
//  shopping
//
//  Created by gejunyu on 2020/10/26.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCPopupManager.h"
#import <FMDB/FMDB.h>

static NSString *kTableName = @"popup_records";
static NSString *kId        = @"id";
static NSString *kAdId      = @"adId";
static NSString *kPopupType = @"popupType";
static NSString *kDateKey   = @"date";

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
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? AND %@ = ?",kTableName, kAdId, kPopupType];
    
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
    
    NSString *periodType     = touchModel.extraParam[@"periodType"];                             //周期类型 eg:MONTH
    NSInteger periodMaxCount = [(touchModel.extraParam[@"periodCount"] ?: @0) integerValue];     //周期内最大次数
    NSInteger dayMaxCount    = [(touchModel.extraParam[@"cpmMax"] ?: @0) integerValue];          //每天显示最大次数
    
    if (!VALID_STRING(periodType)) {
        return NO;
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

- (void)saveShowRecord:(SCHomeTouchModel *)touchModel  type:(SCPopupType)type
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@,%@,%@) VALUES (?,?,?)", kTableName, kAdId, kPopupType, kDateKey];
    
    [self.db executeUpdate:sql, touchModel.contentNum, @(type), [NSDate date]];
    
}

- (void)cleanData:(SCPopupType)popupType periodType:(NSString *)periodType
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?",kTableName, kPopupType];
    FMResultSet *rs = [self.db executeQuery:sql,@(popupType)];
    
    NSMutableArray *deleteList = [NSMutableArray array];
    
    while ([rs next]) {
        NSString *dateStr = [rs stringForColumn:kDateKey];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateStr.integerValue];
        
        if (![self dateHasShowed:date inPeriod:periodType]) {
            NSNumber *nId = @([rs intForColumn:kId]);
            [deleteList addObject:nId];
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
            //        DDLOG(@"Open database Success");
        } else {
            DDLOG(@"fail to open database:SCPopupRecords.sqlite");
        }
        
        NSString *createTableSqlString = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ integer PRIMARY KEY AUTOINCREMENT, %@ text, %@ integer, %@ text)", kTableName, kId, kAdId, kPopupType, kDateKey];
        
        [_db executeUpdate:createTableSqlString];
        
    }
    return _db;
}

- (void)dealloc
{
    
    [_db close];
}

@end


