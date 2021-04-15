//
//  SCShopDelegateUtil.m
//  shopping
//
//  Created by gejunyu on 2021/3/1.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import "SCShopDelegateUtil.h"
#import "SCTestViewController.h"

@interface SCShopDelegateUtil () 

@end

@implementation SCShopDelegateUtil

+ (instancetype)sharedInstance
{
    static SCShopDelegateUtil *m;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m = [SCShopDelegateUtil new];
    });
    return m;
}

//登录
- (void)scLoginWithNav:(UINavigationController *)nav back:(nonnull void (^)(void))callBack
{
    SCTestViewController *vc = [SCTestViewController new];
    vc.title = @"需要登录";
    [nav pushViewController:vc animated:YES];
    
    
    vc.loginSuccessBlock = ^{
        if (callBack) {
            callBack();
        }
    };

}

//配置cookie
//- (void)scConfigCookiesWithUrl:(NSMutableURLRequest *)request wkweb:(WKWebView *)web
//{
//    
//}

//大数据插码
- (void)scXWMobStatMgrStr:(NSString *)coding url:(NSString *)url inPage:(NSString *)className
{
    
}

//触点
//获取触点数据
-(void)scADTouchDataFrom:(UIViewController *)viewController backData:(SC_ADTouchDataBlock)callBack
{
    NSDictionary *dict = @{@"SCDBBANNER_I":@{@"content":@[@{@"picUrl":@"http://wap.js.10086.cn/jsmccClient_img/ecmcServer/images/rec_resource/30725ab5dee54dc291439844f2e03641.png",
                                                            @"linkUrl": @"http://wap.js.10086.cn/nact/2204"},
                                                          @{@"picUrl":@"http://wap.js.10086.cn/jsmccClient_img/ecmcServer/images/rec_resource/77a9a0373014428e85bf6d30accabcf5.png",
                                                            @"linkUrl": @"http://wap.js.10086.cn/nact/2204"},
                                                          @{@"picUrl":@"http://wap.js.10086.cn/jsmccClient_img/ecmcServer/images/rec_resource/ca31256176734973b5915db2ce2bdd9a.jpg",
                                                            @"linkUrl": @"http://wap.js.10086.cn/nact/2204"}]
                                             
    },
                           @"SCSYCBLFC_I" : @{@"contactName" : @"商城首页侧边栏浮层",
                                              @"periodCount": @99,
                                              @"periodType":@"MONTH",
                                              @"cpmMax": @3,
                                              @"content":@[@{@"picUrl":@"http://wap.js.10086.cn/jsmccClient_img/ecmcServer/images/rec_resource/9504e3e32a6d404495de95e9307662a1.png",
                                                             @"linkUrl": @"http://wap.js.10086.cn/nact/2204",
                                                             @"contentNum": @"nlabtjgffds,d"}]},
                           @"SCSYZXDC_I" : @{@"contactName" : @"商城首页中心弹窗",
                                             @"periodCount": @99,
                                             @"periodType":@"MONTH",
                                             @"cpmMax": @5,
                                             @"content":@[@{@"picUrl":@"http://wap.js.10086.cn/jsmccClient_img/ecmcServer/images/rec_resource/9504e3e32a6d404495de95e9307662a1.png",
                                                            @"linkUrl": @"http://wap.js.10086.cn/nact/2204",
                                                            @"contentNum": @"sddskghasxc31"}]},
                           @"SCSYDBYXDC_I" : @{@"contactName" : @"商城首页底部异形弹窗",
                                               @"periodCount": @99,
                                               @"periodType":@"MONTH",
                                               @"cpmMax": @5,
                                               @"content":@[@{@"picUrl":@"http://wap.js.10086.cn/jsmccClient_img/ecmcServer/images/rec_resource/9504e3e32a6d404495de95e9307662a1.png",
                                                              @"linkUrl": @"http://wap.js.10086.cn/nact/2204",
                                                              @"contentNum": @"sdfskmgfhg2131"}]},
                           @"SCSYDYGG_I":@{@"contactName":@"商城首页第一宫格",
                                           @"content":@[@{@"picUrl":@"http://wap.js.10086.cn/jsmccClient_img/ecmcServer/images/rec_resource/b92ab880f8984f9690c082e4a66671a5.png",
                                                          @"txt":@"官方好店",
                                                          @"linkUrl":@"jsmcc://M/8",
                                                          @"isLogin":@"0"}]
                           },
                           @"SCSYDEGG_I":@{@"contactName":@"商城首页第二宫格",
                                           @"content":@[@{@"picUrl":@"http://wap.js.10086.cn/jsmccClient_img/ecmcServer/images/rec_resource/a5dc0757e5154a50a13c8e1e014bca2e.png",
                                                          @"txt":@"移动好货",
                                                          @"linkUrl":@"jsmcc://M/5?tenantNum=supp329910042810",
                                                          @"isLogin":@"0"}]
                           },
                           @"SCSYDSGG_I":@{@"contactName":@"商城首页第三宫格",
                                           @"content":@[@{@"picUrl":@"http://wap.js.10086.cn/jsmccClient_img/ecmcServer/images/rec_resource/b92ab880f8984f9690c082e4a66671a5.png",
                                                          @"txt":@"智能生活",
                                                          @"linkUrl":@"jsmcc://M/6",
                                                          @"isLogin":@"1"}]
                           },
                           @"SCSYDSGG1_I":@{@"contactName":@"商城首页第四宫格",
                                           @"content":@[@{@"picUrl":@"http://wap.js.10086.cn/jsmccClient_img/ecmcServer/images/rec_resource/8c29be7e8c714a1eb30c4f9b06980a50.gif",
                                                          @"txt":@"今日爆款",
                                                          @"linkUrl":@"https://wx.apollojs.cn/limited-web/limitedDiscount?source=zt0027&storeId=10242466&storeCode=14100025",
                                                          @"isLogin":@"1"}]
                           },
                           @"SCSYDWGG_I":@{@"contactName":@"商城首页第五宫格",
                                           @"content":@[@{@"picUrl":@"http://wap.js.10086.cn/jsmccClient_img/ecmcServer/images/rec_resource/b92ab880f8984f9690c082e4a66671a5.png",
                                                          @"txt":@"官方好店",
                                                          @"linkUrl":@"jsmcc://M/8",
                                                          @"isLogin":@"1"}]
                           },
                           @"SCSYDLGG_I":@{@"contactName":@"商城首页第六宫格",
                                           @"content":@[@{@"picUrl":@"http://wap.js.10086.cn/jsmccClient_img/ecmcServer/images/rec_resource/b92ab880f8984f9690c082e4a66671a5.png",
                                                          @"txt":@"移动好货",
                                                          @"linkUrl":@"jsmcc://M/5?tenantNum=supp329910042810",
                                                          @"isLogin":@"1"}]
                           },
                           @"SCSYDQGG_I":@{@"contactName":@"商城首页第七宫格",
                                           @"content":@[@{@"picUrl":@"http://wap.js.10086.cn/jsmccClient_img/ecmcServer/images/rec_resource/b92ab880f8984f9690c082e4a66671a5.png",
                                                          @"txt":@"智能生活",
                                                          @"linkUrl":@"jsmcc://M/6",
                                                          @"isLogin":@"1"}]
                           },
                           @"SCSYDBGG_I":@{@"contactName":@"商城首页第八宫格",
                                           @"content":@[@{@"picUrl":@"http://wap.js.10086.cn/jsmccClient_img/ecmcServer/images/rec_resource/a5dc0757e5154a50a13c8e1e014bca2e.png",
                                                          @"txt":@"今日爆款",
                                                          @"linkUrl":@"https://wx.apollojs.cn/limited-web/limitedDiscount?source=zt0027&storeId=10242466&storeCode=14100025",@"isLogin":@"1"}]
                           },
                           @"DBBQLFL_I":@{@"contactName":@"顶部标签栏福利",
                                           @"content":@[@{@"picUrl":@"http://wap.js.10086.cn/jsmccClient_img/ecmcServer/images/rec_resource/992df0f7079c4b0fa564d49080ba59b3.png",@"txt":@"抢话费",@"linkUrl":@"https://wap.js.10086.cn/nact/resource/2438/html/index.html",@"isLogin":@"0"}]
                           },
                           @"DBBQLHD_I":@{@"contactName":@"顶部标签栏活动",
                                           @"content":@[@{@"picUrl":@"http://wap.js.10086.cn/jsmccClient_img/ecmcServer/images/rec_resource/56eee8000e7145378da09a8b3a401416.png",@"txt":@"爆款秒杀",@"linkUrl":@"https://wx.apollojs.cn/limited-web/limitedDiscount?source=zt0075&storeId=10242466&storeCode=14100025",@"isLogin":@"0"}]
                           },
    };
   
    callBack(dict);
}

