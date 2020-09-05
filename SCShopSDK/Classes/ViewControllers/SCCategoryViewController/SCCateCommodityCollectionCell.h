//
//  SCCateCommodityCollectionCell.h
//  shopping
//
//  Created by zhangtao on 2020/7/14.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCCateCommodityCollectionCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *commodityImgV;
@property(nonatomic,strong)UILabel *commodityNameLab;

@property(nonatomic,strong)NSDictionary *dataDic;

@end

NS_ASSUME_NONNULL_END
