//
//  SCURLSerialization.h
//  shopping
//
//  Created by zhangtao on 2020/7/27.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SCJsmccCode) {
    SCJsmccCodeHome      = 1,  //首页
    SCJsmccCodeTabCart   = 3,  //tab位购物车 
    SCJsmccCodeOrder     = 4,  //我的订单
    SCJsmccCodeStoreInfo = 5,  //店铺详情
    SCJsmccCodeLife      = 6,  //智能生活
    SCJsmccCodeCart      = 7,  //购物车
    SCJsmccCodeWitStore  = 8   //智慧门店
};

#define SC_JSMCC_PATH(P) [NSString stringWithFormat:@"jsmcc://M/%li",P]

@interface SCURLSerialization : NSObject

//跳转新页面，内部判断网页还是原生页面
+ (void)gotoNewPage:(NSString *)url title:(NSString *)title navigation:(UINavigationController *)nav;

//跳转网页
+ (void)gotoWebcustom:(NSString *)url title:(NSString *)title navigation:(UINavigationController *)nav;

//跳转原生页
+ (void)gotoController:(NSString *)url navigation:(UINavigationController *)nav;


@end

NS_ASSUME_NONNULL_END
