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

//- (void)gotoWebViewCustom:(NSString *)url
//     title:(NSString *)t
//navigation:(UINavigationController *)navigationController;


@end

NS_ASSUME_NONNULL_END
