//
//  SCMyOrderHeaderView.m
//  shopping
//
//  Created by zhangtao on 2020/7/7.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCMyOrderHeaderView.h"

@implementation SCMyOrderHeaderView
{
    
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = [UIColor whiteColor];
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self addSubview:imgV];
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.width.mas_equalTo(19);
            make.height.mas_equalTo(16);
            make.centerY.mas_equalTo(self);
        }];
        imgV.image = [UIImage bundleImageNamed:@"sc_head_store_icon"];
        _nameLab = [[UILabel alloc]init];//WithFrame:CGRectMake(45, 10, frame.size.width-80, 25)];
        [self addSubview:_nameLab];
        _nameLab.font = [UIFont systemFontOfSize:15];
        _nameLab.textColor = HEX_RGB(@"#333333");
        [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.mas_equalTo(35);
        }];
        
        
        UIButton *btn = [[UIButton alloc]init];//initWithFrame:CGRectMake(frame.size.width-35, 10, 65, 25)];
        [btn setTitle:@"详情" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitleColor:HEX_RGB(@"#666666") forState:UIControlStateNormal];
        [btn setImage:[UIImage bundleImageNamed:@"sc_right_arrow"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(headClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.centerY.mas_equalTo(self);
            make.width.mas_equalTo(45);
        }];
        [btn layoutButtonWithEdgeInsetsStyle:XGButtonEdgeInsetsStyleRight imageTitleSpace:5];

        
        UIView *line = [[UIView alloc]init];
        [self addSubview:line];
        line.backgroundColor = HEX_RGB(@"#E1E1E1");
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.mas_equalTo(1);
        }];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(6, 6)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
        
        
    }
    return self;
}

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    _nameLab.text = @"storeName";
    
}

-(void)headClick{
    if (self.orderHeaderCallBack) {
        self.orderHeaderCallBack(@"www.baidu.com");
    }
}

@end