//处理触点点击
-(void)scADTouchClick:(NSDictionary *)dic
{
    
}
//触点曝光处理
-(void)scADTouchShow:(NSDictionary *)dic
{
    
}

//搜索
- (void)scSearch:(NSString *)text backData:(SC_SearchBlock)callBack
{
    
    NSDictionary *row = @{@"columns":@[@{@"name":@"F_SEARCH_ID",@"value":@"b84d80ba13291fb2e053acdc200afcd4"},
                                       @{@"name":@"F_SHOP_NAME",@"value":@"江苏移动官方旗舰店"},
                                       @{@"name":@"F_TYPE",@"value":@"S"},
                                       @{@"name":@"F_IS_LOGIN",@"value":@"0"},
                                       @{@"name":@"F_TSECTION_NUM",@"value":@"ios_new_goods_section"},
                                       @{@"name":@"t_introduce",@"value":@"颜色-秘银色-制式-5G-内存-8GB+128GB"},
                                       @{@"name":@"F_TSECTION_NAME",@"value":@"新商品"},
                                       @{@"name":@"t_busi_num",@"value":@"b84d80ba13291fb2e053acdc200afcd4"},
                                       @{@"name":@"F_GOODS_SOURCE",@"value":@"自营"},
                                       @{@"name":@"F_TARGET_ID",@"value":@"c671cb0d8b4e420fa0cec20650dcbc3c"},
                                       @{@"name":@"rate",@"value":@"6499"},
                                       @{@"name":@"t_busi_image",@"value":@"http://wap.js.10086.cn/ex/mallfiles/web/upload/category/images/supp329910042810/20210113142757914834016.jpg"},
                                       @{@"name":@"F_SOURCE_ID",@"value":@"590575c368b14bcc9929a64715670444"},
                                       @{@"name":@"F_LINE_PRICE",@"value":@"6499"},
                                       @{@"name":@"F_TSECTION_ID",@"value":@"f537d2c3dcdd4b02abc3037872ee51cc"}],
                          @"title": @"华为Mate 40 Pro 5G权益版 秘银色 5G 8GB+128GB ",
                          @"url": @"http://wap.js.10086.cn/ex/mall/pages/goodsDetails.html?categoryNum=2000107"
    };
    
    NSDictionary *dict = @{@"success":@"0",@"message":@"查询成功!",@"code":@"200",@"result":@{@"rows":@[row]}};
    
    callBack(dict,nil);
    
}

