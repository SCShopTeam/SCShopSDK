//
//  SCWebViewController.m
//  shopping
//
//  Created by zhangtao on 2020/9/1.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCWebViewController.h"
#import "SCUtilities.h"
#import <WebKit/WebKit.h>
#import "SCURLSerialization.h"
#import "WKWebViewJavascriptBridge.h"
#import "SCWebViewController+JSCallBack.h"
#import "SCShoppingManager.h"
@interface SCWebViewController ()<WKUIDelegate,WKNavigationDelegate>
@property(nonatomic,strong)WKWebView *webV;
@property(nonatomic,strong)NSString *cookieStr;
@property(nonatomic,strong)NSArray *cookieArray;
@property(nonatomic,strong)UIButton *backButton;
@property(nonatomic,strong)UIButton *shutButton;

@property(nonatomic,strong)NSMutableURLRequest *currentRequest;

@end

@implementation SCWebViewController

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (self.jsIsHiddenNav) {
        //        self.myWebView.frame = CGRectMake(self.myWebView.frame.origin.x,
        //                                          self.myWebView.frame.origin.y,
        //                                          CGRectGetWidth(self.myWebView.frame),
        //                                          CGRectGetHeight(self.view.frame)-STATUS_BAR_HEIGHT);
        self.webV.frame = CGRectMake(0,STATUS_BAR_HEIGHT,CGRectGetWidth(self.view.bounds),CGRectGetHeight(self.view.bounds)-STATUS_BAR_HEIGHT);
        
    }else{
        self.webV.frame = CGRectMake(0,0,CGRectGetWidth(self.view.bounds),CGRectGetHeight(self.view.bounds));
        
        //        self.myWebView.frame = CGRectMake(self.myWebView.frame.origin.x,
        //                                          self.myWebView.frame.origin.y,
        //                                          CGRectGetWidth(self.myWebView.frame),
        //                                          CGRectGetHeight(self.view.frame));
    }
    
    
}

#pragma mark --登陆成功通知
-(void)loginSuccessNotifity{
    NSLog(@"--sc-- 重新加载request");
    //    [self configCookieAndRequestWithUrl:self.urlString];
    //    [self webViewloadRequest:_currentRequest];
}

//-(void)changeUrl{
//
//    if ([_urlString containsString:@"wap.js.10086.cn"]) {
//
//        //http://122.51.195.231:8082/b2c/pages/goodsDetails.html?categoryNum=pd9l#   http://122.51.195.231:8082/b2c/pages/daySale.html
//        NSArray *arr = [self.urlString componentsSeparatedByString:@"/pages/"];
//        NSString *nUrl = [@"http://122.51.195.231:8082/b2c/pages/" stringByAppendingString:arr.lastObject];
//        self.urlString = nUrl;
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ocCallBackJsFunc:) name:@"ocCallBackJsFunction" object:nil];
    //    [self changeUrl];
    
    
    _backButton         = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame   = CGRectMake(0, 0, 50, 40);
    [_backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_backButton setImage:SCIMAGE(@"SCWebViewCustom_back") forState:UIControlStateNormal];
    [_backButton setTitle:@"返回" forState:UIControlStateNormal];
    _backButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_backButton setTitleColor:HEX_RGB(@"018ed5") forState:UIControlStateNormal];
    _backButton.imageView.contentMode = UIViewContentModeScaleToFill;
    [_backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    [_backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [_backButton addTarget:self action:@selector(next:)
          forControlEvents:UIControlEventTouchUpInside];
    
    _shutButton         = [UIButton buttonWithType:UIButtonTypeCustom];
    _shutButton.frame   = CGRectMake(48, (49-21)/2, 20, 40);
    //    [_shutButton setBackgroundImage:[UIImage imageNamed:@"WebViewCustom_shut"]
    //                           forState:UIControlStateNormal];
    [_shutButton setTitle:@"关闭" forState:UIControlStateNormal];
    [_shutButton setTitleColor:HEX_RGB(@"018ed5") forState:UIControlStateNormal];
    _shutButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_shutButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -8 ,0, 0)];
    [_shutButton addTarget:self action:@selector(shut:)
          forControlEvents:UIControlEventTouchUpInside];
    [self creatLeftButtonBack];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.cookieStr = @"navigator.userAgent";
    [self.view addSubview:self.webV];
    
    self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webV];
    [_bridge setWebViewDelegate:self];
    
    [self configCookieAndRequestWithUrl:_urlString];
    
    //    [self webViewloadRequest:self.currentRequest];
    
    [self jsCallBackOCFunc];
    
    [self configUserAgent];
}

