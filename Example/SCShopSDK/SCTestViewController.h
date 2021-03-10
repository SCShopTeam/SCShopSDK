//
//  SCTestViewController.h
//  shopping
//
//  Created by gejunyu on 2021/3/1.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCTestViewController : UIViewController

+ (BOOL)isLogined;

@property (nonatomic, copy) void (^loginSuccessBlock)(void);

@end

NS_ASSUME_NONNULL_END
