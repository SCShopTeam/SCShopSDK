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

- (nonnull NSString *)sc_safeStringValueForKey:(NSString *)key;
- (nonnull NSArray *)sc_safeArrayValueForKey:(NSString *)key;
- (nonnull NSDictionary *)sc_safeDictionaryValueForKey:(NSString *)key;
- (nonnull NSNumber *)sc_safeNumberValueForKey:(NSString *)key;
- (NSInteger)sc_safeIntegerValueForKey:(NSString *)key;


@end

NS_ASSUME_NONNULL_END
