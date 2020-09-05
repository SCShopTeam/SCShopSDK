//
//  NSString+SCExtension.h
//  shopping
//
//  Created by gejunyu on 2020/7/8.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (SCExtension)

///添加行间距
- (NSMutableAttributedString *)attributedStringWithLineSpacing:(NSInteger)lineSpacing;

///计算文字高度
- (CGFloat)calculateHeightWithFont:(UIFont *)font width:(CGFloat)width;
- (CGFloat)calculateHeightWithFont:(UIFont *)font lineSpacing:(CGFloat)lineSpacing width:(CGFloat)width;

///计算文字宽度
- (CGFloat)calculateWidthWithFont:(UIFont *)font height:(CGFloat)height;

/*
 Returns a new UUID NSString
 e.g. "D1178E50-2A4D-4F1F-9BD3-F6AAB00E06B1"
 */
+ (NSString *)stringWithUUID;


//! MD5
- (NSString *)md5Value;

//! Base64 encoded string
+ (NSString *)base64StringFromText:(NSString *)text;

- (id)NSJSONValue;

@end

NS_ASSUME_NONNULL_END
