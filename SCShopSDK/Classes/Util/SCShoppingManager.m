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

//首页
+ (UINavigationController *)homePage
{
    SCHomeViewController *homeVc = [SCHomeViewController new];
    homeVc.isMainTabVC = YES;
    SCBaseNavigationController *homeNav = [[SCBaseNavigationController alloc] initWithRootViewController:homeVc];
    
    return homeNav;
}

@end
