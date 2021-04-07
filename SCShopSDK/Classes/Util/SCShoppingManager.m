//
//  SCShoppingManager.m
//  shopping
//
//  Created by gejunyu on 2020/7/3.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCShoppingManager.h"
#import "SCHomeViewController.h"
#import "SCBaseNavigationController.h"
#import "SCLocationService.h"
#import "SCProgressHUD.h"


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
        [SCProgressHUD setDefaultStyle:SCProgressHUDStyleDark];
        [[SCLocationService sharedInstance] startLocation:nil]; //获取定位并缓存
    }
    return self;
}

- (void)setDelegate:(id<SCShoppingDelegate>)delegate
{
    if (!delegate) {
        return;
    }
    _delegate = delegate;
    
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

#pragma mark -Public
+ (void)openNetworkLog
{
    [SCNetworkManager openLog];
}

//首页
+ (UINavigationController *)homePage
{
    SCHomeViewController *homeVc = [SCHomeViewController new];
    homeVc.isMainTabVC = YES;
    SCBaseNavigationController *homeNav = [[SCBaseNavigationController alloc] initWithRootViewController:homeVc];
    
    return homeNav;
}

+ (void)clearCaches
{
    //图片
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    
    //数据库
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *sqlitePath = [docPath stringByAppendingPathComponent:SC_COMMON_SQLITE];
    [[NSFileManager defaultManager] removeItemAtPath:sqlitePath error:nil];
    
    //userdefaults
//    [NSUserDefaults standardUserDefaults] removeObjectForKey:<#(nonnull NSString *)#>
    
    //缓存
//    SCCacheManager
    
}


@end
