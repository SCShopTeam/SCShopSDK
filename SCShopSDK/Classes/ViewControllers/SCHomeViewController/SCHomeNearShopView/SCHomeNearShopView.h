//
//  SCHomeNearShopView.h
//  shopping
//
//  Created by gejunyu on 2020/8/20.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCHomeShopModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface SCHomeNearShopView : UICollectionReusableView
@property (nonatomic, strong) SCHomeShopModel *model;


@property (nonatomic, copy) void (^enterShopBlock)(SCHShopInfoModel *shopInfoModel);
@property (nonatomic, copy) void (^bannerBlock)(NSInteger index, SCHBannerModel *bannerModel);
@property (nonatomic, copy) void (^actBlock)(NSInteger index, SCHActImageModel *imgModel);


@end

NS_ASSUME_NONNULL_END
