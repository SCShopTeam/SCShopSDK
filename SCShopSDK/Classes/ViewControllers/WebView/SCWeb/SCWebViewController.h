//
//  SCWebViewController.h
//  shopping
//
//  Created by zhangtao on 2020/9/1.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCBaseViewController.h"


@interface SCWebViewController : SCBaseViewController

@property WKWebViewJavascriptBridge* bridge;

@property(nonatomic,strong)NSString *urlString;

@property(nonatomic,assign) BOOL jsIsHiddenNav ;


-(void)next:(id)sender;
- (void)shut:(id)sender;


//JS调用掌厅登陆，登陆成功设置cookie
-(void)loginSuccessNotifity;

@end

