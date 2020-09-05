//
//  SCMyOrderCell.h
//  shopping
//
//  Created by zhangtao on 2020/7/7.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCSCOrderModel.h"


@interface SCMyOrderCell : UITableViewCell

@property(nonatomic,strong)UIImageView *commodityImgV;
@property(nonatomic,strong)UILabel *nameLab;
@property(nonatomic,strong)UILabel *desLab;
@property(nonatomic,strong)UILabel *priceLab;
@property(nonatomic,strong)UILabel *numLab;

//@property(nonatomic,strong)SCOrderGoodsModel *goodModel;

@end


