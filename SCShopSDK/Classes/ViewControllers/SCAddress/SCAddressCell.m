//
//  SCAddressCell.m
//  shopping
//
//  Created by zhangtao on 2020/7/10.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCAddressCell.h"

@implementation SCAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}

-(void)createUI{
    _useName = [[UILabel alloc]init];
    [self addSubview:_useName];
    _useName.font = [UIFont systemFontOfSize:15];
    _useName.textColor = HEX_RGB(@"#333333");
    
    _phoneNumber = [[UILabel alloc]init];
    [self addSubview:_phoneNumber];
    _phoneNumber.font = [UIFont systemFontOfSize:15];
    _phoneNumber.textColor = HEX_RGB(@"#333333");
    
    _defaultAdMark = [[UILabel alloc]init];
    [self addSubview:_defaultAdMark];
    _defaultAdMark.font = [UIFont boldSystemFontOfSize:11];
    _defaultAdMark.text = @"默认地址";
    _defaultAdMark.textAlignment = NSTextAlignmentCenter;
    _defaultAdMark.textColor = [UIColor whiteColor];
    _defaultAdMark.backgroundColor = HEX_RGB(@"#999999");
    _defaultAdMark.layer.cornerRadius = 9;
    _defaultAdMark.layer.masksToBounds = YES;
    _defaultAdMark.hidden = YES;
    
    _detailAddress = [[UILabel alloc]init];
    [self addSubview:_detailAddress];
    _detailAddress.numberOfLines = 0;
    _detailAddress.font = [UIFont systemFontOfSize:13];
    _detailAddress.textColor = HEX_RGB(@"#333333");
    
    UIImageView *leftImg = [[UIImageView alloc]init];
    [self addSubview:leftImg];
    leftImg.image = [UIImage sc_imageNamed:@"localIcon"];
    
    UIButton *deleteBtn = [[UIButton alloc]init];
    [self addSubview:deleteBtn];
    [deleteBtn setTitleColor:HEX_RGB(@"#666666") forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    deleteBtn.layer.cornerRadius = 10;
    deleteBtn.layer.borderWidth = 1;
    deleteBtn.layer.borderColor = HEX_RGB(@"#999999").CGColor;
    deleteBtn.layer.masksToBounds = YES;
    [deleteBtn setTag:0];
    [deleteBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *editBtn = [[UIButton alloc]init];
    [self addSubview:editBtn];
    [editBtn setTitleColor: HEX_RGB(@"#666666") forState:UIControlStateNormal];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    editBtn.layer.cornerRadius = 10;
    editBtn.layer.borderWidth = 1;
    editBtn.layer.borderColor =HEX_RGB(@"#999999").CGColor;
    editBtn.layer.masksToBounds = YES;
    [editBtn setTag:1];
    [editBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    [_useName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(15);
    }];
    
    [_phoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_useName.mas_top);
        make.left.mas_equalTo(_useName.mas_right).mas_offset(20);
    }];
    
    [_defaultAdMark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_useName.mas_top);
        make.left.equalTo(_phoneNumber.mas_right).mas_offset(10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(18);
    }];
    
    [leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(40*m6Scale);
        make.height.mas_equalTo(40*m6Scale);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [_detailAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImg.mas_right).mas_offset(15);
        make.top.equalTo(_phoneNumber.mas_bottom).mas_offset(14);
//        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self).mas_offset(-15);
    }];
    
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-15);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(editBtn.mas_left).mas_offset(-15);
        make.bottom.mas_equalTo(-15);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
}



-(void)setModel:(SCAddressModel *)model{
    _model = model;
    _useName.text = [self isString:model.realName];
    _phoneNumber.text =[self isString:model.mobile];
    
    NSString *pro = [SCUtilities isValidString:model.provinceName]?model.provinceName:@"";
    NSString *city = [SCUtilities isValidString:model.cityName]?model.cityName:@"";
    NSString *reg = [SCUtilities isValidString:model.regionName]?model.regionName:@"";
    NSString *detail =  [SCUtilities isValidString:model.detail]?model.detail:@"";
    NSString *allAddress = [NSString stringWithFormat:@"%@%@%@%@",pro,city,reg,detail];
    _detailAddress.text = allAddress;//[self isString:model.detail];
    _defaultAdMark.hidden = !model.isDefault;
}

-(void)click:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scAddressDoneClick: cell:)]) {
        addressClickType type = addressEditType;
        if (sender.tag == 0) {
            type = addressDeleteType;
        }else{
            type = addressEditType;
        }
        [self.delegate scAddressDoneClick:type cell:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(NSString *)isString:(id)obj{
    if ([SCUtilities isValidString:obj]) {
        return obj;
    }else{
        return @"";
    }
}

@end
