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

//首页触点数据回调
typedef void (^SC_ADTouchDataBlock)(_Nullable id touchData,  NSString * _Nullable  error);
//搜索回调接口
typedef void (^SC_SearchBlock)(NSDictionary * _Nullable result,  NSString * _Nullable errorMsg);


@protocol SCShoppingDelegate <NSObject>

@optional
//登录
- (void)scLoginWithNav:(UINavigationController *)nav back:(void (^)(void))callBack;
//配置cookie
- (void)scConfigCookiesWithUrl:(NSMutableURLRequest *)request wkweb:(WKWebView *)web;
//大数据插码
- (void)scXWMobStatMgrStr:(NSString *)coding url:(NSString *)url inPage:(NSString *)className;
//触点
//获取触点数据
- (void)scADTouchData:(SC_ADTouchDataBlock)callBack;
//处理触点点击
- (void)scADTouchClick:(NSDictionary *)dic;
//触点曝光处理
- (void)scADTouchShow:(NSDictionary *)dic;

//搜索
- (void)scSearch:(NSString *)text backData:(SC_SearchBlock)callBack;
//掌厅页面
- (void)scJsmccPage:(NSString *)urlStr title:(NSString *)title nav:(UINavigationController *)nav;
//更多选项
- (void)scMoreSelect:(SCShopMoreType)type nav:(UINavigationController *)nav;
//时长统计
- (void)scPageStart:(UIViewController *)controller loadPageName:(NSString *)loadPageName;
- (void)scPageEnd:(UIViewController *)controller errorMessage:(NSString *)errorMessage;

//debug功能，查看商城请求日志
- (void)scNetworkLog:(NSString *)requestNum responseObject:(id)responseObject error:(NSError *)error;

//回调定位信息
- (void)scLocationInfoWithLogintude:(NSString *)longitude latitude:(NSString *)latitude city:(NSString *)city cityCode:(NSString *)cityCode locationAddress:(NSString *)locationAddress timestamp:(NSDate *)timestamp;

@required
//获取用户信息
- (NSDictionary *)scGetUserInfo;


@end

@interface SCShoppingManager : NSObject

@property (nonatomic, weak) id <SCShoppingDelegate> delegate;

+ (instancetype)sharedInstance;

//首页
+ (UINavigationController *)homePage;


@end

NS_ASSUME_NONNULL_END
