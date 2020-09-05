//
//  SCShopTableCell.h
//  shopping
//
//  Created by gejunyu on 2020/7/10.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCommodityModel.h"
#import "SCSearchItemModel.h"

#define kCommonShopRowH SCREEN_FIX(148)

NS_ASSUME_NONNULL_BEGIN

@interface SCShopTableCell : UITableViewCell

@property (nonatomic, strong) SCCommodityModel *model;
@property (nonatomic, strong) SCSearchItemModel *searchModel;


@end

NS_ASSUME_NONNULL_END
