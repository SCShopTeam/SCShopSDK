//
//  NSError+SCExtension.m
//  shopping
//
//  Created by gejunyu on 2020/8/4.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "NSError+SCExtension.h"

static NSString const *kSCErrorDomain = @"com.xinwang.error";
static NSInteger const kSCErrorCode = -1;


@implementation NSError (SCExtension)

+ (NSError *)errorWhy:(NSString *)why suggestion:(nullable NSString *)suggestion {
    NSMutableDictionary *userInfo = [NSMutableDictionary new];
    [userInfo setValue:why forKey:NSLocalizedDescriptionKey];
    if ([suggestion length] > 0) {
        [userInfo setValue:suggestion forKey:NSLocalizedRecoverySuggestionErrorKey];
    }
    NSError *error = [NSError errorWithDomain:(NSErrorDomain)kSCErrorDomain code:kSCErrorCode userInfo:userInfo];
    return error;
}

+ (NSError *)errorWhy:(NSString *)why {
    return [NSError errorWhy:why suggestion:nil];
}


#pragma mark - Properties

- (NSString *)why {
    return [self.userInfo objectForKey:NSLocalizedDescriptionKey];
}

- (NSString *)suggestion {
    return [self.userInfo objectForKey:NSLocalizedRecoverySuggestionErrorKey];
}

@end
