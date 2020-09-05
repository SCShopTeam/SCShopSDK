//
//  SCAlertViewController.h
//  shopping
//
//  Created by zhangtao on 2020/8/26.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCAlertViewController : UIAlertController


-(void)showAlertAct1:(nullable NSString *)act1Name act2:(nullable NSString *)act2Name act1Back:(nullable void(^)(void))act1Back act2Back:(nullable void(^)(void))act2Back;


@end

NS_ASSUME_NONNULL_END
