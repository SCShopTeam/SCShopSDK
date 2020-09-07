//
//  SCWebView.m
//  ecmc
//
//  Created by gaoleyu on 16/11/28.
//  Copyright (c) 2016年 IMY. All rights reserved.
//

#import "SCWebView.h"

//#import "ECMCWebViewProgress.h"
#import <TargetConditionals.h>
#import <WebKit/WebKit.h>
#import <dlfcn.h>
#import "SCWKWebViewManager.h"
#import "WKWebView + SupportProtocol.h"
#import "SCUserInfo.h"
#import "SCWebViewCustom.h"
#import "WKWebView + SafeClearCache.h"
#import "WebViewJavascriptBridgeBase.h"
#import "SCShoppingManager.h"
#define WeakSelf __weak __typeof(&*self)weakSelf =self

@interface SCWebView () < WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, assign) double estimatedProgress;
@property (nonatomic, strong) NSURLRequest* originRequest;
@property (nonatomic, strong) NSURLRequest* currentRequest;

@property (nonatomic, copy) NSString* title;

//@property (nonatomic, strong) ECMCWebViewProgress* njkWebViewProgress;
@end

@implementation SCWebView

@synthesize usingUIWebView = _usingUIWebView;
@synthesize realWebView = _realWebView;
@synthesize scalesPageToFit = _scalesPageToFit;

/////使用不会销毁的webview
//+ (instancetype)shareInstanceWebview
//{
//    static SCWebView *manager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        manager = [SCWebView alloc];
//    });
//    return manager;
//}

///不使用webview时候销毁内部数据源
- (void)cleanInstanceWebview
{
    
    WKWebView* webView = _realWebView;
    webView.UIDelegate = nil;
    webView.navigationDelegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [webView removeObserver:self forKeyPath:@"title"];
    //        WKHTTPCookieStore *cookieStroe = webView.configuration.websiteDataStore.httpCookieStore;
    //        [cookieStroe getAllCookies:^(NSArray<NSHTTPCookie *> * _Nonnull arry) {
    //            NSLog(@"%@",arry);
    //        }];
    
    [_realWebView removeObserver:self forKeyPath:@"loading"];
    //    [_realWebView scrollView].delegate = nil;
    //    [_realWebView stopLoading];
    [_realWebView loadHTMLString:@"" baseURL:nil];
    //    [_realWebView stopLoading];
    [_realWebView removeFromSuperview];
    _realWebView = nil;
}

- (instancetype)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _initMyself];
    }
    return self;
}
- (instancetype)init
{
    return [self initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    
    return [self initWithFrame:frame usingUIWebView:NO];
    
}

- (instancetype)initWithFrame:(CGRect)frame usingUIWebView:(BOOL)usingUIWebView
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _usingUIWebView = usingUIWebView;
        [self _initMyself];
    }
    return self;
}
- (void)_initMyself
{
    Class wkWebView = NSClassFromString(@"WKWebView");
    if (wkWebView && self.usingUIWebView == NO) {
        [self initWKWebView];
        _usingUIWebView = NO;
        _terminate = NO;
    }
    
    [self.realWebView addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:nil];
    self.scalesPageToFit = YES;
    
    [self.realWebView setFrame:self.bounds];
    [self.realWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self addSubview:self.realWebView];
}
- (void)setDelegate:(id<SCWebViewDelegate>)delegate
{
    _delegate = delegate;
    
    WKWebView* webView = self.realWebView;
    webView.UIDelegate = nil;
    webView.navigationDelegate = nil;
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
}
- (void)initWKWebView
{
    WKWebViewConfiguration* configuration = [[NSClassFromString(@"WKWebViewConfiguration") alloc] init];
    configuration.userContentController = [NSClassFromString(@"WKUserContentController") new];
    // ...
    //    configuration.dataDetectorTypes = UIDataDetectorTypeAll;
    WKPreferences* preferences = [NSClassFromString(@"WKPreferences") new];
    preferences.minimumFontSize = 10;
    preferences.javaScriptEnabled = YES;
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    configuration.allowsInlineMediaPlayback = YES;
    //    configuration.mediaPlaybackRequiresUserAction = NO;
    if (@available(iOS 10.0, *)) {
        // WKAudiovisualMediaTypeNone 音视频的播放不需要用户手势触发, 即为自动播放
        configuration.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
    } else {
        configuration.requiresUserActionForMediaPlayback = NO;
    }
    configuration.preferences = preferences;
    //wkwebview缓存池，所有webview要共用一个缓存池，所以这里使用单例
    configuration.processPool = [SCWKWebViewManager install].processPool;
    WKWebView* webView = [[NSClassFromString(@"WKWebView") alloc] initWithFrame:self.bounds configuration:configuration];
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = NO;
    
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    //    [WKWebsiteDataStore defaultDataStore].httpCookieStore;
    
    //    self.njkWebViewProgress = [[ECMCWebViewProgress alloc] init];
    //    _njkWebViewProgress.webViewProxyDelegate = self;
    //    _njkWebViewProgress.progressDelegate = self;
    
    _realWebView = webView;
}
- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.estimatedProgress = [change[NSKeyValueChangeNewKey] doubleValue];
        [self callback_updateProgress:self.estimatedProgress];
    }
    else if ([keyPath isEqualToString:@"title"]) {
        [self callback_webViewTitle:change[NSKeyValueChangeNewKey]];
    }
    else {
        [self willChangeValueForKey:keyPath];
        [self didChangeValueForKey:keyPath];
    }
}

