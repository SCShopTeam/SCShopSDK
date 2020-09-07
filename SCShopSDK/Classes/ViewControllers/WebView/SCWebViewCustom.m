//
//  SCWebViewCustom.m
//  ecmc
//
//  Created by My Mac on 13-1-22.
//  Copyright (c) 2013年 cp9. All rights reserved.
//

#import "SCWebViewCustom.h"
#import <QuartzCore/QuartzCore.h>

#import <EventKit/EventKit.h> 
#import <CoreLocation/CoreLocation.h>
#import "SCCacheManager.h"

#import "SCWebViewCustom+JSCallback.h"

//#import "WaitingView.h"
//#import "WKWebView/WKWebViewController.h"
#import "WKWebViewJavascriptBridge.h"
//#import "DurationMonitor.h"

#import "SCWKWebViewPool.h"
#import <WebKit/WebKit.h>
#import "SCUserInfo.h"
#import <objc/runtime.h>
#import "SCURLSerialization.h"
#import "SCShoppingManager.h"
typedef void (*CallFuc)(id, SEL, BOOL);
typedef BOOL (*GetFuc)(id, SEL);

@interface SCWebViewCustom() <
UIActionSheetDelegate,

UIGestureRecognizerDelegate,NSURLSessionDelegate,SCWebViewDelegate>
{
    CLLocationManager *locationManager;
    //    WaitingView *waitingView;
    
    //第一级链接
    /**
     由于重定向链接，会走两次shoudstar，一次didfinish，导致一级页面链接改变，因此在didfinsh中设置一级链接
     */
    NSString *firstUrl;
}
//@property (nonatomic, strong) LocationUtil *locationUtil;
@property (nonatomic, copy) NSString *urlToSave;
@property (nonatomic, copy) NSString *qrCodeString;
@property (nonatomic, copy) NSString *pageTitle; //页面标题
// Webview页面加载结束
@property (nonatomic, assign) BOOL pageWebviewLoadFinsh;
@end

@implementation SCStringMethod

-(NSString*) subString:(NSString*)str startStr:(NSString*)startStr endStr:(NSString*)endStr{
    NSString *sidStr = @"";
    NSInteger begin=[str rangeOfString:startStr].location+[str rangeOfString:startStr].length;
    NSInteger flag = [str rangeOfString:startStr].location;
    if (flag != 2147483647)
    {
        sidStr=[str substringFromIndex:begin];
        sidStr=[[sidStr substringToIndex:[sidStr rangeOfString:endStr].location] copy];
    }
    return sidStr;
}
@end

@implementation SCWebViewCustom

@synthesize string;
@synthesize urlString;


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (self.jsIsHiddenNav) {
//        self.myWebView.frame = CGRectMake(self.myWebView.frame.origin.x,
//                                          self.myWebView.frame.origin.y,
//                                          CGRectGetWidth(self.myWebView.frame),
//                                          CGRectGetHeight(self.view.frame)-STATUS_BAR_HEIGHT);
         self.myWebView.frame = CGRectMake(0,STATUS_BAR_HEIGHT,CGRectGetWidth(self.view.bounds),CGRectGetHeight(self.view.bounds)-STATUS_BAR_HEIGHT);
        
    }else{
        self.myWebView.frame = CGRectMake(0,0,CGRectGetWidth(self.view.bounds),CGRectGetHeight(self.view.bounds));

//        self.myWebView.frame = CGRectMake(self.myWebView.frame.origin.x,
//                                          self.myWebView.frame.origin.y,
//                                          CGRectGetWidth(self.myWebView.frame),
//                                          CGRectGetHeight(self.view.frame));
    }
    

}