-(void)configUserAgent{
    SCShoppingManager *manager = [SCShoppingManager sharedInstance];
    if (manager.delegate && [manager.delegate respondsToSelector:@selector(scUserAgentWithUrl:back:)]) {
        [manager.delegate scUserAgentWithUrl:self.urlString back:^(NSString * _Nonnull userAgent) {
            self.webV.customUserAgent = userAgent;
        }];
    }else{
        [self.webV evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            WKWebView* wkWebview = self.webV;
            NSString *oldUA = result;
            NSString *newUA =[NSString stringWithFormat:@"%@ Jsmcc/1.0 %@", oldUA, [SCUtilities suffixParameters:self.urlString]];
            wkWebview.customUserAgent = newUA;
        }];
    }
}

-(void)webViewloadRequest:(NSURLRequest *)request{
    
    [self.webV loadRequest:request];
}

- (void)creatLeftButtonBack{
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    NSArray *leftButtonItems = @[backItem];
    self.navigationItem.leftBarButtonItems = leftButtonItems;
}

- (void)creatLeftButtonBackAndClose{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    UIBarButtonItem *shutItem = [[UIBarButtonItem alloc] initWithCustomView:_shutButton];
    NSArray *leftButtonItems = @[backItem,shutItem];
    self.navigationItem.leftBarButtonItems = leftButtonItems;
}

