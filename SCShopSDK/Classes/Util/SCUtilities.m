//
//  SCUtilities.m
//  shopping
//
//  Created by gejunyu on 2020/7/3.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCUtilities.h"
#import "SCCacheManager.h"
#import <AdSupport/ASIdentifierManager.h>
#import "SCShoppingManager.h"
#import "UIDevice+SCExtension.h"
#import "SCLocationService.h"

@interface SCUtilities ()
AS_SINGLETON(SCUtilities)
@property (nonatomic, weak) UITabBarController *tabBarVc;
@end

@implementation SCUtilities
DEF_SINGLETON(SCUtilities)

- (instancetype)init
{
    self = [super init];
    if (self) {
       
    }
    return self;
}

+ (BOOL)isInShoppingDebug
{
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    
    if (!VALID_DICTIONARY(dict)) {
        return NO;
    }
    
    NSString *debugCode = dict[@"SCShoppingDebugCode"];
    
    if (!debugCode || ![debugCode isEqualToString:@"xinwang_shopping_debug"]) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)isValidDictionary:(id)object
{
    return object && [object isKindOfClass:[NSDictionary class]] && ((NSDictionary *)object).count;
    
}

+ (BOOL)isValidArray:(id)object
{
    return object && [object isKindOfClass:[NSArray class]] && ((NSArray *)object).count;
}

+ (BOOL)isValidString:(id)object
{
    return object && [object isKindOfClass:[NSString class]] && ((NSString *)object).length;
}

+ (BOOL)isValidData:(id)object
{
    return object && [object isKindOfClass:[NSData class]] && ((NSData *)object).length;
}

#pragma mark 添加url参数
+ (NSString *)appendParametersToURL:(NSString *)urlString
{
    if (![SCUtilities isValidString:urlString] || [urlString rangeOfString:@"sign"].location != NSNotFound) {
        return urlString;
    }
    
    NSMutableString *suffix = [[urlString rangeOfString:@"?"].location==NSNotFound ? @"?" : @"&" mutableCopy];
    [suffix appendFormat:@"%@", [SCUtilities suffixParameters:@""]];
    
    urlString = [[urlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByAppendingString:suffix];
    return urlString;
}
#pragma mark 添加请求头参数
+ (void)appendParametersToHTTPHeader:(NSMutableURLRequest *)request
{
    [request addValue:[self suffixParameters:[[request URL] absoluteString]] forHTTPHeaderField:@"jsmcc_param"];
}


+ (NSString *)jsonStringWithString:(NSString *)string
{
    return [NSString
    stringWithFormat:@"\"%@\"",
                     [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""
                                                                                                                      withString:@"\\\""]];
}

+ (NSString *)jsonStringWithArray:(NSArray *)array
{
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
        NSString *value = [SCUtilities jsonStringWithObject:valueObj];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@", value]];
        }
    }
    [reString appendFormat:@"%@", [values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
    return reString;
}

+ (NSString *)jsonStringWithDictionary:(NSDictionary *)dictionary
{
    NSArray *keys = [dictionary allKeys];
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i = 0; i < [keys count]; i++) {
        NSString *name = [keys objectAtIndex:i];
        id valueObj = [dictionary objectForKey:name];
        NSString *value = [SCUtilities jsonStringWithObject:valueObj];
        if (value) {
            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":%@", name, value]];
        }
    }
    [reString appendFormat:@"%@", [keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    return reString;
}

+ (NSString *)jsonStringWithObject:(id)object
{
    NSString *value = nil;
    if (!object) {
        return value;
    }
    if ([object isKindOfClass:[NSString class]]) {
        value = [SCUtilities jsonStringWithString:object];
    }
    else if ([object isKindOfClass:[NSDictionary class]]) {
        value = [SCUtilities jsonStringWithDictionary:object];
    }
    else if ([object isKindOfClass:[NSArray class]]) {
        value = [SCUtilities jsonStringWithArray:object];
    }
    return value;
}

+ (NSString*)encodeURIComponent:(NSString*)str{
    if([self isValidString:str])
    {
        return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)str, NULL, (__bridge CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    }
    
    return @"";
}

+ (UIBarButtonItem *)makeBarButtonWithIcon:(UIImage *)image target:(id)target action:(SEL)selector isLeft:(BOOL)left
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, image.size.width+20, 44)];
    
    UIButton *button = [[UIButton alloc] initWithFrame:bgView.bounds];
    
    if (target && selector) {
        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    }

    [button setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    button.adjustsImageWhenHighlighted = NO;
    //左边按钮居左，右边按钮图片居右，为了实现左右的间距一样
    CGFloat imgLeftEdge = left ? (-(button.size.width-image.size.width)/2) : ((button.size.width-image.size.width)/2);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, imgLeftEdge, 0, 0);
    button.tag = 4238;

    [bgView addSubview:button];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:bgView];
    
    return barButtonItem;
}

