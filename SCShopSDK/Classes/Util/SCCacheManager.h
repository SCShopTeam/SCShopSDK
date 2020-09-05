//
//  SCCacheManager.h
//  shopping
//
//  Created by zhangtao on 2020/7/10.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCCacheManager : NSObject

//! Cache object for key, never timeout
+ (void)cacheObject:(id)object forKey:(NSString *)key;
//! Cache object for key with timeout
+ (void)cacheObject:(id)object forKey:(NSString *)key withTimeoutInterval:(NSTimeInterval)interval;
//! Cache object for key with timeout date
+ (void)cacheObject:(id)object forKey:(NSString *)key withTimeoutDate:(NSDate *)date;
//! Get cached object for key
+ (id)getCachedObjectWithKey:(NSString *)key;
//! remove cached object for key
+ (BOOL)removeCachedObjectWithKey:(NSString *)key;
//! remove cached bills
+ (void)removeCachedBills;

@end

NS_ASSUME_NONNULL_END
