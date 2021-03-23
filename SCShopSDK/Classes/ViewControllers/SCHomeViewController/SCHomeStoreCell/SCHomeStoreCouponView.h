//
//  SCHomeStoreCouponView.h
//  shopping
//
//  Created by gejunyu on 2021/3/8.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCHomeStoreModel;

NS_ASSUME_NONNULL_BEGIN

@interface SCHomeStoreCouponView : UIView

@property (nonatomic, strong) SCHomeStoreModel *model;

@property (nonatomic, copy) void (^pushBlock)(void);

@end

NS_ASSUME_NONNULL_END
