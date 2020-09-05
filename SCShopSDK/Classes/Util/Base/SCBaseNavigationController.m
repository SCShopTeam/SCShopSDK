//
//  SCBaseNavigationController.m
//  shopping
//
//  Created by gejunyu on 2020/7/3.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCBaseNavigationController.h"
#import "SCBaseViewController.h"

@interface SCBaseNavigationController ()

@end

@implementation SCBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = [UIColor whiteColor];
    
//    [self.navigationBar setShadowImage:[[UIImage alloc]init]];
 
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:SCBaseViewController.class]) {
        SCBaseViewController *pushedVc = (SCBaseViewController *)viewController;
        
        pushedVc.hidesBottomBarWhenPushed = !pushedVc.isMainTabVC;
        
    }else {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


@end
