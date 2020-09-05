//
//  SCWKWebViewManager.m
//  js交互集合
//
//  Created by XianHong zhang on 2018/10/30.
//  Copyright © 2018 XianHong zhang. All rights reserved.
//

#import "SCWKWebViewManager.h"

@implementation SCWKWebViewManager


//单利
+ (SCWKWebViewManager *)install{
    static dispatch_once_t onceToken;
    static SCWKWebViewManager *shareInstall = nil;
    dispatch_once(&onceToken, ^{
        shareInstall = [[SCWKWebViewManager alloc] init];
    });
    return shareInstall;
}
- (id)init{
    if (self = [super init]) {
        //初始化缓存池
        _processPool = [[WKProcessPool alloc] init];
        //所有需要刷新的url的集合
        _urlListSet = [[NSMutableSet alloc] init];
        
    }
    return self;
}

/**获取需要插入的cookie字符串*/
- (NSString *)getCookieStr{
    NSMutableString *cookieValue = [NSMutableString stringWithFormat:@""];
    NSDictionary *cookieDic = [self getCookieStorageCookie];
    for (NSString *key in cookieDic) {
        NSString *appendString = [NSString stringWithFormat:@"%@=%@;", key, [cookieDic valueForKey:key]];
        [cookieValue appendString:appendString];
    }
    
    return cookieValue;
}
/**获取js注入时需要的cookie*/
- (NSString *)getJsCookieStr{
    //取出cookie
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //js函数
    NSString *JSFuncString =
    @"function setCookie(name,value,expires)\
    {\
    var oDate=new Date();\
    oDate.setDate(oDate.getDate()+expires);\
    document.cookie=name+'='+value+';expires='+oDate+';path=/'\
    }\
    function getCookie(name)\
    {\
    var arr = document.cookie.match(new RegExp('(^| )'+name+'=({FNXX==XXFN}*)(;|$)'));\
    if(arr != null) return unescape(arr[2]); return null;\
    }\
    function delCookie(name)\
    {\
    var exp = new Date();\
    exp.setTime(exp.getTime() - 1);\
    var cval=getCookie(name);\
    if(cval!=null) document.cookie= name + '='+cval+';expires='+exp.toGMTString();\
    }";
    
    //拼凑js字符串
    NSMutableString *JSCookieString = JSFuncString.mutableCopy;
    for (NSHTTPCookie *cookie in cookieStorage.cookies) {
        NSString *excuteJSString = [NSString stringWithFormat:@"setCookie('%@', '%@', 1);", cookie.name, cookie.value];
        [JSCookieString appendString:excuteJSString];
    }
    return JSCookieString;
}
/**获取NSHTTPCookieStorage 中的cookie*/
- (NSDictionary *)getCookieStorageCookie{
    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
//    NSMutableString *cookieValue = [NSMutableString stringWithFormat:@""];
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        [cookieDic setObject:cookie.value forKey:cookie.name];
    }
    return cookieDic;
}
/**添加cookie*/
- (void)addCookieWithName:(NSString *)name value:(NSString *)value{
    if (name && value) {
        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        [cookieJar setValue:value forKey:name];
    }
}
/**删除cookie*/
- (void)removeCookieWithName:(NSString *)name{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        if ([cookie.name isEqualToString:name]) {
            [cookieJar deleteCookie:cookie];
        }
    }
}
/**清空cookie*/
- (void)removeAllCookie{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        [cookieJar deleteCookie:cookie];
    }
}

@end