-(WKWebView*)webV{
    if (_webV==nil) {
        WKWebViewConfiguration *configuration=[[WKWebViewConfiguration alloc]init];
        // 设置偏好设置
        configuration.preferences = [[WKPreferences alloc] init];
        configuration.preferences.minimumFontSize = 10;
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        // 默认认为YES
        configuration.preferences.javaScriptEnabled = YES;
        configuration.userContentController = [[WKUserContentController alloc] init];
        configuration.allowsInlineMediaPlayback = YES;
        
        // web内容处理池
        configuration.processPool = [[WKProcessPool alloc] init];
        
        //        LHX20181206 设定UserKey_cookie
        
        //
        WKUserContentController* userContentController = WKUserContentController.new;
        
        //这里注入cookie。所有的cookie拼接成一个字符串。用分号和换行符隔开,如下：
        
        
        WKUserScript * cookieScript = [[WKUserScript alloc] initWithSource: [self jsCriptStr] injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        
        [userContentController addUserScript:cookieScript];
        
        configuration.userContentController = userContentController;
        
        _webV= [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-NAV_BAR_HEIGHT) configuration:configuration];
        if (@available(iOS 11.0, *)) {
            self.webV.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        
        
        _webV.UIDelegate = self;
        _webV.navigationDelegate = self;
        _webV.allowsBackForwardNavigationGestures = YES;
        
    }
    
    return _webV;
}


-(void)configCookieAndRequestWithUrl:(NSString *)urlStr{
    
    //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    if ([urlStr containsString:@"wap.js.10086.cn"]  && ISIOS11) {
        
        NSString *s = urlStr;
        
        NSURL *url = [NSURL URLWithString:s];
        

        NSString *phone = [SCGetAuthToken mallPhone];
        NSDictionary *properties2 = [[NSMutableDictionary alloc] init];
        [properties2 setValue:phone forKey:NSHTTPCookieValue];
        [properties2 setValue:@"mallMobile" forKey:NSHTTPCookieName];
        [properties2 setValue:[url host] forKey:NSHTTPCookieDomain];
        [properties2 setValue:@"/" forKey:NSHTTPCookiePath];
        NSHTTPCookie *cookie2 = [NSHTTPCookie cookieWithProperties:properties2];
        
        NSArray *arrCookies = [NSArray arrayWithObjects:cookie2, nil];
        
        self.cookieArray = arrCookies;//////
        NSDictionary *dictCookies = [NSHTTPCookie requestHeaderFieldsWithCookies:arrCookies];//将cookie设置到头中
        //
        NSMutableURLRequest *nRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
        [nRequest setValue: [dictCookies objectForKey:@"Cookie"] forHTTPHeaderField: @"Cookie"];
        
        self.currentRequest = nRequest;
        
//        if (@available(iOS 11.0, *)){
//            WKHTTPCookieStore *cookieStroe = self.webV.configuration.websiteDataStore.httpCookieStore;
//            [cookieStroe setCookie:cookie2 completionHandler:^{
//            }];
//        }else{
//            for (NSHTTPCookie *dCookie in self.cookieArray) {
//                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:dCookie];
//            }
//        }
        
        
        __block typeof(_currentRequest) bkRequest = self.currentRequest;
        
        
        [self copyNSHTTPCookieStorageToWKHTTPCookieStoreWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self webViewloadRequest:bkRequest];
            });
        }];
        
    }else{
        NSString *s = urlStr;
        NSURL *url = [NSURL URLWithString:s];
        
        NSString *cmtokenid = [SCGetAuthToken cmtokenId];
        NSDictionary *properties = [[NSMutableDictionary alloc] init];
        [properties setValue:cmtokenid forKey:NSHTTPCookieValue];
        [properties setValue:@"cmtokenid" forKey:NSHTTPCookieName];
        
        [properties setValue:[url host] forKey:NSHTTPCookieDomain];
        [properties setValue:@"/" forKey:NSHTTPCookiePath];
        
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:properties];
        
        NSString *userAreaNum =  [SCGetAuthToken userAreaNum];
        if(![SCUtilities isValidString:userAreaNum])
        {
            userAreaNum = [SCUserInfo currentUser].uan;
        }
        NSDictionary *properties1 = [[NSMutableDictionary alloc] init];
        [properties1 setValue:[SCUtilities isValidString:userAreaNum]?userAreaNum:@"" forKey:NSHTTPCookieValue];
        [properties1 setValue:@"userAreaNum" forKey:NSHTTPCookieName];
        [properties1 setValue:[url host] forKey:NSHTTPCookieDomain];
        [properties1 setValue:@"/"forKey:NSHTTPCookiePath];
        NSHTTPCookie *cookie1 = [NSHTTPCookie cookieWithProperties:properties1];
        
        
        NSString *phone = [SCUserInfo currentUser].phoneNumber? :@"";
        NSDictionary *properties2 = [[NSMutableDictionary alloc] init];
        [properties2 setValue:phone forKey:NSHTTPCookieValue];
        [properties2 setValue:@"mallMobile" forKey:NSHTTPCookieName];
        [properties2 setValue:[url host] forKey:NSHTTPCookieDomain];
        [properties2 setValue:@"/" forKey:NSHTTPCookiePath];
        NSHTTPCookie *cookie2 = [NSHTTPCookie cookieWithProperties:properties2];
        
        NSArray *arrCookies = [NSArray arrayWithObjects: cookie, cookie1,cookie2, nil];
        self.cookieArray = arrCookies;//////
        NSDictionary *dictCookies = [NSHTTPCookie requestHeaderFieldsWithCookies:arrCookies];//将cookie设置到头中
        //
        NSMutableURLRequest *nRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
        [nRequest setValue: [dictCookies objectForKey:@"Cookie"] forHTTPHeaderField: @"Cookie"];
        self.cookieStr=@"".mutableCopy;
        if (self.cookieArray) {
            for (NSHTTPCookie*cookie in self.cookieArray) {
                self.cookieStr = [self.cookieStr stringByAppendingFormat:@"Cookie = '%@=%@';\n",cookie.name,cookie.value];
            }
        }
        
        if (@available(iOS 11.0, *)){
            WKHTTPCookieStore *cookieStroe = self.webV.configuration.websiteDataStore.httpCookieStore;
            [cookieStroe setCookie:cookie2 completionHandler:^{
            }];
        }else{
            for (NSHTTPCookie *dCookie in self.cookieArray) {
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:dCookie];
            }
        }
        
        self.currentRequest = nRequest;
        [self webViewloadRequest:self.currentRequest];
        
    }
    
    
}

