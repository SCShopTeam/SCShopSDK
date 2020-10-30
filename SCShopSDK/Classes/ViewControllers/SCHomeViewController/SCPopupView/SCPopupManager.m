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
static NSString *kPopupId   = @"popupId";
static NSString *kDateKey   = @"date";
static NSString *kIdKey     = @"id";


@interface SCPopupManager ()
AS_SINGLETON(SCPopupManager)
@property (nonatomic, strong) FMDatabase *db;

@end

@implementation SCPopupManager
DEF_SINGLETON(SCPopupManager)

- (instancetype)init
{
    self = [super init];
    if (self) {
//        [self cleanData]; //清理一次数据
    }
    return self;
}


+ (BOOL)validPopup:(SCHomeTouchModel *)touchModel type:(SCPopupType)type
{
    if (!touchModel || !touchModel.extraParam) {
        return NO;
    }
    
    NSString *periodType  = touchModel.extraParam[@"periodType"];                             //周期类型 eg:MONTH
    NSInteger periodCount = [(touchModel.extraParam[@"periodCount"] ?: @0) integerValue];     //周期内最大次数
    NSInteger cpmMax      = [(touchModel.extraParam[@"cpmMax"] ?: @0) integerValue];          //每天显示最大次数
    
    if (!VALID_STRING(periodType)) {
        return NO;
    }
    
    
    NSInteger monthCount = 0; //当月已显示次数
    NSInteger dayCount   = 0; //当天已显示次数
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?",kTableName, kPopupId];
    NSString *popupId = [self popupId:touchModel type:type];
    FMResultSet *rs = [[self sharedInstance].db executeQuery:sql, popupId];
    
    while ([rs next]) {
        NSString *dateStr = [rs stringForColumn:kDateKey];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateStr.integerValue];
        
        BOOL isCurrentMonth = [date isCurrentMonth]; //是否是当月
        if (isCurrentMonth) {
            monthCount ++ ;
        }
        
        BOOL isToday = [date isToday]; //是否是当天
        if (isToday) {
            dayCount ++ ;
        }
    }
    
    BOOL show = YES;
    if ([periodType isEqualToString:@"DAY"]) {
        show = dayCount < periodCount && dayCount < cpmMax;
        
    }else if ([periodType isEqualToString:@"MONTH"]) {
        show = monthCount < periodCount && dayCount < cpmMax;
        
    }else {
        show = monthCount < periodCount && dayCount < cpmMax;
    }

    if (show) {
        [self saveShowRecord:touchModel popupId:popupId];
    }
    
    return show;
}

+ (void)saveShowRecord:(SCHomeTouchModel *)touchModel popupId:(NSString *)popupId
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@,%@) VALUES (?,?)", kTableName, kPopupId, kDateKey];
    
    [[self sharedInstance].db executeUpdate:sql, popupId, [NSDate date]];
    
}

+ (NSString *)popupId:(SCHomeTouchModel *)touchModel type:(SCPopupType)type
{
    NSString *popupId = [NSString stringWithFormat:@"%@_%li",touchModel.contentNum,type];
    return popupId;
}


- (void)cleanData
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",kTableName];
    FMResultSet *rs = [self.db executeQuery:sql];
    
    NSMutableArray *deleteList = [NSMutableArray array];
    
    while ([rs next]) {
        NSString *dateStr = [rs stringForColumn:kDateKey];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateStr.integerValue];
        NSInteger months = [date monthsBetweenDate:[NSDate date]];
        
        if (months >= 2) { //将两个月之前的数据清除，防止数据库膨胀
            NSNumber *nId = @([rs intForColumn:kIdKey]);
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
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?",kTableName, kIdKey];
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
        NSString *path = [docPath stringByAppendingPathComponent:@"SCPopupHistory.sqlite"];
        
        // 1.创建数据库对象
        _db = [FMDatabase databaseWithPath:path];
        // 2.打开数据库
        if ([_db open]) {
            //        DDLOG(@"Open database Success");
        } else {
            DDLOG(@"fail to open database:SCPopupHistory.sqlite");
        }
        
        NSString *createTableSqlString = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ integer PRIMARY KEY AUTOINCREMENT, %@ text, %@ text NOT NULL)", kTableName, kIdKey,  kPopupId, kDateKey];
        
        [_db executeUpdate:createTableSqlString];
        
    }
    return _db;
}

- (void)dealloc
{
    
    [_db close];
}

@end


