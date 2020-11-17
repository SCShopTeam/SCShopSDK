//
//  SCCustomAlertController.h
//  shopping
//
//  Created by zhangtao on 2020/9/14.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCCustomAlertController : UIViewController

-(void)difNetAlertChangeNum:(void(^)(void))changeNum difNet:(void(^)(void))jumtDifNet;

@end

NS_ASSUME_NONNULL_END