- (void)addScriptMessageHandler:(id<WKScriptMessageHandler>)scriptMessageHandler name:(NSString *)name
{
    if (!_usingUIWebView) {
        WKWebViewConfiguration* configuration = [(WKWebView*)self.realWebView configuration];
        [configuration.userContentController addScriptMessageHandler:scriptMessageHandler name:name];
    }
}

#pragma mark - WKNavigationDelegate
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0))
{
    _terminate = YES;
    [self reload];
}

- (void)webView:(WKWebView*)webView decidePolicyForNavigationAction:(WKNavigationAction*)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
       BOOL resultBOOL = [self callback_webViewShouldStartLoadWithRequest:navigationAction.request navigationType:navigationAction.navigationType];
       BOOL isLoadingDisableScheme = [self isLoadingWKWebViewDisableScheme:navigationAction.request.URL];
       WeakSelf;
        NSString *scheme = [navigationAction.request.URL scheme];
       if ([scheme isEqualToString:@"https"] || [scheme isEqualToString:@"http"])
       {
           //简单判断host，真实App代码中，需要更精确判断itunes链接
           //处理WKWebView对跳转app store的限制
              if (([[navigationAction.request.URL host] isEqualToString:@"itunes.apple.com"]|| [[navigationAction.request.URL host] isEqualToString:@"testflight.apple.com"]) && [[UIApplication sharedApplication] openURL:navigationAction.request.URL])
              {
                  decisionHandler(WKNavigationActionPolicyCancel);
                  return;
              }

           if (@available(iOS 11.0, *)) {
              [self copyPageLoadingNSHTTPCookieStorageToWKHTTPCookieStoreWithCompletionHandler:^{
              }];
               }else
               {
                   //为了解决跨域问题，每次跳转url时把cookies拼接上
                   NSMutableURLRequest *request = (NSMutableURLRequest *)navigationAction.request;
                   NSMutableURLRequest *mutableRequest = [request mutableCopy];
                   request = [mutableRequest copy];
                   NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
                   if ([SCUtilities isValidArray:cookies])
                   {
                       NSDictionary *dict = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
                       if ([SCUtilities isValidDictionary:dict])
                       {
                           request.allHTTPHeaderFields = dict;
                       }
                   }
               }
       }
       
       NSString*urlString = [[navigationAction.request URL] absoluteString];
       
       urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
       
       if ([urlString containsString:@"weixin://wap/pay?"]) {
           if([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
               NSString *payHost = navigationAction.request.URL.host;
               NSString *payAbs = navigationAction.request.URL.absoluteString;
               NSURL *payUrl = navigationAction.request.URL.absoluteURL;
               decisionHandler(WKNavigationActionPolicyCancel);
               NSURL*url = [NSURL URLWithString:urlString];
               [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO} completionHandler:^(BOOL success) {
                   NSLog(@"...");
               }];
               return;
           }else{
               
               [[UIApplication sharedApplication]openURL:navigationAction.request.URL];
           }
       }

       
       if (resultBOOL && !isLoadingDisableScheme) {
           weakSelf.currentRequest = navigationAction.request;
           if (navigationAction.targetFrame == nil) {
               [webView loadRequest:navigationAction.request];
           }
           
           //防止一个网页多次回调造成崩溃
                 WebViewJavascriptBridgeBase *base = [[WebViewJavascriptBridgeBase alloc] init];
                 if ([base isWebViewJavascriptBridgeURL:navigationAction.request.URL]) {
                     return;
                 }
           
           decisionHandler(WKNavigationActionPolicyAllow+2);
           return;
       }
       else {
           decisionHandler(WKNavigationActionPolicyCancel);
           return;
       }
}
- (void)webView:(WKWebView*)webView didStartProvisionalNavigation:(WKNavigation*)navigation
{
    [self callback_webViewDidStartLoad];
}
- (void)webView:(WKWebView*)webView didFinishNavigation:(WKNavigation*)navigation
{
    
    if ([self.delegate respondsToSelector:@selector(webViewFinishTime:)])
    {
        [self.delegate webViewFinishTime:self];
    }
    if (@available(iOS 11.0, *))
    {
        WeakSelf;
        [self copyPageLoadingNSHTTPCookieStorageToWKHTTPCookieStoreWithCompletionHandler:^{
            [weakSelf callback_webViewDidFinishLoad];
        }];
    }else
    {
        WeakSelf;
        //取出cookie
        NSString *JSCookieString = [[SCWKWebViewManager install] getJsCookieStr];
        
        //执行js
        [webView evaluateJavaScript:JSCookieString completionHandler:^(id obj, NSError * _Nullable error) {
            [weakSelf callback_webViewDidFinishLoad];
        }];
    }
    
}

