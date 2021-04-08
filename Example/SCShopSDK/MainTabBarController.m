//
//  MainTabBarController.m
//  shopping
//
//  Created by gejunyu on 2021/2/26.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import "MainTabBarController.h"
#import "SCShoppingManager.h"
#import "SCTestViewController.h"

#define kTabImg(P)    [[UIImage imageNamed:P] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]

@interface MainTabBarController () <UITabBarControllerDelegate>

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    [self createTabs];
    
    [self setupTabBar];
    
//    [SCShoppingManager sharedInstance].networkLogBlock = ^(NSString * _Nonnull log) {
//        
//    };
    
}

- (void)createTabs
{
    UINavigationController *homeNav = [SCShoppingManager homePage];
    homeNav.topViewController.title = @"商城";
    homeNav.topViewController.tabBarItem.image = kTabImg(@"Tab_Home");
    homeNav.topViewController.tabBarItem.selectedImage = kTabImg(@"Tab_Home_selected");

    SCTestViewController *categoryVc = [SCTestViewController new];
    categoryVc.title = @"测试";
    categoryVc.tabBarItem.image = kTabImg(@"Tab_Category");
    categoryVc.tabBarItem.selectedImage = kTabImg(@"Tab_Category_selected");
    UINavigationController *categoryNav = [[UINavigationController alloc] initWithRootViewController:categoryVc];
    
    UIViewController *cartVc = [UIViewController new];
    cartVc.title = @"通信";
    cartVc.tabBarItem.image = kTabImg(@"Tab_Cart");
    cartVc.tabBarItem.selectedImage = kTabImg(@"Tab_Cart_selected");
    UINavigationController *cartNav = [[UINavigationController alloc] initWithRootViewController:cartVc];
    
    UIViewController *orderVc = [UIViewController new];
    orderVc.title = @"我的";
    orderVc.tabBarItem.image = kTabImg(@"Tab_MyOrder");
    orderVc.tabBarItem.selectedImage = kTabImg(@"Tab_MyOrder_selected");
    UINavigationController *orderNav = [[UINavigationController alloc] initWithRootViewController:orderVc];
    
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
    NSDictionary *normalTextAttributes   = @{NSForegroundColorAttributeName: [UIColor grayColor], NSFontAttributeName:[UIFont systemFontOfSize:10]};
    NSDictionary *selectedTextAttributes = @{NSForegroundColorAttributeName: [UIColor redColor], NSFontAttributeName:[UIFont systemFontOfSize:10]};

    for (UITabBarItem *item in self.tabBar.items) {
        [item setTitleTextAttributes:normalTextAttributes forState:UIControlStateNormal];
        [item setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];
    }
    
    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
//    //取消hud
//    UIViewController *vc = [SCUtilities currentViewController];
//    if ([vc isKindOfClass:.class]) {
//        SCBaseViewController *baseVc = (SCBaseViewController *)vc;
//        baseVc.isChangingTab = YES;
    
    return YES;
}

@end
