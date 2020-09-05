//
//  SCNearShopInfoView.h
//  shopping
//
//  Created by gejunyu on 2020/8/20.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCHShopInfoModel;

NS_ASSUME_NONNULL_BEGIN

@interface SCNearShopInfoView : UIView
@property (nonatomic, strong) SCHShopInfoModel *shopInfoModel;
@property (nonatomic, strong) NSArray <NSString *> *couponList;

@property (nonatomic, copy) void (^enterShopBlock)(SCHShopInfoModel *model);
@end

NS_ASSUME_NONNULL_END
