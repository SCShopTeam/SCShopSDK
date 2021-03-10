//
//  SCWebViewCustom+JSCallback.m
//  ecmc
//
//  Created by gaoleyu on 16/11/28.
//  Copyright © 2016年 cp9. All rights reserved.
//

#import "SCWebViewCustom+JSCallback.h"
#import "SCCacheManager.h"

#import "WKWebViewJavascriptBridge.h"


//#if TARGET_IPHONE_SIMULATOR
//#else
//
//#import <NJExtenPlatformdKit/NJConfigInterface.h>
//#import "NJElectronicSeal.h"
//#import "NJElectronicSealInfo.h"
//#import "SCAP.h"
//
//#endif
@implementation SCWebViewCustom(JSCallback)


-(NSArray *)urlSchemeTypeToEnumArr{

    NSArray *urlSArr =  [[NSArray alloc] initWithObjects:
    @"speedtest",
    @"ecmcshare",
    @"ecmcwebshare",
    @"activityremind",
    @"ecmcapp",
    @"showshare",
    @"displayshareonright",
    @"mapnavigation",
    @"startAppPage",
    @"palmshop",
    @"safari",
    @"phonestore",
    @"ecmc",
    @"nonmobilelogout",
    @"nonmobilewebpush",
    @"wechatshare",
    @"closewebview",
    @"hiddenclose",
    @"showclose",
    @"hiddennavibar",
    @"iportalapp",
    @"shownavibar",
    @"networkcontact",
    @"jsmcc",
    @"scanimageshare",
    @"newzzdfriendshare",
    @"scanwebcback",
    @"launchwxminiprogram",
    @"launchwxbinding",
    @"feedback",
    @"returnfeedback",
    @"viewcontrollertitle",
    @"hePackJudge",
     @"ecmclivechat", nil];
    
    return urlSArr;
    // 创建初始化函数，等于用宏创建一个getter函数
//     __urlSchemeType = (__urlSchemeType == nil) ? urlSArr:__urlSchemeType;
//    return __urlSchemeType;
    // 枚举 to 字串
//    #define urlSchemeTypeToString(type) ([urlSchemeFramewrokTypeGet objectAtIndex:type])
    // 字串 to 枚举
}




#pragma mark urlScheme
- (BOOL)parseScheme : (NSURLRequest *)request
{
    NSURL *url      = [request URL];
    NSString *msg   = [url absoluteString];
    NSString *scheme = [url scheme];
    NSUInteger enumSchemeType = [[self urlSchemeTypeToEnumArr] indexOfObject:scheme.lowercaseString];
    
    
//    [[self urlSchemeTypeToEnumArr] indexOfObject:[[url scheme] lowercaseString]];//urlSchemeTypeToEnum([[url scheme] lowercaseString]);
//    NSUInteger enumSchemeType = urlSchemeTypeToEnum([url scheme]);
    return YES;
    BOOL bScheme = YES;
    
    /*
    
    switch (enumSchemeType)
    {
        case SC_Speedtest:
        {
//            [self.navigationController setNavigationBarHidden:NO animated:YES];
            bScheme = [self speedtestScheme];
        }
            break;
        case SC_Ecmcshare:
        {// 活动
            bScheme = [self ecmcshareScheme:msg];
        }
            break;
        case SC_Ecmcwebshare:
        {// 手机商城
            bScheme = [self ecmcwebshareScheme:msg];
        }
            break;
        case SC_WXMini:
        {
            bScheme = [self launchWXMiniProgram:msg];
        }
            break;
        default:
        {
            if ([request.URL.absoluteString isEqualToString:@"about:blank"])
            {
                bScheme = NO;
            }
            else
            {
                NSArray* listSchemes  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"LSApplicationQueriesSchemes"];
                NSString *scheme = [url scheme];
                if ([SCUtilities isValidArray:listSchemes] && [listSchemes containsObject:scheme])
                {
                    bScheme = NO;
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:msg]];
                }
            }
        }
            break;
    }
*/

    return bScheme;
}


#pragma mark - 扫一扫支持回调
-(BOOL)scanCallback:(NSString *)msg{
    //协议：scanWebCback://scan
    
    
    return NO;
}

#pragma mark - 微信图片分享
-(BOOL)weiXinImageShare:(NSString *)msg{
    //协议：wechatshare://share??imageUrl
    NSArray *params = [msg componentsSeparatedByString:@"??"];
   
    return NO;
}

