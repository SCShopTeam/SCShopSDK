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
#import "SCMainTabBarController.h"
#import "SCWitStoreViewController.h"
#import "SCCustomAlertController.h"
@implementation SCURLSerialization
static SCURLSerialization *urlSerialization = nil;
+(instancetype)shareSerialization{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        urlSerialization = [[SCURLSerialization alloc]init];
    });
    
    return urlSerialization;
}

-(void)gotoWebcustom:(NSString *)url title:(NSString *)title navigation:(UINavigationController *)nav{
    
    if ([SCUtilities isValidString:url] && ([url containsString:@"http"] || [url containsString:@"https"]) && nav != nil) {
        
        SCShoppingManager *manager = [SCShoppingManager sharedInstance];
        if (manager.delegate && [manager.delegate respondsToSelector:@selector(scWebWithUrl:title:nav:back:)]) {
            [manager.delegate scWebWithUrl:url title:title nav:nav back:^{
                
            }];
        }else{
            SCWebViewCustom *custom = [[SCWebViewCustom alloc]init];
            //        SCWebViewController *custom = [[SCWebViewController alloc]init];
            if ([SCUtilities isValidString:title]) {
                custom.title = title;
            }
            
            custom.urlString = url;
            [nav pushViewController:custom animated:YES];
        }
        
        
        
        
    }else{
        return;
    }
}

-(void)gotoController:(NSString *)url navigation:(UINavigationController *)nav{
    //jsmcc://M/5?tenantNum=TN00000010
    //phonestore://jumpToLogin
    if (![SCUtilities isValidString:url] || [url containsString:@"http"] || [url containsString:@"https"] ) {
        return;
    }
    
    if ([url hasPrefix:@"jsmcc://"]) {
        NSString *temp = [url substringFromIndex:8];
        NSMutableDictionary *paramDic;
        NSString *cmd = temp;
        
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
        
        if ([cmd isEqualToString:@"M/0"]) {
            NSString *sUrl = paramDic[@"url"];
            if ([SCUtilities isValidString:sUrl]) {
                NSString *url = [SCUtilities encodeURIComponent:sUrl];
                [self gotoWebcustom:url title:@"" navigation:nav];
            }
        }
        
        
        if ([cmd isEqualToString:@"M/1"] ||
            [cmd isEqualToString:@"M/2"] ||
            [cmd isEqualToString:@"M/3"] ||
            [cmd isEqualToString:@"M/4"]) {  //底部导航
            
            
            NSString *strNum = [cmd componentsSeparatedByString:@"/"].lastObject;
            NSInteger num = [strNum integerValue];
            
            UITabBarController *tabBar = [SCUtilities currentTabBarController];
            
            if (!tabBar) {
                
                if ( [SCShoppingManager sharedInstance].delegate && [[SCShoppingManager sharedInstance].delegate respondsToSelector:@selector(scGetUserInfo:)]) {
                    [[SCShoppingManager sharedInstance].delegate scGetUserInfo:^(BOOL success) {
                        if (success) {
                            [SCShoppingManager showMallPageFrom:nav pageType:num-1];
                        }
                    }];
                }
            }else{
                for (int i=0; i<tabBar.viewControllers.count; i++)
                {
                    UINavigationController *navCtr = [tabBar.viewControllers objectAtIndex:i];
                    [navCtr popToRootViewControllerAnimated:NO];
                }
                [tabBar setSelectedIndex:num-1];
            }
        }
        
        
        if ([cmd isEqualToString:@"M/5"]) { //商铺详情
            NSString *num = paramDic[@"tenantNum"];//[paramArr.lastObject componentsSeparatedByString:@"="].lastObject;
            SCStoreHomeViewController *shop = [[SCStoreHomeViewController alloc]init];
            shop.tenantNum = num;
            [nav pushViewController:shop animated:YES];
        }else if ([cmd isEqualToString:@"M/6"]){  //配件
            if ([SCUtilities isValidDictionary:paramDic]) {
                
                SCLifeViewController *tag = [[SCLifeViewController alloc]init];
                tag.paramDic = paramDic;
                [nav pushViewController:tag animated:YES];
            }
            
        }else if ([cmd isEqualToString:@"M/7"]){  //购物车
            SCCartViewController *cat = [[SCCartViewController alloc]init];
            [nav pushViewController:cat animated:YES];
        }else if ([cmd isEqualToString:@"M/8"]){ //智慧门店  原生
            SCWitStoreViewController *wit = [[SCWitStoreViewController alloc]init];
            [nav pushViewController:wit animated:YES];
        }
        
    }else if ([url hasPrefix:@"phonestore://"]){
        NSString *temp = [url substringFromIndex:13];
        if (![SCUtilities isValidString:temp]) {
            return;
        }
        
        if ([temp isEqualToString:@"jumpToLogin"]) {
            NSLog(@"--sc-- jumpToLogin调用登陆");
            
            SCShoppingManager *manager = [SCShoppingManager sharedInstance];
            if (manager.delegate && [manager.delegate respondsToSelector:@selector(scLoginWithNav:back:)]) {
                [manager.delegate scLoginWithNav:nav back:^(UIViewController * _Nonnull controller) {
                    SCUserInfo *userInfo = [SCUserInfo currentUser];
                    if (!userInfo.isJSMobile && userInfo.isLogin) {
                        [SCShoppingManager showDiffNetAlert:nav];
                        
                    }else{
                           //商城内部webView的通知H5登陆成功刷新页面，如果
                              [[NSNotificationCenter defaultCenter]postNotificationName:@"ocCallBackJsFunction" object:@{@"name":@"ztLoginCallBack"}];
                    }
      
                    
                }];
                
            }
        }
    }
}


-(void)ecmcJumpToShopWithUrl:(NSString *)url navigation:(UINavigationController *)nav delegate:(id)delegate{
    
    if (delegate && nav && [SCUtilities isValidString:url]) {
        
        [SCShoppingManager sharedInstance].delegate = delegate;
        
        if ([SCUtilities isValidString:url] && nav) {
            [self gotoController:url navigation:nav];
        }
    }
}

@end
