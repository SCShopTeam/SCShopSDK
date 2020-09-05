//
//  SCWebView.h
//  ecmc
//
//  Created by gaoleyu on 16/11/28.
//  Copyright (c) 2016年 IMY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKWebViewExtensionsDef.h"
#import "SCWKWebViewPool.h"
NS_ASSUME_NONNULL_BEGIN
@protocol WKScriptMessageHandler;
@class SCWebView, JSContext;

@protocol SCWebViewDelegate <NSObject>
@optional

- (void)webViewDidStartLoad:(SCWebView*)webView;
- (void)webViewDidFinishLoad:(SCWebView*)webView;
- (void)webView:(SCWebView*)webView didFailLoadWithError:(NSError*)error;
- (BOOL)webView:(SCWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(NSInteger)navigationType;
- (void)webViewProgress:(SCWebView*)webView updateProgress:(NSProgress *)progress;
- (void)webViewTitle:(SCWebView*)webView Title:(NSString *)title;
- (void)webViewFinishTime:(SCWebView*)webView;
@end

///无缝切换UIWebView   会根据系统版本自动选择 使用WKWebView 还是  UIWebView
@interface SCWebView : UIView<SCWKebViewReuseProtocol>

@property(nonatomic, weak, readwrite) id holderObject;
@property (nonatomic, assign) BOOL                   terminate;                  //WebView是否异常终止
///使用不会销毁的webview
//+ (instancetype)shareInstanceWebview;

///不使用webview时候销毁内部数据源
- (void)cleanInstanceWebview;

///使用UIWebView
- (instancetype)initWithFrame:(CGRect)frame usingUIWebView:(BOOL)usingUIWebView;

///会转接 WKUIDelegate，WKNavigationDelegate 内部未实现的回调。
@property (weak, nonatomic) id<SCWebViewDelegate> delegate;

///内部使用的webView
@property (nonatomic, strong) WKWebView *realWebView;
///是否正在使用 UIWebView
@property (nonatomic, assign) BOOL usingUIWebView;
///预估网页加载进度
@property (nonatomic, readonly) double estimatedProgress;

@property (nonatomic, readonly) NSURLRequest* originRequest;

///只有ios7以上的UIWebView才能获取到，WKWebView 请使用下面的方法.
@property (nonatomic, readonly) JSContext* jsContext;

/**
 网页销毁结束时间
 */
@property (nonatomic, assign) NSTimeInterval endTime;

///WKWebView 跟网页进行交互的方法。
- (void)addScriptMessageHandler:(id<WKScriptMessageHandler>)scriptMessageHandler name:(NSString*)name;

///back 层数
- (NSInteger)countOfHistory;
- (void)gobackWithStep:(NSInteger)step;

///---- UI 或者 WK 的API
@property (nonatomic, readonly) UIScrollView* scrollView;

- (id)loadRequest:(NSURLRequest*)request;
- (id)loadHTMLString:(NSString*)string baseURL:(NSURL*)baseURL;

@property (nonatomic, readonly, copy) NSString* title;
@property (nonatomic, readonly) NSURLRequest* currentRequest;
@property (nonatomic, readonly) NSURL* URL;

@property (nonatomic, readonly, getter=isLoading) BOOL loading;
@property (nonatomic, readonly) BOOL canGoBack;
@property (nonatomic, readonly) BOOL canGoForward;

- (id)goBack;
- (id)goForward;
- (id)reload;
- (id)reloadFromOrigin;
- (void)stopLoading;

- (void)evaluateJavaScript:(NSString*)javaScriptString completionHandler:(void (^)(id, NSError*))completionHandler;
///不建议使用这个办法  因为会在内部等待webView 的执行结果
- (NSString*)stringByEvaluatingJavaScriptFromString:(NSString*)javaScriptString __deprecated_msg("Method deprecated. Use [evaluateJavaScript:completionHandler:]");

// 拷贝cookie数据
-(void)copyNSHTTPCookieStorageToWKHTTPCookieStoreWithCompletionHandler:(nullable void (^)(void))theCompletionHandler;
///是否根据视图大小来缩放页面  默认为YES
@property (nonatomic) BOOL scalesPageToFit;

@end
NS_ASSUME_NONNULL_END
