//
//  SCMyOrderCell.m
//  shopping
//
//  Created by zhangtao on 2020/7/7.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCMyOrderCell.h"

@implementation SCMyOrderCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _commodityImgV = [UIImageView new];
        [self addSubview:_commodityImgV];
        _commodityImgV.contentMode = UIViewContentModeScaleAspectFit;
        [_commodityImgV mas_makeConstraints:^(MASConstraintMaker *make) {
               make.left.mas_equalTo(20);
               make.top.mas_equalTo(15);
               make.bottom.mas_equalTo(-15);
               make.width.mas_equalTo(_commodityImgV.mas_height);
           }];
        
        _nameLab = [UILabel new];
        _nameLab.numberOfLines = 2;
        [self addSubview:_nameLab];
        _nameLab.font = [UIFont systemFontOfSize:14];
        _nameLab.textColor = HEX_RGB(@"#333333");
        [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_commodityImgV.mas_right).mas_offset(15);
            make.right.mas_equalTo(-45);
            make.top.equalTo(_commodityImgV);
           }];
        
        _desLab = [UILabel new];
        [self addSubview:_desLab];
        _desLab.font = [UIFont systemFontOfSize:13];
        _desLab.textColor = HEX_RGB(@"#888888");
        [_desLab mas_makeConstraints:^(MASConstraintMaker *make) {
              make.left.equalTo(_nameLab.mas_left);
              make.top.equalTo(_commodityImgV.mas_centerY);
          }];
        
        UILabel *priceMark = [UILabel new];
        [self addSubview:priceMark];
        priceMark.text = @"¥";
        priceMark.font = [UIFont systemFontOfSize:12];
        priceMark.textColor = [UIColor redColor];
        [priceMark mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLab.mas_left);
            make.bottom.equalTo(_commodityImgV.mas_bottom);
        }];
        
        _priceLab = [UILabel new];
        [self addSubview:_priceLab];
        _priceLab.textColor = HEX_RGB(@"#F2270C");
        _priceLab.font = [UIFont boldSystemFontOfSize:13];
        [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(priceMark.mas_right).mas_offset(5);
            make.bottom.equalTo(priceMark.mas_bottom);
        }];
        
        UILabel *numMark = [UILabel new];
        [self addSubview:numMark];
        numMark.text = @"x";
        numMark.font = [UIFont systemFontOfSize:10];
        numMark.textColor = HEX_RGB(@"#A8A8A8");
        [numMark mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_priceLab.mas_right).mas_offset(10);
            make.bottom.equalTo(priceMark.mas_bottom);
        }];
        _numLab = [UILabel new];
        [self addSubview:_numLab];
        _numLab.font = [UIFont systemFontOfSize:12];
        _numLab.textColor= HEX_RGB(@"#A8A8A8");
        [_numLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(numMark.mas_right).mas_offset(5);
            make.bottom.equalTo(priceMark.mas_bottom);
        }];
    }
    return self;
}
//-(void)setGoodModel:(SCOrderGoodsModel *)goodModel{
////-(void)setDataDic:(NSDictionary *)dataDic{
////    if ([SCUtilities isValidDictionary:dataDic]) {
////        _dataDic = dataDic;
//    _goodModel = goodModel;
//    _commodityImgV.image = nil;
//    _nameLab.text = @"";
//    _desLab.text = @"";
//    _priceLab.text  = @"";
//    _numLab.text = @"";
//    
//    if (![_goodModel.picUrl isKindOfClass:[NSNull class]] && [SCUtilities isValidString:_goodModel.picUrl]) {
//        [_commodityImgV sd_setImageWithURL:[NSURL URLWithString:_goodModel.picUrl] placeholderImage:[UIImage sc_imageNamed:@"childCategory"]];
//    }else{
//        _commodityImgV.image = [UIImage sc_imageNamed:@"childCategory"];
//
//    }
//    _nameLab.text =_goodModel.goodsName;
//    _desLab.text = _goodModel.goodsTitle;
//    _priceLab.text = [NSString stringWithFormat:@"%.0f",_goodModel.dealMoney];
//    _numLab.text = [NSString stringWithFormat:@"%ld",_goodModel.goodsCount];
////    }
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
