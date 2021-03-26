//
//  NSDictionary+SCExtension.h
//  shopping
//
//  Created by gejunyu on 2021/3/24.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (SCExtension)

- (nonnull NSString *)safeStringValueForKey:(NSString *)key;
- (nonnull NSArray *)safeArrayValueForKey:(NSString *)key;
- (nonnull NSDictionary *)safeDictionaryValueForKey:(NSString *)key;
- (nonnull NSNumber *)safeNumberValueForKey:(NSString *)key;
- (NSInteger)safeIntegerValueForKey:(NSString *)key;


@end

NS_ASSUME_NONNULL_END
