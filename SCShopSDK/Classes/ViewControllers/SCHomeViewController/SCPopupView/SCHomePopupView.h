//
//  SCHomePopupView.h
//  shopping
//
//  Created by gejunyu on 2020/10/23.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCHomeTouchModel.h"

typedef void(^SCPopupBlock)(SCHomeTouchModel * _Nonnull model);

NS_ASSUME_NONNULL_BEGIN

@interface SCHomePopupView : UIView

+ (void)showIn:(UIViewController *)vc model:(SCHomeTouchModel *)model clickBlock:(SCPopupBlock)clickBlock;

@end

NS_ASSUME_NONNULL_END