- (void)webView:(WKWebView*)webView didFailProvisionalNavigation:(WKNavigation*)navigation withError:(NSError*)error
{
    [self callback_webViewDidFailLoadWithError:error];
}
- (void)webView:(WKWebView*)webView didFailNavigation:(WKNavigation*)navigation withError:(NSError*)error
{
    [self callback_webViewDidFailLoadWithError:error];
}
//处理前端打开一个新页面的逻辑
-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    
    //假如是重新打开窗口的话
    if (!navigationAction.targetFrame.isMainFrame) {
        
        [webView loadRequest:navigationAction.request];
        
    }
    
    return nil;
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    if (@available(iOS 11.0, *)) {//iOS11也有这种获取方式，但是我使用的时候iOS11系统可以在response里面直接获取到，只有iOS12获取不到
        //        WKHTTPCookieStore *cookieStore = webView.configuration.websiteDataStore.httpCookieStore;
        //        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
        //        [cookieStore getAllCookies:^(NSArray* cookies) {
        //            [self setCookie:cookies];
        //        }];
        
        //存储session
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
        NSArray *cookies =[NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:response.URL];
        
        for (NSHTTPCookie *cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
        //        WeakSelf;
        [self copyPageLoadingNSHTTPCookieStorageToWKHTTPCookieStoreWithCompletionHandler:^{
        }];
        decisionHandler(WKNavigationResponsePolicyAllow);
    }else {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
        NSArray *cookies =[NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:response.URL];
        
        [self setCookie:cookies];
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
    
}



-(void)setCookie:(NSArray *)cookies {
    if (cookies.count > 0) {
        for (NSHTTPCookie *cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }
}

/**获取主控制器*/
- (UIViewController *)zyViewController{
    UIResponder *next = self.nextResponder;
    do{
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    }while (next!=nil);
    return nil;
}

#pragma mark - WKUIDelegate
///--  还没用到
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self.zyViewController presentViewController:alertController animated:YES completion:nil];
    
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self.zyViewController presentViewController:alertController animated:YES completion:nil];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    [self.zyViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        NSURLCredential *card = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
    }
}


