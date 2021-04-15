//
//  SCURLSerialization.m
//  shopping
//
//  Created by zhangtao on 2020/7/27.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCURLSerialization.h"
#import "SCWebViewCustom.h"
#import "SCShoppingManager.h"
#import "SCStoreHomeViewController.h"
#import "SCLifeViewController.h"
#import "SCCartViewController.h"
#import "SCWitStoreViewController.h"
#import "SCHomeViewController.h"
#import "SCBaseNavigationController.h"
#import "SCMyOrderViewController.h"

@implementation SCURLSerialization

+ (void)gotoNewPage:(NSString *)url title:(NSString *)title navigation:(UINavigationController *)nav
{
    if (!VALID_STRING(url) || !nav) {
        return;
    }
    
    if ([url hasPrefix:@"http"]) {
        [self gotoWebcustom:url title:title navigation:nav];
        
    }else {
        [self gotoController:url navigation:nav];
    }
}

+ (void)gotoWebcustom:(NSString *)url title:(NSString *)title navigation:(UINavigationController *)nav
{
    if (!VALID_STRING(url) || ![url hasPrefix:@"http"] || !nav) {
        return;
    }
    
    
    SCShoppingManager *manager = [SCShoppingManager sharedInstance];
    if (manager.delegate && [manager.delegate respondsToSelector:@selector(scWebWithUrl:title:nav:)]) {
        [manager.delegate scWebWithUrl:url title:title nav:nav];
    }else{
        SCWebViewCustom *custom = [[SCWebViewCustom alloc]init];
        
        if ([SCUtilities isValidString:title]) {
            custom.title = title;
        }
        
        custom.urlString = url;
        [nav pushViewController:custom animated:YES];
    }
    
}

+ (void)gotoController:(NSString *)url navigation:(UINavigationController *)nav
{
    //jsmcc://M/5?tenantNum=TN00000010
    //phonestore://jumpToLogin
    if (![SCUtilities isValidString:url] || !nav) {
        return;
    }
    
    
    if ([url hasPrefix:@"jsmcc://"] && url.length > 8) {
        NSString *temp = [url substringFromIndex:8];
        NSMutableDictionary *paramDic;
        NSString *cmd = temp;
        
        
        if ([cmd containsString:@"M/0"]) {
            if (url.length > 16) {
                NSString *webUrl = [url substringFromIndex:16];
                [self gotoWebcustom:webUrl title:@"" navigation:nav];
            }
            
        } else {
            if ([temp containsString:@"?"]) {
                NSArray *tempArr = [temp componentsSeparatedByString:@"?"];
                cmd = tempArr.firstObject;
                if (tempArr.count>1) {
                    paramDic = [NSMutableDictionary dictionary];
                    NSArray *tempAgianArr = [tempArr.lastObject componentsSeparatedByString:@"&"];
                    for (NSString *str in tempAgianArr) {
                        if ([SCUtilities isValidString:str] && [str containsString:@"="]) {
                            NSArray *arr = [str componentsSeparatedByString:@"="];
                            if ([SCUtilities isValidArray:arr] && arr.count==2) {
                                [paramDic setValue:arr.lastObject forKey:arr.firstObject];
                            }
                        }
                    }
                }
            }
            
            [self gotoJsmcc:cmd navigation:nav paramDic:paramDic];
        }
        
        return;
    }
    
    
    
    if ([url hasPrefix:@"phonestore://"] && url.length > 13) {
        NSString *temp = [url substringFromIndex:13];
        if (![SCUtilities isValidString:temp]) {
            return;
        }
        
        if ([temp isEqualToString:@"jumpToLogin"]) {
            NSLog(@"--sc-- jumpToLogin调用登陆");
            
            if ([SCUserInfo currentUser].isLogin) {
                return;
            }
            
            SCShoppingManager *manager = [SCShoppingManager sharedInstance];
            
            if (manager.delegate && [manager.delegate respondsToSelector:@selector(scLoginWithNav:back:)]) {
                [manager.delegate scLoginWithNav:nav back:^ {
                    [SCUtilities postLoginSuccessNotification];
                    
                }];
                
            }
        }
        
        return;
    }
    
}

+ (void)gotoJsmcc:(NSString *)cmd navigation:(UINavigationController *)nav paramDic:(NSDictionary *)paramDic
{
    if (![cmd hasPrefix:@"M/"] || cmd.length < 3) {
        return;
    }
    
    NSInteger code = [[cmd substringFromIndex:2] integerValue];
    
    
    //商城首页
    if (code == SCJsmccCodeHome) {
        UITabBarController *tabBarVc = [SCUtilities currentTabBarController];
        
        if (!tabBarVc) {
            return;
        }
        
        __block BOOL isTabVc;
        
        [tabBarVc.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull tabVc, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([tabVc isKindOfClass:SCBaseNavigationController.class]) {
                SCBaseNavigationController *tabNav = (SCBaseNavigationController *)tabVc;
                if ([tabNav.viewControllers.firstObject isKindOfClass:SCHomeViewController.class]) {
                    [tabNav popToRootViewControllerAnimated:NO];
                    [tabBarVc setSelectedIndex:idx];
                    isTabVc = YES;
                    *stop = YES;
                }
            }
        }];
        
        if (!isTabVc) {
            [nav pushViewController:[SCHomeViewController new] animated:YES];
        }
        
        return;
    }
    
    //需要登录
    BOOL needLogin = code == SCJsmccCodeCart || code == SCJsmccCodeTabCart || code == SCJsmccCodeOrder;
    if (needLogin && ![SCUserInfo currentUser].isLogin) {
        SCShoppingManager *manager = [SCShoppingManager sharedInstance];
        if ([manager.delegate respondsToSelector:@selector(scLoginWithNav:back:)]) {
            [manager.delegate scLoginWithNav:nav back:^ {
                [SCUtilities postLoginSuccessNotification];
                //                [self gotoJsmcc:cmd navigation:nav paramDic:paramDic]; //>>标记  掌厅登录代理有bug，暂不执行
            }];
        }
        
        return;
    }
    
    //其它页面
    if (code == SCJsmccCodeOrder) { //我的订单  是原tab页
        SCMyOrderViewController *vc = [SCMyOrderViewController new];
        [nav pushViewController:vc animated:YES];
        
        [SCUtilities scXWMobStatMgrStr:@"IOS_T_NZDSC_Z04" url:@"" inPage:NSStringFromClass(SCHomeViewController.class)];
        
    }else if (code == SCJsmccCodeStoreInfo) { //商铺详情
        NSString *num = [paramDic safeStringValueForKey:@"tenantNum"];
        SCStoreHomeViewController *shop = [SCStoreHomeViewController new];
        shop.tenantNum = num;
        [nav pushViewController:shop animated:YES];
        
    }else if (code == SCJsmccCodeLife){  //智能生活
        SCLifeViewController *tag = [SCLifeViewController new];
        tag.paramDic = paramDic;
        [nav pushViewController:tag animated:YES];
        
    }else if (code == SCJsmccCodeTabCart || code == SCJsmccCodeCart){  //购物车  3是原tab页
        SCCartViewController *cat = [SCCartViewController new];
        [nav pushViewController:cat animated:YES];
        
        [SCUtilities scXWMobStatMgrStr:@"IOS_T_NZDSC_Z03" url:@"" inPage:NSStringFromClass(SCHomeViewController.class)];
        
    }else if (code == SCJsmccCodeWitStore){ //智慧门店  原生
        SCWitStoreViewController *wit = [SCWitStoreViewController new];
        [nav pushViewController:wit animated:YES];
        
    }
    
    
}

@end
