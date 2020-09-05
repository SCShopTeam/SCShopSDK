//
//  SCWebViewController+JSCallBack.m
//  shopping
//
//  Created by zhangtao on 2020/9/1.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCWebViewController+JSCallBack.h"



@implementation SCWebViewController (JSCallBack)




#pragma mark--加载js回调方法
- (void)jsCallBackOCFunc{
    __block typeof(self) wkSelf = self;
    
    [self.bridge registerHandler:@"scSetCookieBlock" handler:^(id data, WVJBResponseCallback responseCallback) {
       
        NSString  *cmtokenid = [SCGetAuthToken cmtokenId];
        NSString *userAreaNum = [SCGetAuthToken userAreaNum];
        NSString *mallMobile = [SCGetAuthToken mallPhone];
      
        NSDictionary *dic = @{@"cmtokenid":cmtokenid,@"userAreaNum":userAreaNum,@"mallMobile":mallMobile};
        responseCallback(dic);
        
    }];
    
    //隐藏页面标题栏
    [self.bridge registerHandler:@"scHideTitle" handler:^(id data, WVJBResponseCallback responseCallback) {
        
       
        
        wkSelf.jsIsHiddenNav = YES;
        [wkSelf.navigationController setNavigationBarHidden:YES animated:NO];

//        responseCallback(dic);
    }];
    
    //显示标题栏
    [self.bridge registerHandler:@"scShowTitle" handler:^(id data, WVJBResponseCallback responseCallback) {

         wkSelf.jsIsHiddenNav = NO;
        [wkSelf.navigationController setNavigationBarHidden:NO animated:NO];

    }];
    
    //关闭页面
    [self.bridge registerHandler:@"scClosePage" handler:^(id data, WVJBResponseCallback responseCallback) {
      [wkSelf shut:nil];
    }];
    
    //返回上一页，如果没有上一页关闭页面
    [self.bridge registerHandler:@"scGoBack" handler:^(id data, WVJBResponseCallback responseCallback) {
        [wkSelf next:nil];
    }];
    


}


#pragma mark --oc回调JS方法
-(void)ocCallBackJsFunc:(NSNotification *)notify{
    NSDictionary *info = notify.object;
    if ([SCUtilities isValidDictionary:info]) {
        NSString *name = info[@"name"];
        if ([SCUtilities isValidString:name]) {
            
            
//            if ([name isEqualToString:@"scSetToken"]) {
//                NSString  *cmtokenid =[self getUnifyAuthToken:@"cmtokenid"];
//                NSString *userAreaNum = [self getUnifyAuthToken:@"userAreaNum"];
//                NSString *mallMobile = [SCUserInfo currentUser].phoneNumber;
//                mallMobile = [SCUtilities isValidString:mallMobile]?mallMobile:@"";
//                NSDictionary *dic = @{@"cmtokenid":cmtokenid,@"userAreaNum":userAreaNum,@"mallMobile":mallMobile};
//                [self.bridge callHandler:name data:dic responseCallback:^(id responseData) {
//                    NSLog(@"from js: %@", responseData);
//                }];
//            }
            //回调js方法
            [self.bridge callHandler:name data:nil responseCallback:^(id responseData) {
                NSLog(@"...");
             }];
            
            //ztLoginCallBack  登陆成功回调JS的方法   本地掌厅登陆成功了
            if ([name isEqualToString:@"ztLoginCallBack"]) {
                 NSLog(@"--sc-- 登陆成功回调JS的方法并通知本地");
                
                 [self loginSuccessNotifity];  //本地 设置cookie - cmtokenid
            }
        }
    }
   
}


//-(NSString *)getUnifyAuthToken:(NSString *)name{
//    return @"";
//}

@end
