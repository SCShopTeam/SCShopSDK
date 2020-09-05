//
//  NSObject+SCHUD.m
//  shopping
//
//  Created by gejunyu on 2020/8/5.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "NSObject+SCHUD.h"
#import "SCProgressHUD.h"

static CGFloat kDelay = 1.5;

@implementation NSObject (SCHUD)

- (void)showLoading
{
    [SCProgressHUD show];
}

//- (void)showLoadingWithStatus:(NSString *)status {
//    [SCProgressHUD showWithStatus:status];
//}

- (void)showWithStatus:(NSString *)status {
    [self showWithStatusNoHide:status];
    [SCProgressHUD dismissWithDelay:kDelay];
}

- (void)showWithStatusNoHide:(NSString *)status //不自动隐藏
{
    [SCProgressHUD showImage:nil status:status];
}

- (void)showSuccess:(NSString *)success {
    [SCProgressHUD showSuccessWithStatus:success];
    [SCProgressHUD dismissWithDelay:kDelay];
}

- (void)showError:(NSString *)error {
    [SCProgressHUD showErrorWithStatus:error];
    [SCProgressHUD dismissWithDelay:kDelay];
}

- (void)showInfo:(NSString *)info
{
    [SCProgressHUD showInfoWithStatus:info];
    [SCProgressHUD dismissWithDelay:kDelay];
}

- (void)stopLoading {
    [SCProgressHUD dismiss];
}

//进度
- (void)showProgress:(CGFloat)progress
{
    [SCProgressHUD showProgress:progress];
}

@end