//嵌套对象转为纯字符串
-(NSString*)changeDicArrayToString:(NSArray<NSDictionary*>*)array{
    
    NSMutableArray*mutiArray=@[].mutableCopy;
    for (NSDictionary*dic in array) {
        NSMutableDictionary*mutiDic=[NSMutableDictionary dictionaryWithDictionary:dic];
        mutiDic[@"name"]=[mutiDic[@"name"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [mutiArray addObject:mutiDic];
    }
    
    NSData*data=[NSJSONSerialization dataWithJSONObject:mutiArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString*jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonStr];
    NSRange range = {0,jsonStr.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    
    return mutStr;
    
    
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"--sc--didFinishNavigation--callback H5");
    //    [[NSNotificationCenter defaultCenter]postNotificationName:@"ocCallBackJsFunction" object:@{@"name":@"scSetToken"}];
    //    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    [webView safeAsyncEvaluateJavaScriptString:@"document.title" completionBlock:^(NSObject *result) {
        
        NSString *title = [NSString stringWithFormat:@"%@",result];
        if ([SCUtilities isValidString:title]) {
            self.title = title;
        }
    }];
    if (@available(iOS 11.0, *))
    {
        [self copyPageLoadingNSHTTPCookieStorageToWKHTTPCookieStoreWithCompletionHandler:^{
        }];
    }else {
        
        [webView evaluateJavaScript:self.cookieStr completionHandler:^(id result, NSError *error) {
        }];
    }
    
}

