//
//  SCShoppingManager.h
//  shopping
//
//  Created by gejunyu on 2020/7/3.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SCShopPageType) {
    SCShopPageTypeHome,      //首页
    SCShopPageTypeCategory,  //分类
    SCShopPageTypeCart,      //购物车
    SCShopPageTypeMyOrder    //我的订单
};

typedef void(^SC_webViewBlock)(UINavigationController *nav, NSString *url);

/**
 登录回掉接口
 
 @param controller 掌厅侧实现登录接口
 */
typedef void (^SC_loginWithBlock)(UIViewController *controller);

/**
UserAgent回掉接口

 @param userAgent 掌厅ua信息
*/
typedef void(^SC_userAgentBlock)(NSString* userAgent);

/**
 获取authtoken
*/
typedef void(^SC_getAuthToken)(NSString* token);
/**
 外部设置 cookie
 */
typedef void (^SC_configCookies)(BOOL success);

/**
首页触点数据回掉
*/
typedef void(^SC_ADTouchDataBlock)(id touchData);

/**
首页触点点击回掉接口
*/
typedef void(^SC_ADTouchClickBlock)(void);

/**
搜索回调接口
*/
typedef void(^SC_SearchBlock)( NSDictionary * _Nullable result,  NSString * _Nullable errorMsg);


@protocol SCShoppingDelegate <NSObject>
//登陆成功必须回调返回
-(void)scLoginWithNav:(UINavigationController *)nav back:(SC_loginWithBlock)callBack;
-(void)scUserAgentWithUrl:(NSString *)url back:(SC_userAgentBlock)callBack;
-(void)scConfigCookiesWithUrl:(NSMutableURLRequest *)request wkweb:(WKWebView *)web back:(SC_configCookies)callBack;
-(void)scGetAuthName:(NSString *)name back:(SC_getAuthToken)callBack;
//大数据插码回调
-(void)scXWMobStatMgrStr:(NSString *)coding url:(NSString *)url inPage:(NSString *)className;


//触点
//获取触点数据
-(void)scADTouchDataWithTouchPageNum:(NSString *)pageNum backData:(SC_ADTouchDataBlock)callBack;
//处理触点点击
-(void)scADTouchClick:(NSDictionary *)dic back:(SC_ADTouchClickBlock)callback;

//搜索
- (void)scSearch:(NSString *)text backData:(SC_SearchBlock)callBack;


@end

@interface SCShoppingManager : NSObject


@property(nonatomic,assign)id <SCShoppingDelegate> delegate;

@property(nonatomic,strong)NSDictionary *userInfo;  //掌厅个人信息 赋值给 商城个人信息
//@property(nonatomic,strong)NSString *authToken;  //cmtokenid
@property (nonatomic, strong) NSDictionary *locationInfo; //定位信息

+ (instancetype)sharedInstance;


//跳转商城
+ (void)showMallPageFrom:(UIViewController *)vc;
+ (void)showMallPageFrom:(UIViewController *)vc pageType:(SCShopPageType)pageType;

//退出商城
+ (void)dissmissMallPage;

@end

NS_ASSUME_NONNULL_END