#pragma mark - 异网内部web跳转
-(BOOL)nonMobileWebPush:(NSString *)msg{
   
    return NO;
}



#pragma mark - 异网登出
-(BOOL)nonMobileLogout:(NSString *)msg{
    //协议：nonmobilelogout://logout
    //判断协议头准确性
    
    return NO;
}

//保存集团红包登录信息（免登陆）
- (BOOL)saveCliqueBonusLogin: (NSString *)msg
{
    //协议：ecmc://save??param1??param2
    NSArray *params = [msg componentsSeparatedByString:@"??"];
   
    return NO;
}

// 唤起手机商城登录
- (BOOL)phoneStoreLogin : (NSString*) msg
{
    // 格式 phonestore://jumpToLogin
    // 方法 jumpToLogin（）
     //跳转登录界面
 
    return NO;
}

//回传经纬度信息
- (BOOL)palmshopScheme
{
    //协议：palmshop://getGeographyInfo
    //方法：getGeographyInfo
    //缓存定位信息
    NSMutableDictionary *locationInfo = [SCCacheManager getCachedObjectWithKey:@"LocationInfo"];
    if([SCUtilities isValidDictionary:locationInfo])
    {
        NSString *lng = [NSString stringWithFormat:@"%@",locationInfo[@"longitude"]];
        NSString *lat = [NSString stringWithFormat:@"%@",locationInfo[@"latitude"]];
        if ([SCUtilities isValidString:lng] && [SCUtilities isValidString:lat])
        {
//            [self.myWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"getCoordinates([%@],[%@]);",lng,lat]];
            [self.myWebView evaluateJavaScript:[NSString stringWithFormat:@"getCoordinates([%@],[%@]);",lng,lat] completionHandler:^(id _Nullable result, NSError *error) {
                                 }];
        }
    }
    return NO;
}

//打开功能反馈
- (BOOL)jumpToFeedback
{
    //协议：feedback://jumpToFeedback
    //方法：jumpToFeedback
    //缓存url和title
    NSMutableDictionary *feedbackInfo = [SCCacheManager getCachedObjectWithKey:@"feedback"];
    if([SCUtilities isValidDictionary:feedbackInfo])
    {
        NSString *url = [NSString stringWithFormat:@"%@",feedbackInfo[@"url"]];
        NSString *title = [NSString stringWithFormat:@"%@",feedbackInfo[@"title"]];
        if ([SCUtilities isValidString:url] && [SCUtilities isValidString:title])
        {
            //            [self.myWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"getUrl('%@','%@')",title,url]];
            [self.myWebView evaluateJavaScript:[NSString stringWithFormat:@"getUrl('%@','%@')",title,url] completionHandler:^(id _Nullable result, NSError *error) {
            }];
        }
    }

    return NO;
}


//wap活动页通过短地址调用系统原生界面
- (BOOL)startAppPageScheme : (NSString*) msg
{
    //协议：startAppPage://startActivity?mUrl=value1&params=value2
    //方法：startActivity(mUrl,params)

    return NO;
}

//是否调用本地导航
- (BOOL)mapnavigationScheme : (NSString*) msg
{
    //协议：mapnavigation://toReturnClientInfo?endLongitude=value1&endLatitude=value2
    //方法：toReturnClientInfo(endlongitude,endlatitude)
    NSString *endLongitude  = @""; //目的地的经度
    NSString *endLatitude   = @"";  //目的地的纬度
    NSString *tmpString     = [[msg componentsSeparatedByString:@"?"] lastObject];
    NSArray  *tmpArray      = [tmpString componentsSeparatedByString:@"&"];
    for (NSString *item in tmpArray) {
        NSRange range1      = [item rangeOfString:@"endLongitude"];
        NSRange range2      = [item rangeOfString:@"endLatitude"];
        
        if (range1.location != NSNotFound)
        {
            endLongitude    = [[item componentsSeparatedByString:@"="] lastObject];
        }
        if (range2.location != NSNotFound)
        {
            endLatitude     = [[item componentsSeparatedByString:@"="] lastObject];
        }
    }
//    [MapNavigationManager showSheetWithCoordinate2D:CLLocationCoordinate2DMake([endLatitude doubleValue],
//                                                                               [endLongitude doubleValue])];
    return NO;
}

