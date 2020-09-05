//
//  SCShopCollectionCell.h
//  shopping
//
//  Created by gejunyu on 2020/7/7.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCCommodityModel.h"

NS_ASSUME_NONNULL_BEGIN

#define kCommodityItemW  SCREEN_FIX(163)
#define kCommodityItemH  SCREEN_FIX(240)

@interface SCShopCollectionCell : UICollectionViewCell
@property (nonatomic, strong) SCCommodityModel *model;

@end

NS_ASSUME_NONNULL_END
