//
//  SCCateCommodityCell.h
//  shopping
//
//  Created by zhangtao on 2020/7/24.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCommodityModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCCateCommodityCell : UITableViewCell

@property(nonatomic,strong)UIImageView *commodityImgV;

@property(nonatomic,strong)UILabel *markLab;

@property(nonatomic,strong)UILabel *commodityNameLab;
@property(nonatomic,strong)UILabel *currentPriceLab;
@property(nonatomic,strong)UILabel *oldPriceLab;

@property(nonatomic,strong) SCCommodityModel *model;


@end

NS_ASSUME_NONNULL_END
