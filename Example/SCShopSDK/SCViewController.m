//
//  SCViewController.m
//  SCShopSDK
//
//  Created by gejunyu5 on 09/05/2020.
//  Copyright (c) 2020 gejunyu5. All rights reserved.
//

#import "SCViewController.h"
#import <SCShopSDK/SCShopSDK.h>

@interface SCViewController ()

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UIButton *btn = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"商城" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pushMall) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)pushMall
{
    NSDictionary *dict = @{@"latitude": @32.0827421719034,
                           @"longitude": @118.7776612494253,
                           @"cityCode": @"14"};
    [SCShoppingManager sharedInstance].locationInfo = dict;
    
    [SCShoppingManager showMallPageFrom:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
