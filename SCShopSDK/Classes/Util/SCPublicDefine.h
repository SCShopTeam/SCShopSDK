//
//  SCPublicDefine.h
//  shopping
//
//  Created by gejunyu on 2020/7/3.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#ifndef SCPublicDefine_h
#define SCPublicDefine_h


#pragma mark -屏幕尺寸相关
#define SCREEN_WIDTH          [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT         [[UIScreen mainScreen] bounds].size.height
#define SCREEN_FIX(P)         ((float)floor((SCREEN_WIDTH * P) / 375.0))
//#define SCREEN_SAFE_BOTTOM    [UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom

#define STATUS_BAR_HEIGHT     [UIApplication sharedApplication].statusBarFrame.size.height
#define NAV_BAR_HEIGHT        (STATUS_BAR_HEIGHT + 44.f)
//是否是X之后的异形屏
#define IsIPhoneXLater        (STATUS_BAR_HEIGHT >= 44?YES:NO)
#define SCREEN_SAFE_BOTTOM    (IsIPhoneXLater ? 34.f : 0.f)
#define TAB_BAR_HEIGHT        (SCREEN_SAFE_BOTTOM + 49.f)


#pragma mark -版本/机型相关
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define ISIOS11 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)


#define IsIPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#pragma mark - 常用
//默认图片
#define  IMG_PLACE_HOLDER   SCIMAGE(@"home_localLife_newsDefault")

//单例
#undef  AS_SINGLETON
#define AS_SINGLETON( __class ) \
- (__class *)sharedInstance; \
+ (__class *)sharedInstance;

#undef DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
- (__class *)sharedInstance \
{ \
  return [__class sharedInstance]; \
} \
+ (__class *)sharedInstance \
{ \
  static dispatch_once_t once; \
  static __class * __singleton__; \
  dispatch_once( &once, ^{ __singleton__ = [[[self class] alloc] init]; } ); \
  return __singleton__; \
}

///-----------------
/// 打印日志定义
///-----------------
#ifdef DEBUG
//#  define NSLog(format, ...) NSLog((@"[函数名:%s]" "[行号:%d]" format), __FUNCTION__, __LINE__, ##__VA_ARGS__); //sdk对外使用,内部api不需要暴露
#else
#  define NSLog(...) nil;
#endif

//数据库
#define SC_COMMON_SQLITE     @"SC_SHOP.sqlite"

//字体
#define SCFONT_SIZED(fontSize)                 [UIFont systemFontOfSize:fontSize]
#define SCFONT_BOLD_SIZED(fontSize)            [UIFont boldSystemFontOfSize:fontSize]
#define SCFONT_NAME_SIZED(fontName, fontSize)  [UIFont fontWithName:fontName size:fontSize]
//自适应大小
#define SCFONT_SIZED_FIX(fontSize)             [UIFont systemFontOfSize:SCREEN_FIX(fontSize)]
#define SCFONT_BOLD_SIZED_FIX(fontSize)        [UIFont boldSystemFontOfSize:SCREEN_FIX(fontSize)]


#define m6Scale (SCREEN_WIDTH/750)

#define APPVER
#ifdef APPVER
// 获取APP带4位版本号  可带4位版本号
#define SYS_CLIENTVER  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"sys-clientVersion"]
#else
// 获取APP3位大版本
#define SYS_CLIENTVER  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#endif

//
#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]


#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif


//通知
#define SCNOTI_LOGIN_SUCCESS            @"SCNOTI_LOGIN_SUCCESS"
#define SCNOTI_LOGIN_OUT                @"SCNOTI_LOGIN_OUT"
#define SCNOTI_HOME_CELL_CAN_SCROLL     @"SCNOTI_HOME_CELL_CAN_SCROLL"
#define SCNOTI_HOME_TABLE_CAN_SCROLL    @"SCNOTI_HOME_TABLE_CAN_SCROLL"
#define SCNOTI_STORE_SCROLL_CAN_SCROLL  @"SCNOTI_STORE_SCROLL_CAN_SCROLL"
#define SCNOTI_STORE_CELL_CAN_SCROLL    @"SCNOTI_STORE_CELL_CAN_SCROLL"

#endif /* SCPublicDefine_h */