- (BOOL)speedtestScheme
{
    // add by wangyu, 仅用于点亮4G活动

    return NO;
}

//活动提醒
- (BOOL)activityremindScheme : (NSString*) msg
{
    //activityremind://remind?title=value1&startTime=value2&endTime=value3&url=value4
    //function sendMessageToIOS("remind",title,startTime,endTime,url)
    //{
    //   var url = "activityremind://"+"remind"+"?"+"title"+"="+title+"startTime"+"="+sartTime+"endTime"+"="+endTime+"url"+"="+url;
    //   document.location = url;
    //}
    
  
    return NO;
}

//是否显示分享
- (BOOL)ecmcshareScheme : (NSString*) msg
{
    /*
     网页内分享，iOS8以上使用
     网页端传过来的格式是ecmcshare:shareString??shareLink，以ecmc:开头，??分割分享链接和分享链接
     支持抓取当前页面作为分享图片
     直接跳到分享页面，不经过Alert
     */
    NSString *str = [msg substringFromIndex:10];
  
    return NO;
}

//是否显示分享
- (BOOL)ecmcwebshareScheme : (NSString*) msg
{
    return NO;
}
//是否显示掌中店合伙人分享
- (BOOL)zzdfriendecmcwebshareScheme : (NSString*) msg
{
  
    
    return NO;
}
//单确定按钮
- (void)showBaseAletViewWithMessage:(NSString *)message{
//    BaseAlertView *popAlert = [[BaseAlertView alloc]initWithTitle:@"提示" message:message   delegate:nil buttonTitles:@[@"确定"]];
//    [popAlert show];
}

