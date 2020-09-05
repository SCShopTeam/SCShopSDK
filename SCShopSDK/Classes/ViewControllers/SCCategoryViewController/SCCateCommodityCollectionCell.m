//
//  SCCateCommodityCollectionCell.m
//  shopping
//
//  Created by zhangtao on 2020/7/14.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCCateCommodityCollectionCell.h"

@implementation SCCateCommodityCollectionCell



-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        [self createUI];
    }
    return self;
}

-(void)createUI{
    _commodityImgV = [[UIImageView alloc]init];
    [self addSubview:_commodityImgV];
    
    _commodityNameLab = [[UILabel alloc]init];
    [self addSubview:_commodityNameLab];
    _commodityNameLab.font = [UIFont systemFontOfSize:12];
    _commodityNameLab.textColor = HEX_RGB(@"#333333");
    _commodityNameLab.textAlignment = NSTextAlignmentCenter;
    
    [_commodityImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(self.mas_width);
    }];
    
    [_commodityNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_commodityImgV.mas_bottom).mas_offset(12);
        make.left.right.equalTo(self);
    }];
}

-(void)setDataDic:(NSDictionary *)dataDic{
    
    _dataDic = dataDic;
    _commodityImgV.image = [UIImage bundleImageNamed:@"categoryCommodity"];
    _commodityNameLab.text = @"商品名称";
}

@end
