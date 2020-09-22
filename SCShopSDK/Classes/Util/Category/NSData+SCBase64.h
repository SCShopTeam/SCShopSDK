//
//  NSData+SCBase64.h
//  shopping
//
//  Created by zhangtao on 2020/7/20.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


void *sc_NewBase64Decode(
    const char *inputBuffer,
    size_t length,
    size_t *outputLength);

char *sc_NewBase64Encode(
    const void *inputBuffer,
    size_t length,
    bool separateLines,
    size_t *outputLength);

@interface NSData (SCBase64)

+ (NSData *)dataFromBase64String:(NSString *)aString;
- (NSString *)base64EncodedString;

+ (NSData *)bundleResource:(NSString *)resourceName type:(NSString *)type;


@end

NS_ASSUME_NONNULL_END
