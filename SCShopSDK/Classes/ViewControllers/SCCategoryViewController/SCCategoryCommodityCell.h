//
//  SCCategoryCommodityCell.h
//  shopping
//
//  Created by zhangtao on 2020/7/8.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCCategoryCommodityCell : UITableViewCell
//@property(nonatomic,strong)UIImageView *markImgV;  //左上角标
@property(nonatomic,strong)UIImageView *commodityImgV;
@property(nonatomic,strong)UILabel *storeMarkLab;
@property(nonatomic,strong)UILabel *nameLab;
@property(nonatomic,strong)UILabel *desLab;
@property(nonatomic,strong)UILabel *priceLab;

@property(nonatomic,strong)NSDictionary *dataDic;

@end

NS_ASSUME_NONNULL_END
