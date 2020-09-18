//
//  SCBaseViewController.m
//  shopping
//
//  Created by gejunyu on 2020/7/3.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCBaseViewController.h"
#import "SCShoppingManager.h"

@interface SCBaseViewController () <UIGestureRecognizerDelegate>

@end

@implementation SCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //设置右滑返回手势的代理为自身 (这个手势模拟器可能无效，真机有效)
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;

    [self.navigationController setNavigationBarHidden:self.hideNavigationBar animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.hideNavigationBar) {
        if (_isChangingTab) {
            _isChangingTab = NO;
        }else {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }
        
    }
    
}


- (void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.navigationController /* && [[self.navigationController viewControllers] count] > 1 */) {
        self.navigationItem.leftBarButtonItem = [SCUtilities makeBarButtonWithIcon:SCIMAGE(@"newnavbar_back") target:self action:@selector(backBarButtonPressed) isLeft:YES];
        
    }
    
    

}

// 重载
- (void)backBarButtonPressed
{
    [self stopLoading];
    
    if (self == self.navigationController.viewControllers.firstObject) {
        [SCShoppingManager dissmissMallPage];
        
    }else {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
  
}

- (void)showLoading
{
    [super showLoading];
    self.view.userInteractionEnabled = NO;
}

- (void)stopLoading
{
    [super stopLoading];
    self.view.userInteractionEnabled = YES;
}

#pragma mark - UIGestureRecognizerDelegate
//这个方法是在手势将要激活前调用：返回YES允许右滑手势的激活，返回NO不允许右滑手势的激活
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.navigationController.interactivePopGestureRecognizer) {
        //屏蔽调用rootViewController的滑动返回手势，避免右滑返回手势引起死机问题
        if (self.navigationController.viewControllers.count < 2 ||
            self.navigationController.visibleViewController == [self.navigationController.viewControllers objectAtIndex:0]) {
            return NO;
        }
    }
    //这里就是非右滑手势调用的方法啦，统一允许激活
    return YES;
}


@end
