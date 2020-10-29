//
//  SCShoppingManager.m
//  shopping
//
//  Created by gejunyu on 2020/7/3.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCShoppingManager.h"
#import "SCMainTabBarController.h"
#import "NSTimer+SCAdditionProgress.h"
#import "SCWebViewCustom+JSCallback.h"
#import "NSData+SCBase64.h"
#import "SCProgressHUD.h"
#import "SCURLSerialization.h"
#import "SCLocationService.h"
#import "SCCustomAlertController.h"
@implementation SCShoppingManager

#pragma mark -SETUP
+ (instancetype)sharedInstance
{
    static SCShoppingManager *m;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m = [SCShoppingManager new];
    });
    return m;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupConfig];
        
        //>>>>删
        if ([SCUtilities isInShoppingDebug]) {
            [self testFakeData];
        }
        

    }
    return self;
}

- (void)setupConfig //一些初始化操作放在这个方法
{
    //弹框
//    [SCProgressHUD setDefaultMaskType:SCProgressHUDMaskTypeClear]; //这个方法可以使loading时所有交互事件无效
//    [SCProgressHUD setDefaultAnimationType:SCProgressHUDAnimationTypeNative];  //
    
    //登录接口
    NSLog(@"--sc-- 商城登陆");
    [SCRequest scLoginResultBlock:^(BOOL success, NSDictionary *objDic, NSString *errMsg) {
        if (success && [SCUtilities isValidDictionary:objDic]) {
            NSString *userRegion = objDic[@"userRegion"];
            if ([SCUtilities isValidString:userRegion]) {
                [SCRequestParams shareInstance].userRegion = userRegion;
            }
        }
    }];
    
}

//测试用假数据,模拟赋值
- (void)testFakeData
{
    //用户信息
    SCUserInfo *user = [SCUserInfo currentUser];
    user.isLogin = YES;
    user.phoneNumber = @"13401302424";
    user.isJSMobile = YES;
    user.uan = @"17";
    user.cmtokenid = @"9A970F2B54CF42F2948D6D581C4C1C52@js.ac.10086.cn";
    user.name = @"测试号";
    //定位
//    NSDictionary *locationInfo = @{@"cityCode": @"14",
//                                   @"latitude": @32.05725221596182,
//                                   @"longitude": @118.7405924432003,
//                                   @"City": @"南京市"};
//    self.locationInfo = locationInfo;
    
    //tab
    UITabBarController *tabVc = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    [SCUtilities registerTabBarController:tabVc];
    
}

+(void)showDiffNetAlert:(UINavigationController *)nav{
    SCCustomAlertController *alert = [[SCCustomAlertController alloc]init];
    [alert difNetAlertChangeNum:^{
        [[SCURLSerialization shareSerialization]gotoController:@"phonestore://jumpToLogin" navigation:nav];
    } difNet:^{
        [SCShoppingManager dissmissMallPage];
    }];
    
//    [nav presentViewController:alert animated:NO completion:nil];
    [nav pushViewController:alert animated:NO];
    alert.navigationController.navigationBar.hidden = NO;
}

#pragma mark -Public
+ (void)showMallPageFrom:(UIViewController *)vc
{
    [self showMallPageFrom:vc pageType:SCShopPageTypeHome];
}

+ (void)showMallPageFrom:(UIViewController *)vc pageType:(SCShopPageType)pageType
{
    if (!vc) {
        return;
    }
    
    SCMainTabBarController *tab = [SCMainTabBarController new];
    [vc presentViewController:tab animated:NO completion:nil];
    tab.selectedIndex = pageType;
    
    //注册tab
    [SCUtilities registerTabBarController:tab];
    
}



//退出商城
+ (void)dissmissMallPage
{
    if ([SCUtilities currentTabBarController]) {
        [[SCUtilities currentTabBarController] dismissViewControllerAnimated:NO completion:nil];
    }
    
    //清除相关数据
    [[self sharedInstance] cleanData];
}

- (void)cleanData
{
    //代理
    id delegate = self.delegate;
    delegate = nil;
    //地址信息
    self.locationInfo = @{};
    //定位
    [[SCLocationService sharedInstance] cleanData];
    //用户信息
    [[SCUserInfo currentUser] clear];
}

//#pragma mark -property
-(void)setUserInfo:(NSDictionary *)userInfo{
    SCUserInfo *info = [SCUserInfo currentUser];
    info.phoneNumber = userInfo[@"phoneNumber"];
    info.uan = userInfo[@"uan"];
    info.name = userInfo[@"name"];
    info.isJSMobile =  [userInfo[@"isJSMobile"] integerValue];
    info.isLogin = [userInfo[@"isLogin"] integerValue];
    
    info.cmtokenid = userInfo[@"cmtokenid"];
    
}

//-(NSString *)authToken{
//    if (!self.authToken) {
//       self.authToken = [SCUtilities getUnifyAuthToken:@"cmtokenid"];
//    }
//
//    return self.authToken;
//}

//-(void)setAuthToken:(NSString *)authToken{
//    _authToken = authToken;
//}

@end