//web
//- (void)scWebWithUrl:(NSString *)urlStr title:(NSString *)title nav:(UINavigationController *)nav
//{
//    
//}

- (void)scMoreSelect:(SCShopMoreType)type nav:(UINavigationController *)nav
{
    UIViewController *vc = [UIViewController new];
    [nav pushViewController:vc animated:YES];
}

//获取用户信息
- (NSDictionary *)scGetUserInfo
{
    if (![SCTestViewController isLogined]) {
        return nil;
    }

    NSDictionary *userInfo = @{@"isLogin":@"1",
                               @"phoneNumber":@"15251803168",
                               @"isJSMobile":@"1",
                               @"uan":@"14",
                               @"cmtokenid": @"9A17D5404EE3445F987F564FB872AE30@js.ac.10086.cn",
                               @"name": @"测试号"
    };
    
    return userInfo;
}

- (void)scNetworkLog:(NSString *)requestNum responseObject:(id)responseObject error:(NSError *)error
{
//    NSLog(@"%@ : %@", requestNum, error ? @"failure" : @"success");
}

//获取定位
//- (NSDictionary *)scGetLocationInfo
//{
//    NSDictionary *locationInfo = @{@"cityCode": @"14",
//                                   @"latitude": @32.05719667166901,
//                                   @"longitude": @118.7403349462312,
//                                   @"City": @"南京市",
//                                   @"locationAddress":@"江苏省南京市鼓楼区江东街道南京市鼓楼区草场门大街101号文荟大厦文荟大厦12楼"
//    };
//
//    return locationInfo;
//}

@end
