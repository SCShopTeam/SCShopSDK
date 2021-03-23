//
//  SCUtilities.h
//  shopping
//
//  Created by gejunyu on 2020/7/3.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

#undef   VALID_DICTIONARY
#define  VALID_DICTIONARY(P)   [SCUtilities isValidDictionary:P]

#undef   VALID_ARRAY
#define  VALID_ARRAY(P)        [SCUtilities isValidArray:P]

#undef   VALID_STRING
#define  VALID_STRING(P)       [SCUtilities isValidString:P]

#undef   VALID_DATA
#define  VALID_DATA(P)         [SCUtilities isValidData:P]

NS_ASSUME_NONNULL_BEGIN

@interface SCUtilities : NSObject

//判断是在shopping项目中开发调试，还是已经集成进SDK。开发测试用
+ (BOOL)isInShoppingDebug;

//! 是否是有效的字典
+ (BOOL)isValidDictionary:(id)object;
//! 是否是有效的数组
+ (BOOL)isValidArray:(id)object;
//! 是否是有效的字符串
+ (BOOL)isValidString:(id)object;
//! 是否是有效的内存二进制数据
+ (BOOL)isValidData:(id)object;

#pragma mark 添加url参数
+ (NSString *)appendParametersToURL:(NSString *)urlString;
//! 请求头增加参数
+ (void)appendParametersToHTTPHeader:(NSMutableURLRequest *)request;

// NSDictionary、NSArray、NSString 转换成 NSString
+ (NSString *)jsonStringWithDictionary:(NSDictionary *)dictionary;
+ (NSString *)jsonStringWithArray:(NSArray *)array;
+ (NSString *)jsonStringWithString:(NSString *)string;
+ (NSString *)jsonStringWithObject:(id)object;
+ (NSString*)encodeURIComponent:(NSString*)str;

//baritem
+ (UIBarButtonItem *)makeBarButtonWithIcon:(UIImage *)image target:(id _Nullable)target action:(SEL  _Nullable)selector isLeft:(BOOL)left;
+ (UIBarButtonItem *)makeBarButtonWithIcon:(UIImage *)image isLeft:(BOOL)left handler:(void (^)(id sender))handler;

//价格文字  eg:¥1000
+ (NSMutableAttributedString *)priceAttributedString:(CGFloat)price font:(UIFont *)font color:(UIColor *)color;
+ (NSAttributedString *)oldPriceAttributedString:(CGFloat)price font:(UIFont *)font color:(UIColor *)color;

/* 广告平台开关
 *ADTouchShow  广告展示开关
 *ADTouchClick 广告点击开关
 *ADTouchCall  广告调用开关
 */
+ (BOOL)ADTouchSwitch:(NSString *)str;

//登录
+ (void)pushToLoginFrom:(UIViewController *)viewController;

+ (NSDateFormatter *)dateFormatterWithFormatString:(NSString *)format;


//获取vc
+ (UITabBarController *)currentTabBarController;
+ (UINavigationController *)currentNavigationController;
+ (UIViewController *)currentViewController;

//震动
+ (void)tapticEngineShake;


+(NSString *) myLuckyKeyString;
+(NSData *)convetToNeed:(NSString *)hexString;

//UTC 时间戳， 自 1970 年起 的毫秒数
+ (NSString *)getTimeIntervalSince1970;
//得到当前日期
+ (NSString *)getCurrentDate:(NSDate *)date;

// 标准时间 yyyy-MM-dd HH:mm:ss
+ (NSString *)getTimeStandardDate:(NSDate *)date;
//获取data的日期和时间yyyyMMddHHmmssSSSSSS
+ (NSString *)getTimeInterValDate:(NSDate *)date;


+ (NSString *)suffixParameters :(NSString*)requesturl;

+ (NSString *)IDFA;

//广告平台url后面拼接参数
+ (NSString *)addParametersToURL:(NSString *)urlStr withCurrentTime:(NSString *)currentTime;

//!head头参数认证是否拼接
+ (NSString*)headjointparam:(NSString*)param paramName:(NSString*)paramName currentUrl:(NSString*)currentUrl;

/**
 获取cookie中统一认证token
 */
//+ (NSString*)getUnifyAuthToken:(NSString *)name;

//提交插码
+ (void)scXWMobStatMgrStr:(NSString *)coding url:(NSString *)url inPage:(NSString *)className;

//拨打电话
+ (void)call:(NSString *)phoneNum;

//去除小数位0
+ (NSString *)removeFloatSuffix:(CGFloat)number;

//通知
+ (void)postLoginSuccessNotification; //登录成功
//+ (void)postLoginOutNotification;     //退出登录

@end 

NS_ASSUME_NONNULL_END