#pragma mark - CALLBACK IMYVKWebView Delegate

- (void)callback_webViewDidFinishLoad
{
    if ([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.delegate webViewDidFinishLoad:self];
    }
}
- (void)callback_webViewDidStartLoad
{
    if ([self.delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.delegate webViewDidStartLoad:self];
    }
}
- (void)callback_webViewDidFailLoadWithError:(NSError*)error
{
    if ([self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.delegate webView:self didFailLoadWithError:error];
    }
}
- (BOOL)callback_webViewShouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(NSInteger)navigationType
{
    BOOL resultBOOL = YES;
    if ([self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        if (navigationType == -1) {
            navigationType = UIWebViewNavigationTypeOther;
        }
        resultBOOL = [self.delegate webView:self shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    return resultBOOL;
}

- (void)callback_updateProgress : (CGFloat)progressCount
{
    if ([self.delegate respondsToSelector:@selector(webViewProgress:updateProgress:)]) {
        NSProgress *progress = [NSProgress progressWithTotalUnitCount:100];
        [progress setCompletedUnitCount:self.estimatedProgress*100];
        [self.delegate webViewProgress:self updateProgress:progress];
    }
}

- (void)callback_webViewTitle : (NSString *)title
{
    self.title = title;
    if ([self.delegate respondsToSelector:@selector(webViewTitle:Title:)])
    {
        [self.delegate webViewTitle:self Title:title];
    }
}

#pragma mark - 基础方法
///判断当前加载的url是否是WKWebView不能打开的协议类型
- (BOOL)isLoadingWKWebViewDisableScheme:(NSURL*)url
{
    BOOL retValue = NO;
    
    //判断是否正在加载WKWebview不能识别的协议类型：phone numbers, email address, maps, etc.
    if ([url.scheme isEqualToString:@"tel"]) {
        UIApplication* app = [UIApplication sharedApplication];
        if ([app canOpenURL:url]) {
            [app openURL:url];
            retValue = YES;
        }
    }
    
    return retValue;
}

- (UIScrollView*)scrollView
{
    return [(id)self.realWebView scrollView];
}

- (id)loadRequest:(NSURLRequest*)request
{
    self.originRequest = request;
    self.currentRequest = request;
    NSMutableURLRequest *requestNew = [NSMutableURLRequest requestWithURL:request.URL];
    if(![[request.URL absoluteString] isEqualToString:@"about:blank"])
    {
        //            [self writeCurrentCookie:requestNew];
    }
    
    SCShoppingManager *manager = [SCShoppingManager sharedInstance];
    
    if (manager.delegate && [manager.delegate respondsToSelector:@selector(scConfigCookiesWithUrl:wkweb:back:)]) {
        [manager.delegate scConfigCookiesWithUrl:requestNew  wkweb:self.realWebView back:^(BOOL success) {
            NSLog(@"%@",@"--sc-- 代理设置cookie成功回调");
        }];
    }
    NSString *s = request.URL.absoluteString;
    if (ISIOS11 && [s containsString:@"wap.js.10086.cn"])
    {
        [self copyNSHTTPCookieStorageToWKHTTPCookieStoreWithCompletionHandler:^{

            dispatch_async(dispatch_get_main_queue(), ^{
                
                //                    NSMutableURLRequest *nRequest = [NSMutableURLRequest requestWithURL:requestNew.URL];
                //
                //                    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
                //                    if ([SCUtilities isValidArray:cookies])
                //                    {
                //                        NSDictionary *dict = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
                //                        if ([SCUtilities isValidDictionary:dict])
                //                        {
                //                            nRequest.allHTTPHeaderFields = dict;
                //                        }
                //                    }
                //
                
                [(WKWebView *)self.realWebView loadRequest:requestNew];
            });
        }];
    }
    else
    {// 非10086域名或不是白名单必要塞cookie不进行塞cookie操作
        [self addCookie:[request.URL absoluteString] request:request];
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        if ([SCUtilities isValidArray:cookies])
        {
            NSDictionary *dict = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
            if ([SCUtilities isValidDictionary:dict])
            {
                requestNew.allHTTPHeaderFields = dict;
            }
        }
        
        [(WKWebView *)self.realWebView loadRequest:requestNew];
    }
    
    
    
    return nil;
    
}



// 白名单加cookie
-(void)addCookie:(NSString*)urlString request:(NSURLRequest *)request
{
    if([SCUtilities isValidString:urlString]
       && ([urlString hasPrefix:@"http"] || [urlString hasPrefix:@"https"])
       && ![urlString containsString:@"wap.js.10086.cn"]){
        
        NSURL *url      = [request URL];
        
        NSLog(@"--sc-- 已登陆，设置cookie-%@",urlString);
        
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        
        NSString* cmtokenid = [SCGetAuthToken cmtokenId];
        if([SCUtilities isValidString:cmtokenid])
        {
            NSDictionary *properties = [[NSMutableDictionary alloc] init];
            [properties setValue:cmtokenid forKey:NSHTTPCookieValue];
            [properties setValue:@"cmtokenid" forKey:NSHTTPCookieName];
            [properties setValue:[url host] forKey:NSHTTPCookieDomain];
            [properties setValue:@"/" forKey:NSHTTPCookiePath];
            
            NSHTTPCookie* cookie = [NSHTTPCookie cookieWithProperties:properties];
            [storage setCookie:cookie];
            
            WKWebView* wkwebView = self.realWebView;
            
            if (@available(iOS 11.0, *)) {
                WKHTTPCookieStore *cookieStroe = wkwebView.configuration.websiteDataStore.httpCookieStore;
                [cookieStroe setCookie:cookie completionHandler:^{
                }];
            }
            
            
            NSString* userAreaNum = [SCGetAuthToken userAreaNum];
            if(![SCUtilities isValidString:userAreaNum])
            {
                userAreaNum = [SCUserInfo currentUser].uan;
            }
            NSDictionary *properties1 = [[NSMutableDictionary alloc] init];
            [properties1 setValue:userAreaNum forKey:NSHTTPCookieValue];
            [properties1 setValue:@"userAreaNum" forKey:NSHTTPCookieName];
            [properties1 setValue:[url host] forKey:NSHTTPCookieDomain];
            [properties1 setValue:@"/"forKey:NSHTTPCookiePath];
            
            NSHTTPCookie* cookie1 = [NSHTTPCookie cookieWithProperties:properties1];
            [storage setCookie:cookie1];
            
            if (@available(iOS 11.0, *))
            {
                WKHTTPCookieStore *cookieStroe = wkwebView.configuration.websiteDataStore.httpCookieStore;
                [cookieStroe setCookie:cookie1 completionHandler:^{
                }];
            }
            
            
            NSString *phone = [SCUserInfo currentUser].phoneNumber? :@"";
            NSDictionary *properties3 = [[NSMutableDictionary alloc] init];
            [properties3 setValue:phone forKey:NSHTTPCookieValue];
            [properties3 setValue:@"mallMobile" forKey:NSHTTPCookieName];
            [properties3 setValue:[url host] forKey:NSHTTPCookieDomain];
            [properties3 setValue:@"/" forKey:NSHTTPCookiePath];
           
            NSHTTPCookie* cookie3 = [NSHTTPCookie cookieWithProperties:properties3];
            [storage setCookie:cookie3];
            
            if (@available(iOS 11.0, *))
            {
                WKHTTPCookieStore *cookieStroe = wkwebView.configuration.websiteDataStore.httpCookieStore;
                [cookieStroe setCookie:cookie3 completionHandler:^{
                }];
            }
        }
    }
}

// 页面开始加载 同步一次cookie
-(void)copyNSHTTPCookieStorageToWKHTTPCookieStoreWithCompletionHandler:(nullable void (^)(void))theCompletionHandler {
     NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        if (@available(iOS 11.0, *)) {
            WKWebView* webView = _realWebView;
            WKHTTPCookieStore *cookieStroe = webView.configuration.websiteDataStore.httpCookieStore;
             [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
            if (cookies.count == 0) {
                !theCompletionHandler ?: theCompletionHandler();
                return;
            }

                NSArray *cookiesCopy =[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies] ;
                for (NSHTTPCookie *cookie in cookiesCopy) {

                    // ios12.1系统经常会不走completionHandler方法
                    [cookieStroe setCookie:cookie completionHandler:^{
                     }];
                    if ([[cookies lastObject] isEqual:cookie])
                    {
                        !theCompletionHandler ?: theCompletionHandler();
                     }
                }
            
        } else {
            // Fallback on earlier versions
             !theCompletionHandler ?: theCompletionHandler();
        }
}

// 页面加载过程或加载完成 同步一次cookie
-(void)copyPageLoadingNSHTTPCookieStorageToWKHTTPCookieStoreWithCompletionHandler:(nullable void (^)(void))theCompletionHandler {
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    if (@available(iOS 11.0, *)) {
        WKWebView* webView = _realWebView;
        WKHTTPCookieStore *cookieStroe = webView.configuration.websiteDataStore.httpCookieStore;
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
        //        if (cookies.count == 0) {
        //            !theCompletionHandler ?: theCompletionHandler();
        //            return;
        //        }
        //        NSURL *url      = [self.currentRequest URL];
        //        NSString* urlString = [url absoluteString];
        //        NSMutableArray *arraryCookie = [[NSMutableArray alloc]init];
        //        for (NSHTTPCookie *cookie in cookies)
        //        {
        //            if([urlString containsString: cookie.domain] )
        //            {
        //                [arraryCookie addObject:cookie];
        //            }
        //        }
        // WKHTTPCookieStore经过测试保持最新的cookie数据
        // 如果使用NSHTTPCookieStorage中的数据可能造成旧数据覆盖新数据的情况
        // 所以优先遍历WKHTTPCookieStore中的数据，如果有就不进行遍历设置 没有在进行设置
        [cookieStroe getAllCookies:^(NSArray<NSHTTPCookie *> * _Nonnull arry) {
            //            for(NSHTTPCookie* cookie in arry)
            //            {
            //                [cookieStroe deleteCookie:cookie completionHandler:^{
            //
            //                }];
            //            }
            //            for (NSHTTPCookie *cookie in arry) {
            //                    //NSHTTPCookie cookie
            //                    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
            //            }
            //            !theCompletionHandler ?: theCompletionHandler();
            if (arry.count == 0) {
                !theCompletionHandler ?: theCompletionHandler();
                return;
            }
            for (NSHTTPCookie *cookie in arry) {
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
                if ([[cookies lastObject] isEqual:cookie]) {
                    !theCompletionHandler ?: theCompletionHandler();
                    return;
                }
            }
            //            int i = 0;
            //            NSArray *cookiesCopy = [[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies] copy];
            //            for (NSHTTPCookie *cookie in cookiesCopy) {
            //                int isSetCookie = YES;
            //                for (NSHTTPCookie* wkcookie in arry)
            //                {
            //                    if ([cookie.name isEqualToString:wkcookie.name] && [cookie.domain isEqualToString:wkcookie.domain]) {
            //                        isSetCookie = NO;
            //                        break;
            //                    }
            //                }
            //                i++;
            //                if (isSetCookie)
            //                {
            //                     [cookieStroe setCookie:cookie completionHandler:^{
            //                                           if ([[cookies lastObject] isEqual:cookie]) {
            //                                               !theCompletionHandler ?: theCompletionHandler();
            //                                                return;
            //                                           }
            //                                       }];
            //                }
            //                else
            //                {
            //                    if (i == [cookies count] )
            //                    {
            //                        !theCompletionHandler ?: theCompletionHandler();
            //                         return;
            //                    }
            //                }
            //            }
        }];
        //        [SCWebViewCustom clearWKCookies];
        
    } else {
        // Fallback on earlier versions
        !theCompletionHandler ?: theCompletionHandler();
    }
}

- (void)writeCurrentCookie:(NSMutableURLRequest*) requestNew
{
    NSHTTPCookieStorage*cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSMutableString *cookieString = [[NSMutableString alloc] init];
    
    for (NSHTTPCookie*cookie in [cookieJar cookies]) {
        //多个字段之间用“；”隔开
        [cookieString appendFormat:@"%@=%@;",cookie.name,cookie.value];
    }
    if ([SCUtilities isValidString:cookieString])
    {
        //删除最后一个“；”
        [cookieString deleteCharactersInRange:NSMakeRange(cookieString.length - 1, 1)];
        [requestNew addValue:cookieString forHTTPHeaderField:@"Cookie"];
    }
}

- (id)loadHTMLString:(NSString*)string baseURL:(NSURL*)baseURL
{
    
    return [(WKWebView*)self.realWebView loadHTMLString:string baseURL:baseURL];
}
- (NSURLRequest*)currentRequest
{
    
    return _currentRequest;
}
- (NSURL*)URL
{
    
    return [(WKWebView*)self.realWebView URL];
}
- (BOOL)isLoading
{
    return [self.realWebView isLoading];
}
- (BOOL)canGoBack
{
    if (_usingUIWebView) {
        return [self.realWebView canGoBack];
    }
    else
    {
        WKWebView* wkwebview = (WKWebView*)self.realWebView;
        if ([wkwebview.backForwardList.backItem.URL.absoluteString caseInsensitiveCompare:@"about:blank"] == NSOrderedSame ||
            [wkwebview.URL.absoluteString isEqualToString:@"about:blank"]) {
            return NO;
        }
        
        return [self.realWebView canGoBack];
    }
}

- (BOOL)canGoForward
{
    
    WKWebView* wkwebview = (WKWebView*)self.realWebView;
    if ([wkwebview.backForwardList.forwardItem.URL.absoluteString caseInsensitiveCompare:@"about:blank"] == NSOrderedSame ||
        [wkwebview.URL.absoluteString isEqualToString:@"about:blank"]) {
        return NO;
    }
    return [self.realWebView canGoForward];
}

- (id)goBack
{
    
    return [(WKWebView*)self.realWebView goBack];
}
- (id)goForward
{
    
    return [(WKWebView*)self.realWebView goForward];
}
- (id)reload
{
    
    return [(WKWebView*)self.realWebView reload];
}
- (id)reloadFromOrigin
{
    
    return [(WKWebView*)self.realWebView reloadFromOrigin];
}
- (void)stopLoading
{
    [self.realWebView stopLoading];
}

- (void)evaluateJavaScript:(NSString*)javaScriptString completionHandler:(void (^)(id, NSError*))completionHandler
{
    
    return [(WKWebView*)self.realWebView evaluateJavaScript:javaScriptString completionHandler:completionHandler];
}
- (NSString*)stringByEvaluatingJavaScriptFromString:(NSString*)javaScriptString
{
    
    __block NSString* result = nil;
    __block BOOL isExecuted = NO;
    [(WKWebView*)self.realWebView evaluateJavaScript:javaScriptString completionHandler:^(id obj, NSError* error) {
        result = obj;
        isExecuted = YES;
    }];
    
    while (isExecuted == NO) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return result;
}
- (void)setScalesPageToFit:(BOOL)scalesPageToFit
{
    
    if (_scalesPageToFit == scalesPageToFit) {
        return;
    }
    
    WKWebView* webView = _realWebView;
    
    NSString* jScript =
    @"var head = document.getElementsByTagName('head')[0];\
    var hasViewPort = 0;\
    var metas = head.getElementsByTagName('meta');\
    for (var i = metas.length; i>=0 ; i--) {\
    var m = metas[i];\
    if (m.name == 'viewport') {\
    hasViewPort = 1;\
    break;\
    }\
    }; \
    if(hasViewPort == 0) { \
    var meta = document.createElement('meta'); \
    meta.name = 'viewport'; \
    meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'; \
    head.appendChild(meta);\
    }";
    
    WKUserContentController *userContentController = webView.configuration.userContentController;
    NSMutableArray<WKUserScript *> *array = [userContentController.userScripts mutableCopy];
    WKUserScript* fitWKUScript = nil;
    for (WKUserScript* wkUScript in array) {
        if ([wkUScript.source isEqual:jScript]) {
            fitWKUScript = wkUScript;
            break;
        }
    }
    if (scalesPageToFit) {
        if (!fitWKUScript) {
            fitWKUScript = [[NSClassFromString(@"WKUserScript") alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
            [userContentController addUserScript:fitWKUScript];
        }
    }
    else {
        if (fitWKUScript) {
            [array removeObject:fitWKUScript];
        }
        ///没法修改数组 只能移除全部 再重新添加
        [userContentController removeAllUserScripts];
        for (WKUserScript* wkUScript in array) {
            [userContentController addUserScript:wkUScript];
        }
    }
    _scalesPageToFit = scalesPageToFit;
}
- (BOOL)scalesPageToFit
{
    
    return _scalesPageToFit;
}

- (NSInteger)countOfHistory
{
    WKWebView* webView = self.realWebView;
    return webView.backForwardList.backList.count;
}
- (void)gobackWithStep:(NSInteger)step
{
    if (self.canGoBack == NO)
        return;
    
    if (step > 0) {
        NSInteger historyCount = self.countOfHistory;
        if (step >= historyCount) {
            step = historyCount - 1;
        }
        WKWebView* webView = self.realWebView;
        WKBackForwardListItem* backItem = webView.backForwardList.backList[step];
        [webView goToBackForwardListItem:backItem];
        
        
    }
    else {
        [self goBack];
    }
}
#pragma mark -  如果没有找到方法 去realWebView 中调用
- (BOOL)respondsToSelector:(SEL)aSelector
{
    BOOL hasResponds = [super respondsToSelector:aSelector];
    if (hasResponds == NO) {
        hasResponds = [self.delegate respondsToSelector:aSelector];
    }
    if (hasResponds == NO) {
        hasResponds = [self.realWebView respondsToSelector:aSelector];
    }
    return hasResponds;
}
- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature* methodSign = [super methodSignatureForSelector:selector];
    if (methodSign == nil) {
        if ([self.realWebView respondsToSelector:selector]) {
            methodSign = [self.realWebView methodSignatureForSelector:selector];
        }
        else {
            methodSign = [(id)self.delegate methodSignatureForSelector:selector];
        }
    }
    return methodSign;
}
- (void)forwardInvocation:(NSInvocation*)invocation
{
    if ([self.realWebView respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:self.realWebView];
    }
    else {
        [invocation invokeWithTarget:self.delegate];
    }
}

#pragma mark - 清理
- (void)dealloc
{
    NSLog(@"我被释放了哦！！！");
    
    WKWebView* webView = _realWebView;
    webView.UIDelegate = nil;
    webView.navigationDelegate = nil;
    
    [webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [webView removeObserver:self forKeyPath:@"title"];
    
    //        WKHTTPCookieStore *cookieStroe = webView.configuration.websiteDataStore.httpCookieStore;
    //        [cookieStroe getAllCookies:^(NSArray<NSHTTPCookie *> * _Nonnull arry) {
    //            NSLog(@"%@",arry);
    //        }];
    //持有者置为nil
    _holderObject = nil;
    [_realWebView removeObserver:self forKeyPath:@"loading"];
    [_realWebView scrollView].delegate = nil;
    [_realWebView stopLoading];
    [_realWebView loadHTMLString:@"" baseURL:nil];
    [_realWebView stopLoading];
    [_realWebView removeFromSuperview];
    _realWebView = nil;
}


#pragma mark - MSWKWebViewReuseProtocol
//即将被复用时
- (void)webViewWillReuse{
    [_realWebView useExternalNavigationDelegate];
}

//被回收
- (void)webViewEndReuse{
    _holderObject = nil;
    
    self.scrollView.delegate = nil;
    
    [self stopLoading];
    
    [_realWebView unUseExternalNavigationDelegate];
    [_realWebView setNavigationDelegate:nil];
    [_realWebView setUIDelegate:nil];
    
    //    [_realWebView clearBrowseHistory];
    [WKWebView safeClearAllCache];
    
    [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    //删除所有的回调事件
    [self evaluateJavaScript:@"JSCallBackMethodManager.removeAllCallBacks();" completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        
    }];
    
    NSLog(@"页面已经加载结束");
}
@end
