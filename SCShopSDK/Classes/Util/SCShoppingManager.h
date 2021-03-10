//
//  SCShoppingManager.h
//  shopping
//
//  Created by gejunyu on 2020/7/3.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

typedef NS_ENUM(NSInteger, SCShopMoreType) {
    SCShopMoreTypeMessage, //消息
    SCShopMoreTypeSuggest, //意见
};

NS_ASSUME_NONNULL_BEGIN

//登录回调接口  controller 掌厅登录页
typedef void (^SC_loginWithBlock)(UIViewController *controller);
//首页触点数据回调
typedef void (^SC_ADTouchDataBlock)(id touchData);
//搜索回调接口
typedef void (^SC_SearchBlock)(NSDictionary * _Nullable result,  NSString * _Nullable errorMsg);


@protocol SCShoppingDelegate <NSObject>

@optional
//登录
- (void)scLoginWithNav:(UINavigationController *)nav back:(SC_loginWithBlock)callBack;
//配置cookie
- (void)scConfigCookiesWithUrl:(NSMutableURLRequest *)request wkweb:(WKWebView *)web;
//大数据插码
- (void)scXWMobStatMgrStr:(NSString *)coding url:(NSString *)url inPage:(NSString *)className;

//触点
//获取触点数据
-(void)scADTouchDataFrom:(UIViewController *)viewController backData:(SC_ADTouchDataBlock)callBack;
//处理触点点击
-(void)scADTouchClick:(NSDictionary *)dic;
//触点曝光处理
-(void)scADTouchShow:(NSDictionary *)dic;

//搜索
- (void)scSearch:(NSString *)text backData:(SC_SearchBlock)callBack;
//web
- (void)scWebWithUrl:(NSString *)urlStr title:(NSString *)title nav:(UINavigationController *)nav;
//更多选项
- (void)scMoreSelect:(SCShopMoreType)type nav:(UINavigationController *)nav;

@required
//获取用户信息
- (NSDictionary *)scGetUserInfo;
//获取定位
- (NSDictionary *)scGetLocationInfo;


@end

@interface SCShoppingManager : NSObject

@property (nonatomic, weak) id <SCShoppingDelegate> delegate;

+ (instancetype)sharedInstance;

//首页
+ (UINavigationController *)homePage;


//打开接口日志打印 默认关闭 只测试用
+ (void)openNetworkLog;



@end

NS_ASSUME_NONNULL_END
