//
//  SCWKWebViewManager.h
//  js交互集合
//
//  Created by XianHong zhang on 2018/10/30.
//  Copyright © 2018 XianHong zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface SCWKWebViewManager : NSObject

/**
 * webview缓存池
 * 所有webview要共用一个缓存池
 */
@property (nonatomic, strong) WKProcessPool *processPool;
/**
 * js交互的方法名
 */
@property (nonatomic, strong) NSArray *jsFunctionNameArr;
/**
 * 所有需要刷新的url集合
 */
@property (nonatomic, copy) NSMutableSet *urlListSet;
/**
 * cookie的存储时间
 */
@property (nonatomic, assign) double cookieSaveTime;

//单利
+ (SCWKWebViewManager *)install;
/**获取需要插入的cookie字符串*/
- (NSString *)getCookieStr;
/**获取js注入时需要的cookie*/
- (NSString *)getJsCookieStr;
/**获取NSHTTPCookieStorage 中的cookie*/
- (NSDictionary *)getCookieStorageCookie;
/**添加cookie*/
- (void)addCookieWithName:(NSString *)name value:(NSString *)value;
/**删除cookie*/
- (void)removeCookieWithName:(NSString *)name;
/**清空cookie*/
- (void)removeAllCookie;
@end

NS_ASSUME_NONNULL_END