#pragma mark - 拉起微信小程序
- (BOOL)launchWXMiniProgram:(NSString *)msg {
    /*
     拉起微信小程序
     网页端传过来的格式是launchWXMiniProgram://mobilePhone??userName=value1#path=value2#type_release=value3
     */
    NSString *userName      = @"";
    NSString *path          = @"";
    NSString *type_release  = @"";
    
    NSString *str = [msg stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *tmpString = [[str componentsSeparatedByString:@"??"] lastObject];
    NSArray  *tmpArray  = [tmpString componentsSeparatedByString:@"#"];
    for (NSString *item in tmpArray) {
        
        NSRange range1 = [item rangeOfString:@"userName"];
        NSRange range2 = [item rangeOfString:@"path"];
        NSRange range3 = [item rangeOfString:@"type_release"];
        if (range1.location != NSNotFound) {
            
            NSRange range = [item rangeOfString:@"userName="];
            userName      = [item substringFromIndex:range.length];
        }
        if (range2.location != NSNotFound) {
            NSRange range = [item rangeOfString:@"path="];
            path          = [item substringFromIndex:range.length];
        }
        if (range3.location != NSNotFound)
        {
            NSRange range = [item rangeOfString:@"type_release="];
            type_release  = [item substringFromIndex:range.length];
        }
    }
//
//    WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
//
//    if ([SCUtilities isValidString:path]) {
//        launchMiniProgramReq.path = path;    //拉起小程序页面的可带参路径，不填默认拉起小程序首页
//    }
//
//    if ([SCUtilities isValidString:type_release]) {
//        launchMiniProgramReq.miniProgramType = type_release.integerValue; //拉起小程序的类型
//    }
//
//    if ([SCUtilities isValidString:userName]) {
//        launchMiniProgramReq.userName = userName;  //拉起的小程序的username
//        [WXApi sendReq:launchMiniProgramReq completion:nil];
//
//    }
    
    return NO;
}


#pragma mark - 二维码分享
- (BOOL) qrCodeShareClickWithScheme : (NSString*) msg
{
    /*
     手机商城网页内分享，iOS8以上使用
     网页端传过来的格式是scanimageshare://mobilePhoneMall?？content=value1#shareUrl=value2#title=value3#imageUrl=value4#mpmMsgId=value5
     直接跳到分享页面，不经过Alert
     */
 
    return NO;
}
//是否显示分享
- (BOOL)showshareScheme : (NSString*) msg
{
    //       协议：showshare://toShareOnRight?isShare=value1&content=value2&shareUrl=value3&channel=value4
    //       方法：toShareOnRight(isShare,content,shareUrl,channel)
    NSString *isShare   = @""; //是否分享
    NSString *content   = @"";//分享语
    NSString *shareUrl  = @""; //分享链接
    NSString *channel   = @""; //渠道号
    NSString *tmpString = [[msg componentsSeparatedByString:@"?"] lastObject];
    NSArray  *tmpArray  = [tmpString componentsSeparatedByString:@"&"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSString *item in tmpArray)
    {
        NSRange range1 = [item rangeOfString:@"isShare"];
        NSRange range2 = [item rangeOfString:@"content"];
        NSRange range3 = [item rangeOfString:@"shareUrl"];
        NSRange range4 = [item rangeOfString:@"channel"];
        
        if (range1.location != NSNotFound)
        {
            isShare = [[item componentsSeparatedByString:@"="] lastObject];
            if ([isShare  isEqual: @"1"])
            {
                _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
                _shareButton.frame = CGRectMake(CGRectGetWidth(self.view.frame)-28, (49-25)/2, 20, 21);
                
                [_shareButton setBackgroundImage:SCIMAGE(@"WebViewCustom_share")
                                        forState:UIControlStateNormal];
                [_shareButton addTarget:self action:@selector(shareVwt)
                       forControlEvents:UIControlEventTouchUpInside];
                UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:_shareButton];
                
                _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                 _moreBtn.frame = CGRectMake(0,0, 20, 21);
                 _moreBtn.backgroundColor = [UIColor clearColor];
                 [_moreBtn setImage:SCIMAGE(@"yktfu_moredark") forState:UIControlStateNormal];
                 [_moreBtn addTarget:self action:@selector(navigationFunctionTap:) forControlEvents:UIControlEventTouchUpInside];
                 [_moreBtn setAdjustsImageWhenHighlighted:NO];
                 UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithCustomView:_moreBtn];
                
                //客服
                _hotServiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
                _hotServiceButton.frame     = CGRectMake(0, 0,  20, 21);
                [_hotServiceButton setBackgroundImage:SCIMAGE(@"monthHot_service")
                                            forState:UIControlStateNormal];
                [_hotServiceButton addTarget:self
                                     action:@selector(goToOnlineService)
                           forControlEvents:UIControlEventTouchUpInside];
                UIBarButtonItem *hotServiceItem = [[UIBarButtonItem alloc] initWithCustomView:_hotServiceButton];
                NSArray *rightButtonItems = @[moreItem,hotServiceItem,shareItem];
                self.navigationItem.rightBarButtonItems = rightButtonItems;
            }
        }
        if (range2.location != NSNotFound)
        {
            content = [[item componentsSeparatedByString:@"="] lastObject];
            if ([SCUtilities isValidString:content])
            {
                [dic setObject:content forKey:@"content"];
            }
        }
        if (range3.location != NSNotFound)
        {
            shareUrl = [[item componentsSeparatedByString:@"="] lastObject];
            if ([SCUtilities isValidString:shareUrl])
            {
                [dic setObject:shareUrl forKey:@"shareUrl"];
            }
        }
        if (range4.location != NSNotFound)
        {
            channel = [[item componentsSeparatedByString:@"="] lastObject];
            if ([SCUtilities isValidString:channel])
            {
                [dic setObject:channel forKey:@"channel"];
            }
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"ShowShareParams"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return NO;
}

//是否显示分享
- (BOOL)displayshareonrightScheme : (NSString*) msg
{
    //       协议：displayshareonright://toShareOnRight?isShare=value1&content=value2&shareUrl=value3&channel=value4
    //       方法：toShareOnRight(isShare,content,shareUrl,channel)
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItems = nil;
    NSString *isShare   = @""; //是否分享
    NSString *content   = @"";//分享语
    NSString *shareUrl  = @""; //分享链接
    NSString *channel   = @""; //渠道号
    NSString *title     = @""; //标题
    NSString *picUrl    = @""; //图片url
    NSString *vwtId     = @""; //vwtId
    NSString *str       = [msg stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *tmpString = [[str componentsSeparatedByString:@"??"] lastObject];
    NSArray  *tmpArray  = [tmpString componentsSeparatedByString:@"#"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSString *item in tmpArray)
    {
        NSRange range1 = [item rangeOfString:@"isShare"];
        NSRange range2 = [item rangeOfString:@"content"];
        NSRange range3 = [item rangeOfString:@"shareUrl"];
        NSRange range4 = [item rangeOfString:@"channel"];
        NSRange range5 = [item rangeOfString:@"title"];
        NSRange range6 = [item rangeOfString:@"picUrl"];
        NSRange range7 = [item rangeOfString:@"msg_id"];
        if (range1.location != NSNotFound)
        {
            NSRange range = [item rangeOfString:@"isShare="];
            isShare       = [item substringFromIndex:range.length];
            if ([isShare  isEqual: @"1"])
            {
                [dic setObject:isShare forKey:@"isShare"];
            }
        }
        if (range2.location != NSNotFound)
        {
            NSRange range = [item rangeOfString:@"content="];
            content       = [item substringFromIndex:range.length];
            if ([SCUtilities isValidString:content])
            {
                [dic setObject:content forKey:@"content"];
            }
        }
        if (range3.location != NSNotFound)
        {
            NSRange range = [item rangeOfString:@"shareUrl="];
            shareUrl      = [item substringFromIndex:range.length];
            if ([SCUtilities isValidString:shareUrl])
            {
                [dic setObject:shareUrl forKey:@"shareUrl"];
            }
        }
        if (range4.location != NSNotFound)
        {
            NSRange range = [item rangeOfString:@"channel="];
            channel       = [item substringFromIndex:range.length];
            if ([SCUtilities isValidString:channel])
            {
                [dic setObject:channel forKey:@"channel"];
            }
        }
        if (range5.location != NSNotFound)
        {
            NSRange range = [item rangeOfString:@"title="];
            title         = [item substringFromIndex:range.length];
            if ([SCUtilities isValidString:title])
            {
                [dic setObject:title forKey:@"title"];
            }
        }
        if (range6.location != NSNotFound)
        {
            NSRange range = [item rangeOfString:@"picUrl="];
            picUrl        = [item substringFromIndex:range.length];
            if ([SCUtilities isValidString:picUrl])
            {
                [dic setObject:picUrl forKey:@"picUrl"];
                if (![[SDImageCache sharedImageCache] imageFromDiskCacheForKey:@(picUrl.hash).stringValue])
                {
                    [self downloadImage:picUrl andCacheKey:@(picUrl.hash).stringValue];
                }
            }
        }
        if (range7.location != NSNotFound)
        {
            NSRange range = [item rangeOfString:@"msg_id="];
            vwtId         = [item substringFromIndex:range.length];
            if ([SCUtilities isValidString:vwtId])
            {
                [dic setObject:vwtId forKey:@"msg_id"];
            }
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"ShowShareParams"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([SCUtilities isValidDictionary:dic] && [dic[@"isShare"] intValue]==1)
    {
        self.navigationItem.rightBarButtonItems = nil;
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareButton.frame = CGRectMake(CGRectGetWidth(self.view.frame)-28, (49-25)/2, 20, 21);
        [_shareButton setBackgroundImage:SCIMAGE(@"WebViewCustom_share")
                                forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareZzd)
               forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:_shareButton];
        
         _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
         _moreBtn.frame = CGRectMake(0,0, 20, 21);
         _moreBtn.backgroundColor = [UIColor clearColor];
         [_moreBtn setImage:SCIMAGE(@"yktfu_moredark") forState:UIControlStateNormal];
         [_moreBtn addTarget:self action:@selector(navigationFunctionTap:) forControlEvents:UIControlEventTouchUpInside];
         [_moreBtn setAdjustsImageWhenHighlighted:NO];
         UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithCustomView:_moreBtn];
        
        //客服
        _hotServiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _hotServiceButton.frame     = CGRectMake(0, 0,  20, 21);
        [_hotServiceButton setBackgroundImage:SCIMAGE(@"monthHot_service")
                                    forState:UIControlStateNormal];
        [_hotServiceButton addTarget:self
                             action:@selector(goToOnlineService)
                   forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *hotServiceItem = [[UIBarButtonItem alloc] initWithCustomView:_hotServiceButton];
        NSArray *rightButtonItems = @[moreItem,hotServiceItem,shareItem];
        self.navigationItem.rightBarButtonItems = rightButtonItems;
    }
    return NO;
}

//异网专区调通讯录
- (BOOL)networkAddressbook : (NSString*) msg
{
    //协议：networkcontact://getContactBook??parm1
    NSArray *params = [msg componentsSeparatedByString:@"??"];
   
    return NO;
}

//网页内调通讯录
- (BOOL)ecmcAppScheme : (NSString*) msg
{
   
    return NO;
}

#pragma mark UIButtonAction
- (void)shareVwt
{
    // 抓取当前页面
   
}

- (void)shareZzd
{
   
}

#pragma mark Download
- (void)downloadImage:(NSString *)url andCacheKey:(NSString *)key
{
    if ([SCUtilities isValidString:url]) {
        if (![[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key]) {
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager loadImageWithURL:[NSURL URLWithString:url]
                              options:0
                             progress:nil
                            completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                                // do something with image
                                if (image)
                                {
                                    [[SDImageCache sharedImageCache] storeImage:image forKey:key toDisk:YES completion:^{
                                        
                                    }];
                                }
                                
                            }];
//            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:url]
//                                                            options:0
//                                                           progress:nil
//                                                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                                                              if (image) {
//                                                                  [[SDImageCache sharedImageCache] storeImage:image forKey:key toDisk:YES];
//                                                              }
//                                                          }];
        }
    }
}

#pragma mark LoginViewDelegate
-(void)jumpto:(NSInteger)index
{

}

#pragma mark -设置标题方法

//协议：viewcontrollertitle:title
- (BOOL)refreshViewControllerTitle:(NSString *)titleString{
    if ([titleString containsString:@"viewcontrollertitle:"]) {
        NSString *string = [titleString substringFromIndex:[@"viewcontrollertitle:" length]];
        self.title = string;
    }
    return NO;
}

#pragma mark--加载js回调方法
- (void)jsCallBackOCFunction
{
    __block typeof(self) wkSelf = self;
    
    // H5回调获取 cmtokenid信息
//    if (!IS_RELEASE_ENVIRONMENT) {
//        [self.bridge registerHandler:@"scSetCookieBlock" handler:^(id data, WVJBResponseCallback responseCallback) {
//                NSString  *cmtokenid = [SCGetAuthToken cmtokenId];
//                NSString *userAreaNum = [SCGetAuthToken userAreaNum];
//                NSString *mallMobile = [SCGetAuthToken mallPhone];
//                NSDictionary *dic = @{@"cmtokenid":cmtokenid,@"userAreaNum":userAreaNum,@"mallMobile":mallMobile};
//                responseCallback(dic);
//
//            }];
//    }
  
    
    //隐藏页面标题栏
    [self.bridge registerHandler:@"scHideTitle" handler:^(id data, WVJBResponseCallback responseCallback) {

        wkSelf.jsIsHiddenNav = YES;
        [wkSelf.navigationController setNavigationBarHidden:YES animated:NO];

    }];
    
    //显示标题栏
    [self.bridge registerHandler:@"scShowTitle" handler:^(id data, WVJBResponseCallback responseCallback) {

         wkSelf.jsIsHiddenNav = NO;
        [wkSelf.navigationController setNavigationBarHidden:NO animated:NO];

    }];
    
    //关闭页面
    [self.bridge registerHandler:@"scClosePage" handler:^(id data, WVJBResponseCallback responseCallback) {
        [wkSelf shut:nil];
    }];
    
    //返回上一页，如果没有上一页关闭页面
    [self.bridge registerHandler:@"scGoBack" handler:^(id data, WVJBResponseCallback responseCallback) {
        [wkSelf next:nil];
    }];
    


}


#pragma mark --oc回调JS方法
-(void)ocCallBackJsFunction:(NSNotification *)notify{
    NSDictionary *info = notify.object;
    if ([SCUtilities isValidDictionary:info]) {
        NSString *name = info[@"name"];
        if ([SCUtilities isValidString:name]) {
            //回调js方法
            [self.bridge callHandler:name data:nil responseCallback:^(id responseData) {
                NSLog(@"...");
             }];
            
            //ztLoginCallBack  登陆成功回调JS的方法   本地掌厅登陆成功了
            if ([name isEqualToString:@"ztLoginCallBack"]) {
                 NSLog(@"--sc-- 登陆成功回调JS的方法并通知本地");
                 [self loginSuccessNotifity];  //本地 设置cookie - cmtokenid
            }
        }
    }
   
}

@end
