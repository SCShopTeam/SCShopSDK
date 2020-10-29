//
//  NSDate+SCExtension.h
//  shopping
//
//  Created by gejunyu on 2020/10/26.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (SCExtension)

//比较两个日期相差的月数
- (NSInteger)monthsBetweenDate:(NSDate *)toDate;

//是否是当月
- (BOOL)isCurrentMonth;

//比较两个日期相差的天数
- (NSInteger)daysBetweenDate:(NSDate *)toDate;

//是否是同一天
- (BOOL)isSameDay:(NSDate *)anotherDate;

//是否是今天
- (BOOL)isToday;

@end

NS_ASSUME_NONNULL_END
