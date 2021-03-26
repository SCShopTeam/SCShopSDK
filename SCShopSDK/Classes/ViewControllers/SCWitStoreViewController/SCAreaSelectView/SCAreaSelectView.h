//
//  SCAreaSelectView.h
//  shopping
//
//  Created by gejunyu on 2020/9/2.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCAreaModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^SCAreaBlock)(SCAreaModel *model);

@interface SCAreaSelectView : UIView

+ (void)showIn:(UIViewController *)vc areaList:(NSArray <SCAreaModel *> *)areaList selectBlock:(SCAreaBlock)selectBlock;

@end

NS_ASSUME_NONNULL_END
