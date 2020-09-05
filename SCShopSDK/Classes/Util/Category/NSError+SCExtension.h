//
//  NSError+SCExtension.h
//  shopping
//
//  Created by gejunyu on 2020/8/4.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#undef  SCERROR
#define SCERROR(P)       [NSError errorWhy:P]

@interface NSError (SCExtension)

@property (nonatomic, copy, readonly) NSString *why;
@property (nonatomic, copy, readonly) NSString *suggestion;

+ (NSError *)errorWhy:(NSString *)why suggestion:(nullable NSString *)suggestion;
+ (NSError *)errorWhy:(NSString *)why;

@end

NS_ASSUME_NONNULL_END