- (void)webViewloadRequest:(NSString*)tempUrl
{
    
    if (![SCUtilities isValidString:tempUrl])
    {
        return;
    }
    // 将多配置的空格还原
    tempUrl = [tempUrl stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    self.urlString = tempUrl;
    self.currentPageUrl = tempUrl;
    if([SCUtilities isValidString:self.urlString])
    {
        NSString *temp = urlString;
        /*
         某些第三方页面在url过长时，页面会出现打不开的情况。
         配置的原始url中如果有jsmccflag=0，则不在WebView请求url拼接客户端标志参数。并且将jsmccflag=0去除。
         配置的原始url中如果没有jsmccflag=0，则在WebView请求url拼接客户端标志参数。
         测试用例：
         NSString *temp = @"http://wap.js.10086.cn/activity/123?jsmccflag=0";
         NSString *temp = @"http://wap.js.10086.cn/activity/471?jsmccflag=0&platform=ios&sign=1";
         */
        NSRange range = [temp rangeOfString:@"jsmccflag=0"];
        if (range.location == NSNotFound) {
            
        }
        else
        {
            NSArray *tempArr = [temp componentsSeparatedByString:@"jsmccflag=0"];
            NSString *firstString = tempArr[0];
            NSString *lastString = tempArr[1];
            if ([SCUtilities isValidString:lastString])
            {
                // 只对问号后面的进行url编码，前面的不编码
                lastString = [lastString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                NSMutableString *lastStr = [NSMutableString stringWithString:lastString];
                [lastStr deleteCharactersInRange:NSMakeRange(0,1)];
                temp = [firstString stringByAppendingString:lastStr];
            }else{
                if([firstString rangeOfString:@"&"].location != NSNotFound)
                {
                    NSMutableString *firstStr = [NSMutableString stringWithString:firstString];
                    [firstStr deleteCharactersInRange:NSMakeRange(firstStr.length - 1,1)];
                    if ([SCUtilities ADTouchSwitch:@"bWebviewUtf8switch"]) {
                        temp=(NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)firstStr,(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",NULL,kCFStringEncodingUTF8));
                    }
                    else
                    {
                        temp = [firstStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    }
                }
                else
                {
                    // 只对问号后面的进行url编码，前面的不编码
                    temp = [firstString stringByTrimmingCharactersInSet:
                            [NSCharacterSet characterSetWithCharactersInString:@"?"]];
                }
            }
        }
        //使用方法，在开启webview的时候开启监听，，销毁weibview的时候取消监听，否则监听还在继续。将会监听所有的网络请求
        //        NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:temp]];
        [SCUtilities appendParametersToHTTPHeader:request];
        
        [self.myWebView loadRequest:request];
        
        // 开始加载滚动条
        [_progressLayer startLoad];
        
        //是否显示加载提示框
        [self showloadingPrompt:temp];
    }
}

- (NSString *)appendParameters:(NSString *)temp
{
    NSArray *tempArr = [temp componentsSeparatedByString:@"?"];
    NSString *firstString = tempArr[0];
    NSMutableString *lstMutableString = [[NSMutableString alloc] init];
    for (NSString* lastString in tempArr)
    {
        if ([lastString isEqualToString:firstString])
        {
            [lstMutableString appendString:@""];
            continue;
        }
        
        if ([SCUtilities isValidString:lastString])
        {// 只对问号后面的进行url编码，前面的不编码
            [lstMutableString appendString:[NSString stringWithFormat:@"?%@",[lastString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        }
    }
    //                NSString *lastString  = tempArr[1];
    //                if ([SCUtilities isValidString:lastString])
    //                {// 只对问号后面的进行url编码，前面的不编码
    //                    lastString = [lastString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //                    lastString = [NSString stringWithFormat:@"?%@", lastString];
    //                }
    temp = [firstString stringByAppendingString:lstMutableString];
    temp = [SCUtilities appendParametersToURL:temp];
    return temp;
}
#pragma mark --是否显示加载提示框
- (void)showloadingPrompt:(NSString *)temp
{
    /*
     *根据t_setting_619表中的bLoadingPrompt字段来决定是否显示加载提示框
     */
    /*
     * 从6.3.4版本之后用t_webhudSetting_634表来判断显示以及配置提示文字
     */
    //    NSString *cutUrl;
    //    NSArray *arrayBalance = [[HomeDatabaseManager getDatabaseManager] getWebhubData];
    //    if([SCUtilities isValidArray:arrayBalance])
    //    {
    //        for(NSMutableDictionary *dict in arrayBalance)
    //        {
    //            if ([SCUtilities isValidDictionary:dict])
    //            {
    //                if ([SCUtilities isValidString:dict[@"url"]])
    //                {
    //                    cutUrl = dict[@"url"];
    //                    if ([SCUtilities isValidString:temp] && [temp rangeOfString:cutUrl].location !=NSNotFound) {
    //                        NSString *text = dict[@"textContent"];
    //                        NSString *notShowLoad = dict[@"notShowLoad"];
    //                        if ([notShowLoad isEqualToString:@"1"])
    //                        {
    //                             _progressLayer.hidden = YES;
    //                        }
    //                        else
    //                        {
    //                            if ([SCUtilities isValidString:text]) {
    //                                waitingView.msgLabel.text = text;
    //                                [self.view addSubview:waitingView];
    //                                [waitingView showLoading];
    //                                [self performSelector:@selector(hiddenLoading) withObject:nil afterDelay:1.0f];
    //                                _progressLayer.hidden = YES;
    //                            }
    //                        }
    //                        break;
    //                    }
    //                }
    //            }
    //        }
    //    }
}

- (void)hiddenLoading{
    //    [waitingView hideLoading];
}

- (void)loadView
{
    [super loadView];
    
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                         0,
                                                         CGRectGetWidth(self.view.bounds),
                                                         CGRectGetHeight(self.view.bounds))];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createWebview];
}

- (void)createWebview
{
//    self.myWebView  = [[SCWKWebViewPool sharedInstance] getReusedWebViewForHolder:self];
    self.myWebView = [[SCWebView alloc] initWithFrame:CGRectMake(0.0,
                                                                                                 0.0,
                                                                                                 CGRectGetWidth(self.view.bounds),
                                                                                                 CGRectGetHeight(self.view.bounds)) usingUIWebView:NO];
//    [self.myWebView.realWebView  useExternalNavigationDelegate];
    //        [self.myWebView.realWebView setMainNavigationDelegate:self.myWebView];
//    self.myWebView.delegate = self;
    
    
    
    
    [self.myWebView setOpaque:NO];
    [self.myWebView setBackgroundColor:[UIColor whiteColor]];
    self.myWebView.autoresizesSubviews = YES;
    //    self.myWebView.dataDetectorTypes   = UIDataDetectorTypePhoneNumber;
    //设置textView圆角
//    [self.myWebView.layer setBackgroundColor:[[UIColor whiteColor] CGColor]];
//    [self.myWebView.layer setBorderColor:[[UIColor grayColor] CGColor]];
//    [self.myWebView.layer setMasksToBounds:YES];
    [self.myWebView setScalesPageToFit:YES];
//    self.myWebView.clipsToBounds = YES;
    //优化
    //    [(UIScrollView *)[[_myWebView subviews] objectAtIndex:0] setBounces:NO];
    [self.view addSubview:_myWebView];
    
    _progressLayer = [SCWebProgressLayer new];
    _progressLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 3);
    [self.view.layer addSublayer:_progressLayer];

}

// 当前webview是否使用公用webview
- (BOOL)currentClassUseCommonWebview
{
    //    if(![[HomeDatabaseManager getDatabaseManager] getNotCommonUseWKWebview:self.urlString] && [SCUtilities ADTouchSwitch:@"useCommonWebview"] && [SCUtilities ADTouchSwitch:@"useWKWebviewVersion3"] )
    //    {
    //        NSArray* firstWebviewPageArray = @[@"EnjoyViewController",@"BrandDayViewController",@"WealViewController",@"NearViewController",@"NetworkAndLifeWebView",@"PhoneStoreViewController",@"CommonTabWebview",@"MallTabWebiew"];
    //        NSString *classStr  = NSStringFromClass([self class]);
    //        if (![firstWebviewPageArray containsObject:classStr] )
    //        {
    //            if (@available(iOS 11.0, *))
    //            {
    //                return YES;
    //            }
    //            else
    //            {
    //                return NO;
    //            }
    //        }
    //    }
    
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer
                   *)gestureRecognizer{
  return NO;
}

#pragma mark --登陆成功通知
-(void)loginSuccessNotifity{
    NSLog(@"--sc-- 重新加载request");
//    [self customUserAgent];
    [self.myWebView loadRequest:self.myWebView.currentRequest];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    // 将系统自带的滑动手势打开
    self.view.backgroundColor = [UIColor whiteColor];
    
        
    [self customUserAgent];

    self.navigationController.navigationBar.tintColor = HEX_RGB(@"184c85");
    
    //监听回调JS 掌厅登陆成功等。。。
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ocCallBackJsFunction:) name:@"ocCallBackJsFunction" object:nil];
    
    //监听UIWindow隐藏
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];
    // 检测后台切换前台是否已经隔夜
    
    //    if (![SCUtilities ADTouchSwitch:@"useWebviewHideBack"])
    //    {
    /***
     *  返回上一级
     **/
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
    
    //    }
    //    else
    //    {
    //        /***
    //         *  返回上一级
    //         **/
    //        _backButton         = [UIButton buttonWithType:UIButtonTypeCustom];
    //        _backButton.frame   = CGRectMake(8, (49-21)/2, 58, 21);
    //        [_backButton setImage:[UIImage imageNamed:@"WebViewCustom_back"]
    //                     forState:UIControlStateNormal];
    //        [_backButton setTitle:@"返回" forState:UIControlStateNormal];
    //        [_backButton setTitleColor:[UIColor getColor:@"333333"] forState:UIControlStateNormal];
    //        _backButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //        [_backButton layoutButtonWithEdgeInsetsStyle:XGButtonEdgeInsetsStyleLeft imageTitleSpace:2];
    //        _backButton.imageView.contentMode = UIViewContentModeScaleToFill;
    //        [_backButton addTarget:self action:@selector(next:)
    //              forControlEvents:UIControlEventTouchUpInside];
    //    }
    
    //    if (![SCUtilities ADTouchSwitch:@"useWebviewHideBack"])
    //    {
    /***
     *  返回到客户端
     **/
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
    
    
    
    __weak __typeof(&*self)weakSelf =self;
    self.myWebView.delegate = weakSelf;
    [WKWebViewJavascriptBridge enableLogging];
    
    self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.myWebView.realWebView];
    //[WebViewJavascriptBridge bridgeForWebView:self.myWebView.realWebView webViewDelegate:self.myWebView handler:nil];
    //    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.myWebView.realWebView];
    [_bridge setWebViewDelegate:self.myWebView];
    
    
    [self webViewloadRequest:self.urlString];
    
    
    if ([SCUtilities isValidString:self.title]) {
        self.pageTitle = self.title;
    }
    
    // js通过bridge调用本地方法
    [self jsCallBackOCFunction];
             
}

