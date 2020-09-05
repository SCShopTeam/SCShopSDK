//
//  SCWebViewController+JSCallBack.h
//  shopping
//
//  Created by zhangtao on 2020/9/1.
//  Copyright © 2020 jsmcc. All rights reserved.
//



#import "SCWebViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCWebViewController (JSCallBack)<UIActionSheetDelegate>

#pragma mark--加载js回调方法
- (void)jsCallBackOCFunc;

#pragma mark --oc回调JS方法
//
/// name :ocCallBackJsFunction
///  object: @{"name":jsFunc}
-(void)ocCallBackJsFunc:(NSNotification *)notify;


@end

NS_ASSUME_NONNULL_END
