//
//  SCMainTabBarController.m
//  shopping
//
//  Created by gejunyu on 2020/7/3.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCMainTabBarController.h"
#import "SCHomeViewController.h"
#import "SCCategoryViewController.h"
#import "SCCartViewController.h"
#import "SCMyOrderViewController.h"
#import "SCBaseNavigationController.h"
#import "SCShoppingManager.h"

#define kTabImg(P)    [SCIMAGE(P) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]

@interface SCMainTabBarController ()<UITabBarControllerDelegate>

@end

@implementation SCMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTabs];
    
    [self setupTabBar];
    
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.delegate = self;

}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    NSInteger index = tabBarController.selectedIndex;
    SCBaseNavigationController *currentNav = tabBarController.viewControllers[index];
    
    //取消hud
    UIViewController *vc = [SCUtilities currentViewController];
    [vc stopLoading];

    
    if ([viewController isKindOfClass:[SCBaseNavigationController class]]) {
        
        SCBaseNavigationController *nav = (SCBaseNavigationController *)viewController;
        NSString *className = NSStringFromClass([nav.viewControllers.firstObject class]);
        
        if (![className isEqualToString:@"SCCartViewController"] &&
        ![className isEqualToString:@"SCMyOrderViewController"]) {
            return YES;
        }
        
        if ( ![SCUserInfo currentUser].isLogin){
           SCShoppingManager *manager =  [SCShoppingManager sharedInstance];
            if (manager.delegate && [manager.delegate respondsToSelector:@selector(scLoginWithNav:back:)]) {
                [manager.delegate scLoginWithNav:currentNav back:^(UIViewController * _Nonnull controller) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:SC_LOGINED_NOTIFICATION object:nil];
                    SCUserInfo *info = [SCUserInfo currentUser];
                    if (info.isLogin && !info.isJSMobile) {
                        [SCShoppingManager showDiffNetAlert:currentNav];
                    }else{
                        [self tabBarController:tabBarController shouldSelectViewController:viewController];
                    }
                }];
            }
            return NO;
            
        }else if (![SCUserInfo currentUser].isJSMobile){
            [SCShoppingManager showDiffNetAlert:currentNav];
            return NO;
            
        }else{
            return YES;
        }
    }
    
    

    
    
    return YES;
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    NSString *className = NSStringFromClass([((SCBaseNavigationController *)viewController).viewControllers.firstObject class]);
    NSString *code = @"";
    
    if ([SCUtilities isValidString:className]) {
        if ([className isEqualToString:@"SCHomeViewController"]) {
            code = @"IOS_T_NZDSC_Z01";
        }else if([className isEqualToString:@"SCCategoryViewController"]){
            code = @"IOS_T_NZDSC_Z02";
        }else if ([className isEqualToString:@"SCCartViewController"]){
            code = @"IOS_T_NZDSC_Z03";
        }else if ([className isEqualToString:@"SCMyOrderViewController"]){
            code = @"IOS_T_NZDSC_Z04";
        }
    }
    
    
    
    SCShoppingManager *manager = [SCShoppingManager sharedInstance];
    if (manager.delegate && [manager.delegate respondsToSelector:@selector(scXWMobStatMgrStr:url:inPage:)]) {
        [manager.delegate scXWMobStatMgrStr:code url:@"" inPage:/*className*/@"SCHomeViewController"];
    }
    
    
}

- (void)createTabs
{
    SCHomeViewController *homeVc = [SCHomeViewController new];
    homeVc.title = @"精选";
    homeVc.tabBarItem.image = kTabImg(@"Tab_Home");
    homeVc.tabBarItem.selectedImage = kTabImg(@"Tab_Home_selected");
    homeVc.isMainTabVC = YES;
    SCBaseNavigationController *homeNav = [[SCBaseNavigationController alloc] initWithRootViewController:homeVc];

    SCCategoryViewController *categoryVc = [SCCategoryViewController new];
    categoryVc.title = @"分类";
    categoryVc.tabBarItem.image = kTabImg(@"Tab_Category");
    categoryVc.tabBarItem.selectedImage = kTabImg(@"Tab_Category_selected");
    categoryVc.isMainTabVC = YES;
    SCBaseNavigationController *categoryNav = [[SCBaseNavigationController alloc] initWithRootViewController:categoryVc];
    
    SCCartViewController *cartVc = [SCCartViewController new];
    cartVc.title = @"购物车";
    cartVc.tabBarItem.image = kTabImg(@"Tab_Cart");
    cartVc.tabBarItem.selectedImage = kTabImg(@"Tab_Cart_selected");
    cartVc.isMainTabVC = YES;
    SCBaseNavigationController *cartNav = [[SCBaseNavigationController alloc] initWithRootViewController:cartVc];
    
    SCMyOrderViewController *orderVc = [SCMyOrderViewController new];
    orderVc.title = @"我的订单";
    orderVc.tabBarItem.image = kTabImg(@"Tab_MyOrder");
    orderVc.tabBarItem.selectedImage = kTabImg(@"Tab_MyOrder_selected");
    orderVc.isMainTabVC = YES;
    SCBaseNavigationController *orderNav = [[SCBaseNavigationController alloc] initWithRootViewController:orderVc];
    
    self.viewControllers = @[homeNav, categoryNav, cartNav, orderNav];

}

- (void)setupTabBar
{
//    self.tabBar.backgroundImage = [UIImage new];
//    self.tabBar.shadowImage     = [UIImage new];
    self.tabBar.barStyle     = UIBarStyleBlack;
    self.tabBar.translucent  = NO;
    self.tabBar.barTintColor = [UIColor whiteColor];
    //阴影
    self.tabBar.layer.shadowColor   = [UIColor lightGrayColor].CGColor;
    self.tabBar.layer.shadowOffset  = CGSizeMake(0, -1);
    self.tabBar.layer.shadowOpacity = 0.3;
    
    //字体颜色
    NSDictionary *normalTextAttributes   = @{NSForegroundColorAttributeName: HEX_RGB(@"#999999"), NSFontAttributeName:SCFONT_SIZED(10)};
    NSDictionary *selectedTextAttributes = @{NSForegroundColorAttributeName: HEX_RGB(@"#F2270C"), NSFontAttributeName:SCFONT_SIZED(10)};

    for (UITabBarItem *item in self.tabBar.items) {
        [item setTitleTextAttributes:normalTextAttributes forState:UIControlStateNormal];
        [item setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];
    }
    
    
}


@end
