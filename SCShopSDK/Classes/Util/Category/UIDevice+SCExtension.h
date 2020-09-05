//
//  UIDevice+SCExtension.h
//  shopping
//
//  Created by gejunyu on 2020/8/26.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

//提取自yykit

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (SCExtension)

//更新到iPhone SE2
+ (NSString *)machineModelName;

+ (BOOL)isJailbroken;

@end

NS_ASSUME_NONNULL_END