+ (UIBarButtonItem *)makeBarButtonWithIcon:(UIImage *)image isLeft:(BOOL)left handler:(nonnull void (^)(id _Nonnull))handler
{
    UIBarButtonItem *item = [self makeBarButtonWithIcon:image target:nil action:nil isLeft:left];
    UIButton *btn = [item.customView viewWithTag:4238];
    [btn sc_addEventTouchUpInsideHandle:^(id  _Nonnull sender) {
        if (handler) {
            handler(sender);
        }
    }];
    
    return item;
    
}

+ (NSMutableAttributedString *)priceAttributedString:(CGFloat)price font:(UIFont *)font color:(UIColor *)color
{
    NSString *priceStr = [self removeFloatSuffix:price];
    
    NSString *str = [NSString stringWithFormat:@"¥ %@",priceStr];
    NSMutableAttributedString *mulAtt = [[NSMutableAttributedString alloc] initWithString:str];

    UIFont *minFont = [UIFont fontWithName:font.fontName size:font.pointSize*0.7];
    [mulAtt addAttributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:minFont} range:NSMakeRange(0, 1)];
    [mulAtt addAttributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:font} range:NSMakeRange(2, priceStr.length)];
    
    return mulAtt;
}

+ (NSAttributedString *)oldPriceAttributedString:(CGFloat)price font:(UIFont *)font color:(UIColor *)color
{
    NSString *priceStr = [self removeFloatSuffix:price];
    NSString *str = [NSString stringWithFormat:@"¥%@",priceStr];
    
    NSAttributedString *att = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:color, NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
    return att;
}

+ (NSString *)removeFloatSuffix:(CGFloat)number{
    NSString *numberStr = NSStringFormat(@"%.2f",number);
    if (numberStr.length > 1) {
        
        if ([numberStr componentsSeparatedByString:@"."].count == 2) {
            NSString *last = [numberStr componentsSeparatedByString:@"."].lastObject;
            if ([last isEqualToString:@"00"]) {
                numberStr = [numberStr substringToIndex:numberStr.length - (last.length + 1)];
                return numberStr;
            }else{
                if ([[last substringFromIndex:last.length -1] isEqualToString:@"0"]) {
                    numberStr = [numberStr substringToIndex:numberStr.length - 1];
                    return numberStr;
                }
            }
        }
        return numberStr;
    }else{
        return nil;
    }
}

+ (BOOL)ADTouchSwitch:(NSString *)str{
    __block BOOL isADTouch = NO;
//    NSArray *dbArray = [[HomeDatabaseManager getDatabaseManager] getSettingData];
//    if([SCUtilities isValidArray:dbArray] && [SCUtilities isValidString:str]) {
//        [dbArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
//            if ([SCUtilities isValidDictionary:obj]) {
//                if ([[obj objectForKey:@"name"] isEqualToString:str]) {
//                    NSString *isShow = [NSString stringWithFormat:@"%@", [obj objectForKey:@"isShow"]];
//                    isADTouch = [isShow isEqualToString:@"1"] ? YES : NO;
//                    *stop = YES;
//                }
//            }
//        }];
//    }
    return isADTouch;
}

//登录
+ (void)pushToLoginFrom:(UIViewController *)viewController
{
    
}


