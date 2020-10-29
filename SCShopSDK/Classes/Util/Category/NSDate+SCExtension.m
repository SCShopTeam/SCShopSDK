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

@end
