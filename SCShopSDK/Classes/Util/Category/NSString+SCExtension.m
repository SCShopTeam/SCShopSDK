//
//  NSString+SCExtension.m
//  shopping
//
//  Created by gejunyu on 2020/7/8.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "NSString+SCExtension.h"
#include <CommonCrypto/CommonCrypto.h>
#import "NSData+SCBase64.h"
static const char encodingTable[] =
"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation NSString (SCExtension)

- (NSMutableAttributedString *)attributedStringWithLineSpacing:(NSInteger)lineSpacing
{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = lineSpacing;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self length])];
    return attributedString;
}

///计算文字高度
- (CGFloat)calculateHeightWithFont:(UIFont *)font width:(CGFloat)width
{
    CGFloat height = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size.height;
    
    return height;
    
}

- (CGFloat)calculateHeightWithFont:(UIFont *)font lineSpacing:(CGFloat)lineSpacing width:(CGFloat)width
{
    if (!VALID_STRING(self)) {
        return 0;
    }
    
    NSMutableAttributedString *attr = [self attributedStringWithLineSpacing:lineSpacing];
    
    NSDictionary *attributes = [attr attributesAtIndex:0 effectiveRange:NULL];
    NSMutableParagraphStyle *paragraphStyle = attributes[NSParagraphStyleAttributeName];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping]; //计算时要用NSLineBreakByWordWrapping,否则只有一行
    [attr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    CGFloat h = [attr boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin) context:nil].size.height;
    return h;
}

///计算文字宽度
- (CGFloat)calculateWidthWithFont:(UIFont *)font height:(CGFloat)height
{
    CGFloat width = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size.width;
    
    return width;
}

+ (NSString *)stringWithUUID
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge_transfer NSString *)string;
}



#pragma mark - MD5

- (NSString *)md5Value
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    NSString *md5Str = [[NSString stringWithFormat:
                         @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                         result[0], result[1], result[2], result[3],
                         result[4], result[5], result[6], result[7],
                         result[8], result[9], result[10], result[11],
                         result[12], result[13], result[14], result[15]
                         ] uppercaseString];
    
    return md5Str;
    
}


#pragma mark - Base64

+ (NSString *)base64StringFromText:(NSString *)text
{
    NSString *base64 = @"";
    if ([SCUtilities isValidString:text]) {

        NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
        //IOS 自带DES加密 Begin  改动了此处
        //data = [self DESEncrypt:data WithKey:key];
        //IOS 自带DES加密 End
        base64 = [self base64EncodedStringFrom:data];
    }
    return base64;
}

+ (NSString *)base64EncodedStringFrom:(NSData *)data
{
    if ([data length] == 0)
        return @"";
    
    char *characters = malloc((([data length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [data length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [data length])
            buffer[bufferLength++] = ((char *)[data bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

- (id)NSJSONValue
{
    if(self)
    {
        NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
        if(data)
        {
             return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        }
    }
    return nil;
}

@end
//CGSize size = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil].size;