+ (NSDateFormatter *)dateFormatterWithFormatString:(NSString *)format
{
    // 使用当前线程字典来保存对象
    NSMutableDictionary *threadDic = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = [threadDic objectForKey:format];
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = format;
        [threadDic setObject:dateFormatter forKey:format];
    }
    return dateFormatter;
    
}

//获取vc
+ (UITabBarController *)currentTabBarController
{
    UIViewController *vc = [UIApplication sharedApplication].delegate.window.rootViewController;
    
    return [vc isKindOfClass:UITabBarController.class] ? (UITabBarController *)vc : nil;
}

+ (UINavigationController *)currentNavigationController
{
    UITabBarController *tabBarVc = [SCUtilities currentTabBarController];
    if (!tabBarVc) {
        return nil;
    }
    
    NSInteger currentIndex = tabBarVc.selectedIndex;
    UIViewController *vc = tabBarVc.viewControllers[currentIndex];

    return [vc isKindOfClass:UINavigationController.class] ? (UINavigationController *)vc : nil;
}

+ (UIViewController *)currentViewController
{
    UITabBarController *tabBarVc = [SCUtilities currentTabBarController];
    if (!tabBarVc) {
        return nil;
    }
    
    NSInteger currentIndex = tabBarVc.selectedIndex;
    
    UIViewController *vc = tabBarVc.viewControllers[currentIndex];
    
    if ([vc isKindOfClass:UINavigationController.class]) {
        return ((UINavigationController *) vc).topViewController;
        
    }else {
        return vc;
    }
}

+ (void)tapticEngineShake
{
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleMedium];
        [generator prepare];
        [generator impactOccurred];
    }
}



+(NSData *)convetToNeed:(NSString *)hexString{
    int j=0;
    Byte bytes[8];  ///3ds key的Byte 数组， 128位 22
    for(int i=0;i<[hexString length];i++)
    {
        int int_ch;  /// 两位16进制数转化后的10进制数
        
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        
        int int_ch1;
        
        if(hex_char1 >= '0' && hex_char1 <='9')
            
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        
        else
            
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        
        int int_ch2;
        
        if(hex_char2 >= '0' && hex_char2 <='9')
            
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        
        else
            
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        
        
        int_ch = int_ch1+int_ch2;
        
//        NSLog(@"int_ch=%d",int_ch);
        
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        
        j++;
        
    }
    
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:8];//22
    return newData;
}


+(NSString *) myLuckyKeyString {
    
    NSString * first = @"78777465";
    NSString * second = @"63243335";
    NSString * total = [NSString stringWithFormat:@"%@%@",first,second];
    
    return [[NSString alloc] initWithData:[SCUtilities convetToNeed:total] encoding:NSUTF8StringEncoding];
    
}

+ (NSString *)getTimeIntervalSince1970
{
    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970]*1000;
    long long theTime = [[NSNumber numberWithDouble:nowtime] longLongValue];
    NSString *curTime = [NSString stringWithFormat:@"%llu",theTime];
    return curTime;
}


//得到当前日期
+ (NSString *)getCurrentDate:(NSDate *)date
{
    NSDateFormatter *format = [SCUtilities dateFormatterWithFormatString:@"yyyyMMdd"];
//    format.dateFormat = @"yyyyMMdd";
    NSString *strDate = [format stringFromDate:date];
    return strDate;
}

//获取时间全格式
+ (NSString *)getTimeInterValDate:(NSDate *)date
{
    NSDateFormatter *formatter = [SCUtilities dateFormatterWithFormatString:@"yyyyMMddHHmmssSSSSSS"];
//    [formatter setDateFormat:@"yyyyMMddHHmmssSSSSSS"];
    return [formatter stringFromDate:date];
}

// 标准时间
+ (NSString *)getTimeStandardDate:(NSDate *)date
{
    NSDateFormatter *formatter = [SCUtilities dateFormatterWithFormatString:@"yyyy-MM-dd HH:mm:ss"];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:date];
}


//// 获取当前域名对应DNS
//+ (NSString*)getDomainDNS : (NSString*)strDomain
//{
//    if ([[CheckIpv6Manager sharedManager] getCurrentIsIpv6])
//    {
//        return @"2409:8020:5c00:400::ffff";
//    }
//    else
//    {
//        return @"221.178.251.170";
//    }
//}


