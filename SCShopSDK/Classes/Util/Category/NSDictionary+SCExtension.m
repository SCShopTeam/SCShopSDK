//
//  NSDictionary+SCExtension.m
//  shopping
//
//  Created by gejunyu on 2021/3/24.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import "NSDictionary+SCExtension.h"

@implementation NSDictionary (SCExtension)

- (nonnull NSString *)safeStringValueForKey:(NSString *)key
{
    id value = self[key];
    
    return VALID_STRING(value) ? value : [NSString string];
}

- (nonnull NSArray *)safeArrayValueForKey:(NSString *)key
{
    id value = self[key];
    
    return VALID_ARRAY(value) ? value : [NSArray array];
}

- (nonnull NSDictionary *)safeDictionaryValueForKey:(NSString *)key
{
    id value = self[key];
    
    return VALID_DICTIONARY(value) ? value : [NSDictionary dictionary];
}

- (nonnull NSNumber *)safeNumberValueForKey:(NSString *)key
{
    id value = self[key];
    
    return [value isKindOfClass:NSNumber.class] ? value : @0;
}

- (NSInteger)safeIntegerValueForKey:(NSString *)key
{
    id value = self[key];
    
    if (VALID_STRING(value) || [value isKindOfClass:NSNumber.class]) {
        return [value integerValue];
        
    }
    
    return 0;
}

@end
