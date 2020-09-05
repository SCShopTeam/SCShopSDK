//
//  MSWKWebViewPool.h
//  ecmc
//
//  Created by gaoleyu on 2019/11/29.
//  Copyright © 2019年 gaoleyu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SCWebView;

#define sckWKWebViewReuseUrlString @"kwebkit://reuse-webView"
//#define kWKWebViewReuseScheme    @"kwebkit"

@protocol SCWKebViewReuseProtocol
- (void)webViewWillReuse;
- (void)webViewEndReuse;
@end

@interface SCWKWebViewPool : NSObject

/**
 是否需要在App启动时提前准备好一个可复用的WebView,默认为YES.
 prepare=YES时,可显著优化WKWebView首次启动时间.
 prepare=NO时,不会提前初始化一个可复用的WebView.
 */
@property(nonatomic, assign) BOOL prepare;

+ (instancetype)sharedInstance;

- (__kindof SCWebView *)getReusedWebViewForHolder:(id)holder;

- (void)recycleReusedWebView:(__kindof SCWebView *)webView;

// 未加载完成的webview,此时退出
- (void)recycleReusedWebViewNotLoad:(__kindof SCWebView *)webView;

- (void)cleanReusableViews;

@end
