//
//  NSDate+SCExtension.m
//  shopping
//
//  Created by gejunyu on 2020/10/26.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "NSDate+SCExtension.h"

@implementation NSDate (SCExtension)

- (NSInteger)monthsBetweenDate:(NSDate *)toDate
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:self toDate:toDate options:NSCalendarWrapComponents];
    
    NSInteger months = [components month];
    
    return labs(months);
    
}

//是否是当月
- (BOOL)isCurrentMonth
{
    NSInteger months = [self monthsBetweenDate:[NSDate date]];
    
    return months <= 0;
}

- (NSInteger)daysBetweenDate:(NSDate *)d
{
    NSTimeInterval time = [self timeIntervalSinceDate:d];
    
    return abs((int)(time / 60.0 / 60.0 / 24.0));
}

- (BOOL)isToday
{
    return [self isSameDay:[NSDate date]];
}

- (BOOL)isSameDay:(NSDate *)anotherDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components1 = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    NSDateComponents *components2 = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:anotherDate];
    
    return ([components1 year] == [components2 year] && [components1 month] == [components2 month] && [components1 day] == [components2 day]);
}


//是否是同一周
- (BOOL)isSameWeek:(NSDate *)anotherDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.firstWeekday = 1; //一周开始默认为星期天 不设置会默认为星期天
    unsigned unitFlag = NSCalendarUnitYear | NSCalendarUnitWeekOfYear;
    NSDateComponents *comp1 = [calendar components:unitFlag fromDate:anotherDate];
    NSDateComponents *comp2 = [calendar components:unitFlag fromDate:self];
    return (([comp1 year] == [comp2 year]) && ([comp1 weekOfYear] == [comp2 weekOfYear]));
}

//是否是本周
- (BOOL)isCurrentWeek
{
    return [self isSameWeek:[NSDate date]];
}


//是否是同一年
- (BOOL)isSameYear:(NSDate *)anotherDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlag = NSCalendarUnitYear;
    NSDateComponents *comp1 = [calendar components:unitFlag fromDate:anotherDate];
    NSDateComponents *comp2 = [calendar components:unitFlag fromDate:self];
    return ([comp1 year] == [comp2 year]);
}

//是否是今年
- (BOOL)isCurrentYear
{
    return [self isSameWeek:[NSDate date]];
}

@end
