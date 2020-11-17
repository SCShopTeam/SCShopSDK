//
//  SCURLSerialization.h
//  shopping
//
//  Created by zhangtao on 2020/7/27.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCURLSerialization : NSObject

+(instancetype)shareSerialization;

-(void)gotoWebcustom:(NSString *)url title:(NSString *)title navigation:(UINavigationController *)nav;

-(void)gotoController:(NSString *)url navigation:(UINavigationController *)nav;


/// 外部短地址跳转商城
/// @param url 短地址
/// @param nav navigationcontroller
/// @param delegate 商城的代理
-(void)ecmcJumpToShopWithUrl:(NSString *)url navigation:(UINavigationController *)nav delegate:(id)delegate;


@end

NS_ASSUME_NONNULL_END