#pragma mark 添加的具体参数
+ (NSString *)suffixParameters :(NSString*)requesturl
{
    NSString *ua = @"jsmcc";
    NSString *loginMobile = [SCUserInfo currentUser].phoneNumber;
    NSString *deviceID = [NSString stringWithUUID];//[Utility UUID];
    NSString *platform = @"iphone";
    NSString *channel = @"sd";
    NSString *ch = @"03";
    NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    NSDateFormatter *dateFormatter = [SCUtilities dateFormatterWithFormatString:@"yyyyMMddHHmmss"];
//    dateFormatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *time = [dateFormatter stringFromDate:[NSDate date]];
    NSString *netMode = [SCNetworkTool networkType];
    
    SCLocationService *ls = [SCLocationService sharedInstance];
    NSString *lng = ls.longitude;
    NSString *lat = ls.latitude;
    NSString *poi = ls.locationAddress;
    NSString *cityCode = ls.cityCode;
    
    NSMutableString *temp = [loginMobile mutableCopy];
    if (![SCUtilities isValidString:temp])
    {
        temp = [[NSMutableString alloc] init];
    }
    
    [temp appendString:deviceID];
    [temp appendString:platform];
    [temp appendString:channel];
    [temp appendString:version];
    [temp appendString:time];
    [temp appendString:@"activity!@#"];
    
    NSString *sign = [temp md5Value];
    
    NSString *tempSign = [temp stringByReplacingOccurrencesOfString:@"activity!@#" withString:@"activityHTV!@#%^&*"];
    NSString *sign3 = [tempSign md5Value];
    
    NSMutableString *temp1 = [loginMobile mutableCopy];
    if (![SCUtilities isValidString:temp1])
    {
        temp1 = [[NSMutableString alloc] init];
    }
    [temp1 appendString:deviceID];
    [temp1 appendString:platform];
    [temp1 appendString:channel];
    [temp1 appendString:version];
    [temp1 appendString:time];
    [temp1 appendString:[UIDevice machineModelName]];
    [temp1 appendString:netMode];
    [temp1 appendString:[NSString stringWithFormat:@"%d", [UIDevice isJailbroken]]];
    [temp1 appendString:@"activity$%^&*"];
    NSString *sign2 = [temp1 md5Value];
    
    
    NSMutableString *suffix = [NSMutableString string];
    [suffix appendFormat:@"ua=%@&",ua];
    [suffix appendFormat:@"loginmobile=%@&", loginMobile];
    [suffix appendFormat:@"deviceid=%@&", deviceID];
    [suffix appendFormat:@"platform=%@&", platform];
    [suffix appendFormat:@"channel=%@&", channel];
    [suffix appendFormat:@"ch=%@&", ch];
    [suffix appendFormat:@"version=%@&", version];
    [suffix appendFormat:@"netmode=%@&", netMode];
    [suffix appendFormat:@"time=%@&", time];
    [suffix appendFormat:@"%@", [SCUtilities headjointparam:[NSString stringWithFormat:@"lng=%@&",lng ] paramName:@"lng" currentUrl:requesturl]];
    [suffix appendFormat:@"%@", [SCUtilities headjointparam:[NSString stringWithFormat:@"lat=%@&",lat ] paramName:@"lat" currentUrl:requesturl]];
    [suffix appendFormat:@"%@", [SCUtilities headjointparam:[NSString stringWithFormat:@"poi=%@&",poi ] paramName:@"poi" currentUrl:requesturl]];
    [suffix appendFormat:@"%@", [SCUtilities headjointparam:[NSString stringWithFormat:@"cityCode=%@&",cityCode ] paramName:@"cityCode" currentUrl:requesturl]];
    [suffix appendFormat:@"JType=%d&",[UIDevice isJailbroken]];
    [suffix appendFormat:@"platformExpland=%@&", [UIDevice machineModelName]];
//    [suffix appendFormat:@"idfa=%@&", [self  IDFA]];
    [suffix appendFormat:@"%@", [SCUtilities headjointparam:[NSString stringWithFormat:@"idfaMd5=%@&",[self IDFA] ] paramName:@"idfaMd5" currentUrl:requesturl]];
    [suffix appendFormat:@"cmtokenid=%@&",[SCUserInfo currentUser].cmtokenid];// shareInstance].sessionId];
    [suffix appendFormat:@"sign=%@&", sign];
    [suffix appendFormat:@"sign2=%@&", sign2];
    [suffix appendFormat:@"sign3=%@", sign3];
    return [suffix stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+(NSString *)IDFA{
        NSString *deviceID;
        //取IDFA,可能会取不到,如用户关闭IDFA
        if ([ASIdentifierManager sharedManager].advertisingTrackingEnabled)
        {
            deviceID = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString] ;
        }else{
            //如果取不到,就生成UUID,当成IDFA
//            deviceID = [Utility simulateIDFA];
            deviceID = @"";
        }
        return deviceID;
}


+ (NSString *)addParametersToURL:(NSString *)urlStr withCurrentTime:(NSString *)currentTime;
{
    urlStr = [urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    /*必传参数
     *OS
     *IP
     *TS
     *IMEI （OpenUDID）
     *IDFA
     */
    NSString *imei = [self IDFA]; //用户终端的 IMEI，15 位数字 OS=1 时， MAC/MAC1/IDFA /OpenUDID 至少 一项必填
    NSString *idfa = [self IDFA]; //iOS IDFA 适用于 iOS6 及以上
    NSString *replacedStr = [urlStr stringByReplacingOccurrencesOfString:@"__IMEI__"withString:imei];
    replacedStr = [replacedStr stringByReplacingOccurrencesOfString:@"__IDFA__"withString:idfa];
    replacedStr = [replacedStr stringByReplacingOccurrencesOfString:@"__OS__"withString:@"1"];
    replacedStr = [replacedStr stringByReplacingOccurrencesOfString:@"__TS__"withString:currentTime];
    replacedStr = [replacedStr stringByReplacingOccurrencesOfString:@"__UUID__"withString:[NSString stringWithUUID]];
    return [replacedStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

//!head头参数认证是否拼接
+ (NSString*)headjointparam:(NSString*)param paramName:(NSString*)paramName currentUrl:(NSString*)currentUrl
{
   
//    YYMemoryCache* memoryCache = [[YYCacheManager shareYYCacheManager] createMemoryCache:@"HomeDatabaseManager"];
//
//    NSString *sql = @"select * from t_webview_headparam";
//
//    //判断缓存是否存在
//    BOOL isContains=[memoryCache containsObjectForKey:sql];
//    //    NSLog(@"containsObject : %@", isContains?@"YES":@"NO");
    NSArray *resultCache;
//    if(isContains)
//    {
//        //根据key读取数据
//        id value=[memoryCache objectForKey:sql];
//        resultCache = value;
//    }
    
    if (![SCUtilities isValidArray:resultCache])
    {
        __block NSMutableArray *result = [NSMutableArray array];
        
        NSArray *arr = @[@{@"id":[NSNumber numberWithInt:1],
                        @"fitler":@"10086.cn,cnr.asiainfo.com,wx.apollojs.cn,wx.apollojs.cn,cnr.asiainfo.com",
                           @"paramName":@"lng"},
  
  @{@"id":[NSNumber numberWithInt:2],
      @"fitler":@"10086.cn,cnr.asiainfo.com,wx.apollojs.cn,wx.apollojs.cn,cnr.asiainfo.com",
         @"paramName":@"lat"},
  
  @{@"id":[NSNumber numberWithInt:3],
      @"fitler":@"10086.cn,cnr.asiainfo.com,wx.apollojs.cn,wx.apollojs.cn,cnr.asiainfo.com",
         @"paramName":@"poi"},
  
  @{@"id":[NSNumber numberWithInt:4],
      @"fitler":@"10086.cn,cnr.asiainfo.com,wx.apollojs.cn,wx.apollojs.cn,cnr.asiainfo.com",
         @"paramName":@"cityCode"},
  
  @{@"id":[NSNumber numberWithInt:5],
      @"fitler":@"10086.cn,cnr.asiainfo.com,wx.apollojs.cn,wx.apollojs.cn,cnr.asiainfo.com",
         @"paramName":@"idfaMd5"}];
        

        [result addObjectsFromArray:arr];
        
        resultCache = result;
        
        
        
        
//        [dataBase executeQuery:sql block:^(FMResultSet *rs) {
//            while ([rs next]) {
//                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//                dic[@"id"]      = @([rs intForColumn:@"id"]);
//                dic[@"fitler"]    = [rs stringForColumn:@"fitler"];
//                dic[@"paramName"]   = [rs stringForColumn:@"paramName"];
//                [result addObject:dic];
//            }
//        }];
        
//        if ([SCUtilities isValidArray:result])
//        {
//            //根据key写入缓存value
//            [memoryCache setObject:result forKey:sql ];
//            resultCache = result;
//        }
    }
    
    if(![SCUtilities isValidArray:resultCache])
    {// 数据库中没有说明不受限制
        return param;
    }
    
    for (NSDictionary *dic in resultCache)
    {
        if ([SCUtilities isValidDictionary:dic])
        {
            NSString* paramNamedb = dic[@"paramName"];
            if([paramNamedb isEqualToString:paramName])
            {
                NSString* fitlerUrl = dic[@"fitler"];
                NSArray* fitlerArray = [fitlerUrl componentsSeparatedByString:@","];
                if ([SCUtilities isValidArray:fitlerArray])
                {
                    for (NSString* url in fitlerArray)
                    {
                        if( [currentUrl containsString:url] )
                        {
                            return param;
                        }
                    }
                }
                break;
            }
        }
    }
    
    return @"";
}


//+(NSString *)getUnifyAuthToken:(NSString *)name{
//
//    
//    NSString *authToken = @"";
//    
////    authToken = [SCShoppingManager sharedInstance].authToken;
////
////    if (![SCUtilities isValidString:authToken]) {
////    }
//    NSString *s = [SCUserInfo currentUser].cmtokenid;
//    return s;
//        NSHTTPCookie *cookie;
//        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//        for (cookie in [storage cookies])
//        {
//            //        NSLog(@"%@: %@", cookie.name, cookie.value);
//            if([SCUtilities isValidString:cookie.name]
//               && [cookie.name isEqualToString:name])
//            {
//                authToken = [SCUtilities isValidString:cookie.value]? cookie.value : @"";
//                break;
//            }
//        }
//                
//    if ([SCUtilities isValidString:name] && [name isEqualToString:@"cmtokenid"]) {
//        return @"BFDD8AA9168E4D3C9418D71F76C3CE07@js.ac.10086.cn";
//    }
//    
//    
//    NSLog(@"--scsc--scAuthToken-- %@=%@",name,authToken);
//    
//    return authToken;
//}

+ (void)scXWMobStatMgrStr:(NSString *)coding url:(NSString *)url inPage:(NSString *)className
{
    SCShoppingManager *manager = [SCShoppingManager sharedInstance];
    
    if ([manager.delegate respondsToSelector:@selector(scXWMobStatMgrStr:url:inPage:)]) {
        [manager.delegate scXWMobStatMgrStr:coding url:url inPage:className];
    }
}

//拨打电话
+ (void)call:(NSString *)phoneNum
{
    if (!VALID_STRING(phoneNum)) {
        return;
    }
    
    UIWebView * callWebview = [[UIWebView alloc] init];
    
    NSString *phoneStr = [NSString stringWithFormat:@"tel:%@",phoneNum];

    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phoneStr]]];

    [[UIApplication sharedApplication].keyWindow addSubview:callWebview];

}


+ (void)postLoginSuccessNotification //登录成功
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:SCNOTI_LOGIN_SUCCESS object:nil];
    //商城内部webView的通知H5登陆成功刷新页面，如果
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ocCallBackJsFunction" object:@{@"name":@"ztLoginCallBack"}];
}

//+ (void)postLoginOutNotification     //退出登录
//{
//    [[NSNotificationCenter defaultCenter] postNotificationName:SCNOTI_LOGIN_OUT object:nil];
//}

@end
