//
//  SCSearchHistoryUtil.h
//  shopping
//
//  Created by gejunyu on 2020/7/10.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSInteger kMaxRecordsNum = 10; //最大储存数量

@interface SCSearchHistoryUtil : NSObject

//获取历史记录
- (NSArray <NSString *> *)queryAllRecords;

//添加记录
- (void)addSearchRecord:(NSString *)record;

//清除记录
- (void)deleteAllRecords;



@end

NS_ASSUME_NONNULL_END