//重定向时，重新注入，防止cookie被抹掉

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSLog(@"%s/n",__FUNCTION__);
    
    NSURL *url = navigationAction.request.URL;
    NSString *host = url.host;
    NSString* scheme = [url scheme];
    NSString *absoluteString = url.absoluteString;
    
    NSString*str=[navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    
    if ([scheme isEqualToString:@"weixin"] && [absoluteString containsString:@"weixin://wap/pay?"]) {
        if([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            
            decisionHandler(WKNavigationActionPolicyCancel);
            NSURL*url = [NSURL URLWithString:absoluteString];
            [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO} completionHandler:^(BOOL success) {
                NSLog(@"...");
            }];
            return;
        }else{
            
            [[UIApplication sharedApplication]openURL:navigationAction.request.URL];
        }
    } else if (![scheme containsString:@"http"] && ![scheme containsString:@"https"]) {
        // 拦截点击链接
        [[SCURLSerialization shareSerialization] gotoController:str navigation:self.navigationController];
        // 不允许跳转
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }else{
        //简单判断host，真实App代码中，需要更精确判断itunes链接
        //处理WKWebView对跳转app store的限制
        if (([[navigationAction.request.URL host] isEqualToString:@"itunes.apple.com"]|| [[navigationAction.request.URL host] isEqualToString:@"testflight.apple.com"]) && [[UIApplication sharedApplication] openURL:navigationAction.request.URL])
        {
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
        
    }
    
    //防止一个网页多次回调造成崩溃
    WebViewJavascriptBridgeBase *base = [[WebViewJavascriptBridgeBase alloc] init];
    if ([base isWebViewJavascriptBridgeURL:navigationAction.request.URL]) {
        return;
    }
    
    
    if (ISIOS11 && [absoluteString containsString:@"wap.js.10086.cn"]) {
        decisionHandler(WKNavigationActionPolicyAllow);
    }else{
        
        
        SCShoppingManager *manager = [SCShoppingManager sharedInstance];
        NSMutableURLRequest *request = (NSMutableURLRequest *)navigationAction.request;
        if (manager.delegate && [manager.delegate respondsToSelector:@selector(scConfigCookiesWithUrl:wkweb:back:)]) {
            [manager.delegate scConfigCookiesWithUrl:request  wkweb:self.webV back:^(BOOL success) {
                NSLog(@"%@",@"--sc-- 代理设置cookie成功回调");
                decisionHandler(WKNavigationActionPolicyAllow);
                
            }];
        }else{
            //    BOOL isNavigator = YES;
            //   ，再次添加cookie保证每次跳转页面，都能获取到此cookie。三个参数
            NSString *s = self.cookieStr;
            [webView evaluateJavaScript:self.cookieStr completionHandler:^(id result, NSError *error) {
                NSLog(@"cookie-------%@",result);
                decisionHandler(WKNavigationActionPolicyAllow);
            }];
        }
    }
    
    //    if ([absoluteString containsString:@"weixin://wap/pay?"]) {
    //           if([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
    //
    //               decisionHandler(WKNavigationActionPolicyCancel);
    //               NSURL*url = [NSURL URLWithString:absoluteString];
    //               [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO} completionHandler:^(BOOL success) {
    //                   NSLog(@"...");
    //               }];
    //               return;
    //           }else{
    //
    //               [[UIApplication sharedApplication]openURL:navigationAction.request.URL];
    //           }
    //       }
    
    
    //    if (@available(iOS 11.0, *)) {
    //
    //    }else{
    //        //为了解决跨域问题，每次跳转url时把cookies拼接上
    //        NSMutableURLRequest *request = (NSMutableURLRequest *)navigationAction.request;
    //        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    //        if ([SCUtilities isValidArray:cookies])
    //        {
    //            NSDictionary *dict = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    //            if ([SCUtilities isValidDictionary:dict])
    //            {
    //                request.allHTTPHeaderFields = dict;
    //            }
    //        }
    //    }
    
    
    
    
}

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

-(void)next:(id)sender
{
    if ([self.webV.URL.absoluteString isEqualToString:self.urlString] ) {
        
        __block BOOL isVueUrl = NO;
        
        if (!isVueUrl) {
            [self clearResource];
            
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    [self.webV goBack];
    if (![self.webV canGoBack])
    {
        [self clearResource];
        [self.navigationController popViewControllerAnimated:YES];
        // 取消head头部注册
    }else{
        //创建关闭和返回按钮
        [self creatLeftButtonBackAndClose];
    }
}

- (void)shut:(id)sender
{
    [self clearResource];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) clearResource
{
    [_bridge setWebViewDelegate:nil];
    _bridge = nil;
    //释放webView
    [self.webV stopLoading];
    //    self.webV.delegate = nil;
    self.webV = nil;
    _urlString = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


// 页面开始加载 同步一次cookie
-(void)copyNSHTTPCookieStorageToWKHTTPCookieStoreWithCompletionHandler:(nullable void (^)())theCompletionHandler {
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    if (@available(iOS 11.0, *)) {
        WKWebView* webView = self.webV;
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
        !theCompletionHandler ?: theCompletionHandler();
    }
}


// 页面加载过程或加载完成 同步一次cookie
-(void)copyPageLoadingNSHTTPCookieStorageToWKHTTPCookieStoreWithCompletionHandler:(nullable void (^)())theCompletionHandler {
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    if (@available(iOS 11.0, *)) {
        WKWebView* webView = self.webV;
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
        //        [WebViewCustom clearWKCookies];
        
    } else {
        // Fallback on earlier versions
        !theCompletionHandler ?: theCompletionHandler();
    }
}

- (NSString *)jsCriptStr
{
    
    
    
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
    
    return jScript;
}
- (BOOL)scalesPageToFit
{
    
    return YES;//_scalesPageToFit;
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

-(void)dealloc{
    NSLog(@"--sc--webView-dealloc--");
}

@end