#pragma mark--关闭全屏
- (void)endFullScreen{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

#pragma mark --cookie--
-(void)configCookieWithRequest:(NSMutableURLRequest *)request{
        
    SCShoppingManager *manager = [SCShoppingManager sharedInstance];
    
    if (manager.delegate && [manager.delegate respondsToSelector:@selector(scConfigCookiesWithUrl:wkweb:back:)]) {
        [manager.delegate scConfigCookiesWithUrl:request  wkweb:self.myWebView.realWebView back:^(BOOL success) {
            NSLog(@"%@",@"--sc-- 代理设置cookie成功回调");
        }];
    }else if([self.urlString containsString:@"wap.js.10086.cn"]){
      
//        NSLog(@"--sc--  没有设置cookie代理，内部设置");
//        
//        if (![SCUserInfo currentUser].isLogin) {
//             NSLog(@"--sc-- configCookie-没有登陆--内部没有设置cookie代理");
//            return;
//        }
//        
//        WKWebView* wkwebView = self.myWebView.realWebView;
//        //  先放在这里，之后再做掌厅回调处理
//        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//   
//        NSString *cmtokenid = [SCGetAuthToken cmtokenId];
//        NSDictionary *properties = [[NSMutableDictionary alloc] init];
//        [properties setValue:cmtokenid forKey:NSHTTPCookieValue];
//        [properties setValue:@"cmtokenid" forKey:NSHTTPCookieName];
//        NSString *s = self.urlString;
//        NSURL *url = [NSURL URLWithString:s];
//        [properties setValue:[url host] forKey:NSHTTPCookieDomain];
//        [properties setValue:@"/" forKey:NSHTTPCookiePath];
//        
//        NSHTTPCookie* cookie = [NSHTTPCookie cookieWithProperties:properties];
////        [storage setCookie:cookie];
//        if (@available(iOS 11.0, *))
//        {
//            WKWebView* wkwebView = self.myWebView.realWebView;
//
//            WKHTTPCookieStore *cookieStroe = wkwebView.configuration.websiteDataStore.httpCookieStore;
//            [cookieStroe setCookie:cookie completionHandler:^{
//            }];
//        }
//        NSLog(@"--scsc-- scwebViewConfigCookie:cmtokenid=%@",cmtokenid);
//        
//        NSString* userAreaNum = [SCGetAuthToken userAreaNum] ;
//        if(![SCUtilities isValidString:userAreaNum])
//        {
//            userAreaNum = [SCUserInfo currentUser].uan;
//        }
//        NSDictionary *properties1 = [[NSMutableDictionary alloc] init];
//        [properties1 setValue:[SCUtilities isValidString:userAreaNum]?userAreaNum:@"" forKey:NSHTTPCookieValue];
//        [properties1 setValue:@"userAreaNum" forKey:NSHTTPCookieName];
//        [properties1 setValue:[url host] forKey:NSHTTPCookieDomain];
//        [properties1 setValue:@"/"forKey:NSHTTPCookiePath];
//        
//        NSHTTPCookie* cookie1 = [NSHTTPCookie cookieWithProperties:properties1];
////        [storage setCookie:cookie1];
//        if (@available(iOS 11.0, *))
//        {
//            WKHTTPCookieStore *cookieStroe = wkwebView.configuration.websiteDataStore.httpCookieStore;
//            [cookieStroe setCookie:cookie1 completionHandler:^{
//            }];
//        }
//        if (![SCUserInfo currentUser].isJSMobile)
//
//        {
//            NSString* ywLoginCookie = [SCUtilities getUnifyAuthToken:@"YWLoginCookie"];
//            if([SCUtilities isValidString:ywLoginCookie])
//            {
//                NSDictionary *properties2 = [[NSMutableDictionary alloc] init];
//                [properties2 setValue:[SCUtilities isValidString:ywLoginCookie]?ywLoginCookie:@"" forKey:NSHTTPCookieValue];
//                [properties2 setValue:@"YWLoginCookie" forKey:NSHTTPCookieName];
//                [properties2 setValue:[url host] forKey:NSHTTPCookieDomain];
//                [properties2 setValue:@"/" forKey:NSHTTPCookiePath];
//
//                NSHTTPCookie* cookie2 = [NSHTTPCookie cookieWithProperties:properties2];
//                [storage setCookie:cookie2];
//                if (@available(iOS 11.0, *))
//                {
//                    WKHTTPCookieStore *cookieStroe = wkwebView.configuration.websiteDataStore.httpCookieStore;
//                    [cookieStroe setCookie:cookie2 completionHandler:^{
//                    }];
//                }
//            }
//        }
        
//        NSURL *url = request.URL;
//        NSString *phone = [SCUserInfo currentUser].phoneNumber? :@"";
//        NSDictionary *properties3 = [[NSMutableDictionary alloc] init];
//        [properties3 setValue:phone forKey:NSHTTPCookieValue];
//        [properties3 setValue:@"mallMobile" forKey:NSHTTPCookieName];
//        [properties3 setValue:[url host] forKey:NSHTTPCookieDomain];
//        [properties3 setValue:@"/" forKey:NSHTTPCookiePath];
//
//        NSHTTPCookie* cookie3 = [NSHTTPCookie cookieWithProperties:properties3];
//        [storage setCookie:cookie3];
//        if (@available(iOS 11.0, *))
//        {
//            WKHTTPCookieStore *cookieStroe = wkwebView.configuration.websiteDataStore.httpCookieStore;
//            [cookieStroe setCookie:cookie3 completionHandler:^{
//            }];
//        }
    }
}

#pragma mark -- customUserAgent--
- (void)customUserAgent
{
    
    if (![SCUserInfo currentUser].isLogin) {
        return;
    }
    
    SCShoppingManager *manager = [SCShoppingManager sharedInstance];
    
    if (manager.delegate && [manager.delegate respondsToSelector:@selector(scUserAgentWithUrl:back:)]) {
        [manager.delegate scUserAgentWithUrl:self.urlString back:^(NSString * _Nonnull userAgent) {
      
                WKWebView* wkWebview = (WKWebView*)self.myWebView.realWebView;
                
                wkWebview.customUserAgent = userAgent;
        }];
    }else{
                        
        [self.myWebView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            WKWebView* wkWebview = (WKWebView*)self.myWebView.realWebView;
            NSString *oldUA = result;
            NSString *newUA =[NSString stringWithFormat:@"%@ Jsmcc/1.0 Mall/1.0 %@", oldUA, [SCUtilities suffixParameters:self.urlString]];
            wkWebview.customUserAgent = newUA;
        }];
    }
    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    originalCookies = [[NSArray alloc] initWithArray:[storage cookies]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ShowShareParams"];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    self.hideNavigationBar = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    originalCookies = [[NSArray alloc] initWithArray:[storage cookies]];
    //    if (@available(iOS 11.0, *)) {
    //        self.myWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    //    } else {
    //        self.automaticallyAdjustsScrollViewInsets = NO;
    //    }
    
    //    for (NSHTTPCookie *cookie in [storage cookies])
    //    {
    //        if ([cookie.name isEqualToString:@"JSESSIONID"]) {
    //            [storage deleteCookie:cookie];
    //        }
    //    }
    // 每个页面设置需要插码使用的cookie
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // clear cache
    //    [[NSURLCache sharedURLCache] removeAllCachedResponses];

    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    
}

//键盘弹出后将视图向上移动
-(void)keyboardWillShow:(NSNotification *)note{
    if (@available(iOS 11.0, *)) {
        self.myWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

//键盘隐藏后将视图恢复到原始状态
-(void)keyboardWillHide:(NSNotification *)note{
    if (@available(iOS 11.0, *)) {
        self.myWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // clear cache
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

-(void)goback:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)refresh:(id)sender
{
    [self.myWebView reload];
}

-(void)next:(id)sender
{
    if ([self.myWebView.URL.absoluteString isEqualToString:self.urlString] ) {
        /**
         部分重定向链接，为流浪链接，比如拼多多的链接
         初次加载时，页面为一级链接，所有操作都正常
         但其在加载完成之后，即webviewdidfinish之后，cangoback为yes这样，用户点返回永远返回不了
         因此对此种链接进行特殊，判断其在如果是一级链接，在加载完成之后的cangoback是否为yes，如果为yes，其返回即为关闭webview
         整合逻辑如下，如果一级链接加载完成之后，其cangoback为yes，点击返回则关闭webview
         */
        __block BOOL isVueUrl = NO;
        
        if (!isVueUrl) {
            [self clearResource];
            [self.bridge setWebViewDelegate:nil];
            self.bridge = nil;
            [_bridge setWebViewDelegate:nil];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    [self.myWebView goBack];
    if (![self.myWebView canGoBack])
    {
        [self clearResource];
        [self.bridge setWebViewDelegate:nil];
        self.bridge = nil;
        [_bridge setWebViewDelegate:nil];
        [self.navigationController popViewControllerAnimated:YES];
        // 取消head头部注册
    }else{
        //创建关闭和返回按钮
        [self creatLeftButtonBackAndClose];
    }
}

- (void)shut:(id)sender
{
    [_bridge setWebViewDelegate:nil];
    self.bridge = nil;
    [self clearResource];
    [self.navigationController popViewControllerAnimated:YES];
    //    [self dismissViewControllerAnimated:YES completion:^{
    //        EcmcAppDelegate* appDelegate = (EcmcAppDelegate*)[[UIApplication sharedApplication] delegate];
    //        [appDelegate showTabBar];
    //    }];
    // 取消head头部注册
}

#pragma mark Shake
- (BOOL) canBecomeFirstResponder
{
    return YES;
}

- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        if(self.shakeDoLottery)
        {
            [self.myWebView evaluateJavaScript:[NSString stringWithFormat:@"doLottery();"] completionHandler:^(id _Nullable result, NSError *error) {
            }];
            //            [self.myWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"doLottery();"]];
        }
    }
}

#pragma mark UIWebViewDelegate
- (void)webViewDidStartLoad:(SCWebView *)webView
{
    _pageWebviewLoadFinsh = NO;
    // 全链路 开启webview
    
    //添加用户操作日志记录
    
    //    _fanKuiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    _fanKuiButton.frame = CGRectMake(CGRectGetWidth(self.view.frame)-28, (49-25)/2, 20, 21);
    //    [_fanKuiButton setBackgroundImage:[UIImage imageNamed:@"yijianfankui"]
    //                              forState:UIControlStateNormal];
    //    [_fanKuiButton addTarget:self action:@selector(fankuiButtonClick:)
    //             forControlEvents:UIControlEventTouchUpInside];
    //    UIBarButtonItem *fanKuiItem = [[UIBarButtonItem alloc] initWithCustomView:_fanKuiButton];
    //
    //    /***
    //     *  更多
    //     **/
    //
    //        [self getMoreBtnDate];
    //        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //        _moreBtn.frame = CGRectMake(CGRectGetWidth(self.view.frame)-28, (49-25)/2, 20, 21);
    //        [_moreBtn setImage:[UIImage imageNamed:@"yktfu_moredark"] forState:UIControlStateNormal];
    //        [_moreBtn addTarget:self action:@selector(navigationFunctionTap:) forControlEvents:UIControlEventTouchUpInside];
    //        UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithCustomView:_moreBtn];
    //    if (![self.title isEqualToString:@"问卷调查"]) {
    //        NSArray *rightButtonItems = @[moreItem,fanKuiItem];
    //        self.navigationItem.rightBarButtonItems = rightButtonItems;
    //    }else {
    //        NSArray *rightButtonItems = @[moreItem];
    //        self.navigationItem.rightBarButtonItems = rightButtonItems;
    //    }
    
    // 埋点上传webview打开时长
}

- (BOOL)webView:(SCWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(NSInteger)navigationType
{
    
    if (![self parseScheme:request])
    {
        return NO;
    }
    
    NSURL *url      = [request URL];
    NSString* scheme = [url scheme];
    NSString* urlString = [url absoluteString];
    self.currentPageUrl = urlString;

    
    if (![scheme hasPrefix:@"http"] && ![scheme hasPrefix:@"https"]) {

        [[SCURLSerialization shareSerialization] gotoController:urlString navigation:self.navigationController];
        
        return NO;
    }
    
    if([SCUtilities isValidString:urlString]
       && ([urlString hasPrefix:@"http"] || [urlString hasPrefix:@"https"]))
    {
        NSMutableURLRequest *multRequest = (NSMutableURLRequest *)request;
        [self configCookieWithRequest:multRequest];   //设置cookie
    }
    
    if (_progressLayer.superlayer == nil)
    {
        if( [scheme hasPrefix:@"http"] || [scheme hasPrefix:@"https"])
        {
            if (_progressLayer.hidden == NO)
            {
                [_progressLayer closeTimer];
                [_progressLayer removeFromSuperlayer];
                _progressLayer = nil;
                _progressLayer = [SCWebProgressLayer new];
                _progressLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 3);
                [self.view.layer addSublayer:_progressLayer];
                [_progressLayer startLoad];
            }
        }
    }
    /**
     部分webview加载完页面之后，会根据参数更改页面，导致url改变，但只是改变参数，不改变住链接，因此导致isequal判断失效，实际webView是不可以goback的，因此双层判断
     如果firsturl和self.urlstring一样，表示第一次进入的链接不是重定向链接，如果不一样，说明第一次进入的链接，是重定向链接
     */
    if (([request.URL.absoluteString isEqualToString:self.urlString] || ![webView canGoBack]) && [self.urlString isEqualToString:firstUrl]) {
        
        [self creatLeftButtonBack];
        
    }
    
    NSDictionary *dic = request.allHTTPHeaderFields;
    NSLog(@"--sc--  request-allheader=%@",dic);
    
    return YES;
}

- (void)webViewTitle:(SCWebView*)webView Title:(NSString *)title
{
    if ([self.myWebView canGoBack] || ![SCUtilities isValidString:self.pageTitle]) {
        self.title = title;
    }else{
        if ([SCUtilities isValidString:self.pageTitle]) {
            self.title = self.pageTitle; //网页的一级页面标题，显示的都是固定标题
        }
    }
}

- (void)webViewFinishTime:(SCWebView*)webView
{// 统计页面加载时长 第一时间统计防止做耗时操作延迟
    // 埋点上传webview打开时长
    //    [[DurationMonitor getInstance] pageEnd:self isSucess:@"success" errormessage:@""];
    
}

- (void)webViewDidFinishLoad:(SCWebView *)webView
{
    _pageWebviewLoadFinsh = YES;
    
    [_progressLayer finishedLoad];
    
    //    [EcmcZYLoadTime shareInstance].webviewloadfinishTime = [NSString stringWithFormat:@"%.3f",[[NSDate date] timeIntervalSince1970]];
    // jsContext
    
    if (self.webPhoneNumber.length > 0 && self.webPhoneNumber.length == 11) {
        [self.myWebView evaluateJavaScript:[NSString stringWithFormat:@"inputPhone([%@]);",self.webPhoneNumber] completionHandler:^(id _Nullable result, NSError *error) {
        }];
    }
    
    
    
    if (!firstUrl) {
        firstUrl = self.myWebView.currentRequest.URL.absoluteString;
    }
    
    
}

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
-(void)parseJSTimingDictionary:(NSString*) dictstring completionHandler:(void (^)(NSString* performanceString,NSTimeInterval onloadtiming))completionHandler
{
    
    
}
- (BOOL)isFirstLoad
{
    BOOL result = [[NSUserDefaults standardUserDefaults] boolForKey:@"RechargeFirstLoad"];
    if (!result) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"RechargeFirstLoad"];
    }
    return !result;
}

- (void)webView:(SCWebView *)webView didFailLoadWithError:(NSError *)error{
    _pageWebviewLoadFinsh = YES;
    //隐藏加载中
    
    
    // 全链路  webview失败插码
    NSString *strUrl = @"";
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    WKWebView* webviewWK = (WKWebView*)webView.realWebView;
    strUrl = webviewWK.URL.absoluteString;
    if ([SCUtilities isValidString:strUrl])
    {
        NSRange range = [strUrl rangeOfString:@"//"];
        if (range.location != NSNotFound)
        {
            strUrl = [strUrl substringFromIndex:range.location + range.length];
            dic[@"url"] = strUrl;
            range = [strUrl rangeOfString:@"/"];
            
        }
    }
    
    // 如果是被取消，什么也不干
    if([error code] == NSURLErrorCancelled)
    {
        return;
    }
    
    NSString* errorMessage = @"";
    if (error)
    {
        // 错误编码
        // 错误描述
        errorMessage = error.localizedDescription;
        if (![SCUtilities isValidString:errorMessage])
        {
            errorMessage = @"";
        }
        errorMessage = [NSString stringWithFormat:@"%ld-%@",(long)error.code,errorMessage];
    }
    // 跳第三方APP 不作为时长统计标准
    
}

-(void)clearResource
{
    //释放webView
    [self.myWebView stopLoading];
    self.myWebView.delegate = nil;
    self.myWebView = nil;
    urlString = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark--LoginViewDelegate
- (void)jumpto:(NSInteger)index{}

-(void) dealloc
{
    //    [waitingView hideLoading];
    [_progressLayer closeTimer];
    [_progressLayer removeFromSuperlayer];
    _progressLayer = nil;
    
    //    [ECMCCacheURLProtocol cancelListeningNetWorking];//在不需要用到webview的时候即使的取消监听
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ActivityRemindParams"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ShowShareParams"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //    if (!self.myWebView.usingUIWebView)
    //       {// 清除所有cookie
    //           [SCWebViewCustom clearWKCookies];
    //       }
    
    // restore cookies
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies])
    {
        //        if ([[MyServicesDBManger shareInstance] isDeleteCookieWithCookieName:cookie.name Type:@"closeweb"]) {
        [storage deleteCookie:cookie];
        
        if (@available(iOS 11.0, *)) {
            WKWebView* wkwebView = self.myWebView.realWebView;
            WKHTTPCookieStore *cookieStroe = wkwebView.configuration.websiteDataStore.httpCookieStore;
            [cookieStroe deleteCookie:cookie completionHandler:^{
            }];
        }
        //        }
    }
    //保留不清除的cookie数据
    for (NSHTTPCookie *cookie in originalCookies)
    {
        //        if ([[MyServicesDBManger shareInstance] isDeleteCookieWithCookieName:cookie.name Type:@"closeweb"]) {
        [storage setCookie:cookie];
        if (!self.myWebView.usingUIWebView)
        {
            if (@available(iOS 11.0, *)) {
                WKWebView* wkwebView = self.myWebView.realWebView;
                WKHTTPCookieStore *cookieStroe = wkwebView.configuration.websiteDataStore.httpCookieStore;
                [cookieStroe setCookie:cookie completionHandler:^{
                    
                }];
            }
        }
        //        }
    }
    
    if(self.myWebView)
    {
        if ([self currentClassUseCommonWebview] )
        {
            if (@available(iOS 11.0, *))
            {
                if (!self.myWebView.terminate)
                {
                    if (!_pageWebviewLoadFinsh) {
                        [[SCWKWebViewPool sharedInstance] recycleReusedWebViewNotLoad:self.myWebView];
                        NSLog(@"我还没加载完哦哦哦");
                        
                    }
                    else
                    {
                        [[SCWKWebViewPool sharedInstance] recycleReusedWebView:self.myWebView];
                        NSLog(@"我加载完了哦！！！");
                    }
                }
            }
            else
            {
                //用于返回关闭视频和音频
                [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
                [self.myWebView stopLoading];
                // 防止野指针崩溃
                self.myWebView.delegate = nil;
            }
        }
        else
        {
            //用于返回关闭视频和音频
            [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
            [self.myWebView stopLoading];
            // 防止野指针崩溃
            self.myWebView.delegate = nil;
        }
        //        [self.myWebView cleanInstanceWebview];
        
        
    }
}

+ (void)clearWKCookies
{
    if (@available(iOS 11.0, *)) {
        if ([SCUtilities ADTouchSwitch:@"useWKWebviewVersion3"])
        {
            NSSet *websiteDataTypes = [NSSet setWithObject:WKWebsiteDataTypeCookies];
            NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
            //             [WKWebsiteDataStore defaultDataStore].httpCookieStore;
            [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            }];
        }
    }
}

#pragma mark -- UIActionSheetDelegate



// 清空localStorage
+ (void)cleanLocalStorage
{
    NSString *path = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Backups"] stringByAppendingPathComponent:@"localstorage.appdata.db"];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    //只清除异网的cookie，其他的不清除
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies])
    {
        if([cookie.name isEqualToString:@"ywtoken"])
        {
            [storage deleteCookie:cookie];
        }
    }
    //Also remove the cached versions
    path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    for (NSString *string in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil])
    {
        if ([[string pathExtension] isEqualToString:@"localstorage"])
        {
            [[NSFileManager defaultManager] removeItemAtPath:[path stringByAppendingPathComponent:string] error:nil];
        }
        if ([[string pathExtension] isEqualToString:@"localstorage-shm"])
        {
            [[NSFileManager defaultManager] removeItemAtPath:[path stringByAppendingPathComponent:string] error:nil];
        }
        if ([[string pathExtension] isEqualToString:@"localstorage-wal"])
        {
            [[NSFileManager defaultManager] removeItemAtPath:[path stringByAppendingPathComponent:string] error:nil];
        }
    }
}


- (void)creatLeftButtonBackAndClose{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    UIBarButtonItem *shutItem = [[UIBarButtonItem alloc] initWithCustomView:_shutButton];
    NSArray *leftButtonItems = @[backItem,shutItem];
    self.navigationItem.leftBarButtonItems = leftButtonItems;
}
- (void)creatLeftButtonBack{
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    NSArray *leftButtonItems = @[backItem];
    self.navigationItem.leftBarButtonItems = leftButtonItems;
}


- (void)copyNSHTTPCookieStorageToWKHTTPCookieStore
{
        [self.myWebView copyNSHTTPCookieStorageToWKHTTPCookieStoreWithCompletionHandler:nil];
}

- (void)webViewProgress:(SCWebView*)webView updateProgress:(NSProgress *)progress
{
    
}
@end
