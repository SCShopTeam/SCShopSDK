//
//  SCBaseViewController.h
//  shopping
//
//  Created by gejunyu on 2020/7/3.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCBaseViewController : UIViewController

@property (nonatomic, assign) BOOL isMainTabVC;        //是否是首页tab
@property (nonatomic, assign) BOOL hideNavigationBar;  //隐藏导航栏，同时防止闪黑
@property (nonatomic, assign) BOOL isChangingTab;

@end

NS_ASSUME_NONNULL_END
