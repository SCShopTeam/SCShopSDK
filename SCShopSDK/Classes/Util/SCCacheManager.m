//
//  SCCacheManager.m
//  shopping
//
//  Created by zhangtao on 2020/7/10.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCCacheManager.h"
#import "SCUtilities.h"
@implementation SCCacheManager


+ (NSString *)getCacheFilePathWithKey:(NSString *)key
{
    if (![SCUtilities isValidString:key]) {
        return nil;
    }

    NSString *cachesDirectory =
    [NSSearchPathForDirectoriesInDomains (NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    return [cachesDirectory stringByAppendingPathComponent:key];
}

+ (void)cacheObject:(id)object forKey:(NSString *)key
{
    [self cacheObject:object forKey:key withTimeoutDate:[NSDate distantFuture]];
}

+ (void)cacheObject:(id)object forKey:(NSString *)key withTimeoutInterval:(NSTimeInterval)interval
{
    NSDate *timeout = [NSDate dateWithTimeInterval:interval sinceDate:[NSDate date]];
    [self cacheObject:object forKey:key withTimeoutDate:timeout];
}

+ (void)cacheObject:(id)object forKey:(NSString *)key withTimeoutDate:(NSDate *)date
{
    if (!object || ![SCUtilities isValidString:key]) {
        return;
    }

    NSString *cachePath = [self getCacheFilePathWithKey:key];
    if (cachePath) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
        }
        NSDate *now = [NSDate date];
        NSDate *timeout = date;
        NSDictionary *temp = @{ @"cacheDate": now, @"timeoutDate": timeout, @"object": object };
        [NSKeyedArchiver archiveRootObject:temp toFile:cachePath];
    }
}

+ (id)getCachedObjectWithKey:(NSString *)key
{
    if (![SCUtilities isValidString:key]) {
        return nil;
    }

    NSString *cachePath = [self getCacheFilePathWithKey:key];
    if (cachePath && [[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
        NSDictionary *temp = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];
        NSDate *now = [NSDate date];
        NSDate *timeout = temp[@"timeoutDate"];
        if ([now compare:timeout] == NSOrderedAscending) {
            return temp[@"object"];
        }
        else {
            // 已过期，删之
            [self removeCachedObjectWithKey:key];
        }
    }
    return nil;
}

+ (BOOL)removeCachedObjectWithKey:(NSString *)key
{
    if (![SCUtilities isValidString:key]) {
        return NO;
    }

    NSString *cachePath = [self getCacheFilePathWithKey:key];
    if (cachePath && [[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
        return [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
    }
    return NO;
}

+ (void)removeCachedBills
{
    NSString *cachesDirectory =
    [NSSearchPathForDirectoriesInDomains (NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSArray *fileArray =
    [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cachesDirectory error:nil];
    NSMutableArray *toRemovedFileNames = [NSMutableArray array];
    [fileArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
      if ([obj hasPrefix:@"BillCache"]) {
          [toRemovedFileNames addObject:obj];
      }
    }];
    [toRemovedFileNames enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
      [self removeCachedObjectWithKey:obj];
    }];
}


@end
