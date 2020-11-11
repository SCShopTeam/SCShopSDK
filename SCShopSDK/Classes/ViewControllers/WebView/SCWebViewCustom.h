//
//  SCWebViewCustom.h
//  ecmc
//
//  Created by My Mac on 13-1-22.
//  Copyright (c) 2013年 cp9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCBaseViewController.h"
#import "SCWebProgressLayer.h"
#import <JavaScriptCore/JavaScriptCore.h>

#import "SCWebView.h"
//#import "WebViewJavascriptBridge.h"
#import "WKWebViewJavascriptBridge.h"
@interface SCStringMethod : NSObject {
    
}
-(NSString*) subString:(NSString*)str startStr:(NSString*)startStr endStr:(NSString*)endStr;
@end

@interface SCWebViewCustom : SCBaseViewController {
	SCStringMethod					*string;
	
	UIButton						*_backButton;
    UIButton						*_shutButton;
    UIButton						*_shareButton;
	UIButton						*_fanKuiButton;
    UIButton                        *_hotServiceButton;
    UIButton                        *_moreBtn;
	UIButton						*_forwadButton;
	UIButton						*_nextButton;
	NSString						*urlString;
    UIActivityIndicatorView         *loadActivity;
    NSArray                         *originalCookies;
    SCWebProgressLayer                *_progressLayer; ///< 网页加载进度条
}

@property(nonatomic,assign) BOOL                            jsIsHiddenNav ;

@property (nonatomic,strong)SCWebView                        *myWebView;
@property (nonatomic,strong) SCStringMethod *string;
//一级页面地址
@property (nonatomic,copy) NSString *urlString;
@property (nonatomic,copy) NSString *jumps;
@property (nonatomic,strong) NSString *webViewContent;

@property (nonatomic, copy) NSString *shareString;
@property (nonatomic, copy) NSString *shareLink;
@property (nonatomic, copy) NSString *webPhoneNumber;
// js回调
@property (nonatomic, strong)JSContext *jsContext;
//分享控制器
//@property (nonatomic, strong) ShareViewController *zzdShareViewC;
// 默认不设置 为NO 设置为YES使用uiwebview
@property (nonatomic, assign)BOOL buseWebviewUI;

@property BOOL shakeDoLottery;
// 当前页面地址
@property (nonatomic, copy) NSString *currentPageUrl;

@property WKWebViewJavascriptBridge* bridge;

- (void)webViewloadRequest:(NSString*)tempUrl;

-(void)next:(id)sender;

- (void)shut:(id)sender;

// 清空localStorage
+ (void)cleanLocalStorage;

// 清除wkwebview 自身cookie
+ (void)clearWKCookies;

- (NSString *)appendParameters:(NSString *)temp;
#pragma mark --是否显示加载提示框
- (void)showloadingPrompt:(NSString *)temp;

- (void)webViewDidStartLoad:(SCWebView*)webView;
- (void)webViewDidFinishLoad:(SCWebView*)webView;
- (void)webView:(SCWebView*)webView didFailLoadWithError:(NSError*)error;
- (BOOL)webView:(SCWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(NSInteger)navigationType;
- (void)webViewProgress:(SCWebView*)webView updateProgress:(NSProgress *)progress;

//分析性能数据字典
//DNS查询耗时
//TCP链接耗时
//request请求耗时
//解析dom树耗时
//白屏时间
//dom ready时间
//dom load时间
//onload总时间
/// - Parameter dict: window.performance.timing字典
-(void)parseJSTimingDictionary:(NSString*) dictstring completionHandler:(void (^)(NSString* performanceString,NSTimeInterval onloadtiming))completionHandler;

// 同步cookie信息
- (void)copyNSHTTPCookieStorageToWKHTTPCookieStore;

//JS调用掌厅登陆，登陆成功设置cookie
-(void)loginSuccessNotifity;

@end

