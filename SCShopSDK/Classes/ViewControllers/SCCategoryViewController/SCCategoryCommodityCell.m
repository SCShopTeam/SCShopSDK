//
//  SCCategoryCommodityCell.m
//  shopping
//
//  Created by zhangtao on 2020/7/8.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCCategoryCommodityCell.h"

@implementation SCCategoryCommodityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        _commodityImgV = [UIImageView new];
        [self addSubview:_commodityImgV];
        [_commodityImgV mas_makeConstraints:^(MASConstraintMaker *make) {
               make.left.mas_equalTo(16);
               make.top.mas_equalTo(26);
               make.bottom.mas_equalTo(-16);
               make.width.mas_equalTo(_commodityImgV.mas_height);
           }];
        
        _storeMarkLab = [UILabel new];
        [self addSubview:_storeMarkLab];
        _storeMarkLab.tintColor = [UIColor whiteColor];
        _storeMarkLab.font = [UIFont systemFontOfSize:8];
        _storeMarkLab.backgroundColor = [UIColor redColor];
        _storeMarkLab.layer.cornerRadius = 2;
        _storeMarkLab.layer.masksToBounds = YES;
        [_storeMarkLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_commodityImgV.mas_right).mas_offset(15);
            make.top.equalTo(_commodityImgV).mas_offset(5);
        }];
        
        _nameLab = [UILabel new];
        _nameLab.numberOfLines = 0;
        [self addSubview:_nameLab];
        _nameLab.font = [UIFont systemFontOfSize:12];
        [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
               make.left.mas_equalTo(_storeMarkLab.mas_right).mas_offset(10);
               make.top.equalTo(_commodityImgV).mas_offset(5);
            make.right.equalTo(self);
           }];
        
        _desLab = [UILabel new];
        [self addSubview:_desLab];
        _desLab.font = [UIFont systemFontOfSize:12];
        [_desLab mas_makeConstraints:^(MASConstraintMaker *make) {
              make.left.equalTo(_storeMarkLab.mas_left);
              make.centerY.equalTo(_commodityImgV.mas_centerY);
          }];
        
        UILabel *priceMark = [UILabel new];
        [self addSubview:priceMark];
        priceMark.text = @"¥";
        priceMark.font = [UIFont systemFontOfSize:8];
        priceMark.textColor = [UIColor redColor];
        [priceMark mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_storeMarkLab.mas_left);
            make.bottom.equalTo(_commodityImgV.mas_bottom).mas_offset(-10);
        }];
        
        _priceLab = [UILabel new];
        [self addSubview:_priceLab];
        _priceLab.font = [UIFont systemFontOfSize:10];
        _priceLab.textColor = [UIColor redColor];
        [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(priceMark.mas_right).mas_offset(5);
            make.bottom.equalTo(priceMark.mas_bottom);
        }];
    }
    return self;
}

-(void)setDataDic:(NSDictionary *)dataDic{
//    if ([Utilities isValidDictionary:dataDic]) {
//        _dataDic = dataDic;
    _storeMarkLab.text = @"自营";
    _commodityImgV.image = [UIImage bundleImageNamed:@"categoryCommodity"];
    _nameLab.text = @"测试数据测试数据";
    _desLab.text = @"测试数据测试数据";
    _priceLab.text = @"999";
//    }
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
