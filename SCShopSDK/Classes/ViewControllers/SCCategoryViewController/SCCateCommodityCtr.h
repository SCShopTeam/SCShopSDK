//
//  SCCateCommodityCtr.h
//  shopping
//
//  Created by zhangtao on 2020/7/24.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCateCommodityCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CagegoryCommodityDelegte <NSObject>

-(void)cagegoryCommodityClick:(SCCommodityModel *)model;

@end

@interface SCCateCommodityCtr : UITableViewController

@property(nonatomic,strong)NSArray<SCCommodityModel *> *sourceArrs;

@property(nonatomic,weak)id<CagegoryCommodityDelegte>delegate;

-(void)reloadData;

@end

NS_ASSUME_NONNULL_END
