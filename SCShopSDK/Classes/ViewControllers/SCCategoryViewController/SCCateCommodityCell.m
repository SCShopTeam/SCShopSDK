//
//  SCCateCommodityCell.m
//  shopping
//
//  Created by zhangtao on 2020/7/24.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCCateCommodityCell.h"

@implementation SCCateCommodityCell

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
    _commodityImgV = [[UIImageView alloc]init];
    [self addSubview:_commodityImgV];
    
    _markLab = [[UILabel alloc]init];
    [self addSubview:_markLab];
    _markLab.font = [UIFont systemFontOfSize:12];
    _markLab.textColor = HEX_RGB(@"#FFFFFF");
    _markLab.backgroundColor = HEX_RGB(@"#DD365C");
    _markLab.layer.cornerRadius = 2.5;
    _markLab.layer.masksToBounds = YES;
    _markLab.textAlignment = NSTextAlignmentCenter;
    
    _commodityNameLab = [[UILabel alloc]init];
    [self addSubview:_commodityNameLab];
    _commodityNameLab.numberOfLines = 2;
    _commodityNameLab.font = [UIFont systemFontOfSize:14];
    _commodityNameLab.textColor = HEX_RGB(@"#333333");
    _commodityNameLab.textAlignment = NSTextAlignmentLeft;//NSTextAlignmentCenter;
    
    _currentPriceLab = [[UILabel alloc]init];
    [self addSubview:_currentPriceLab];
    _currentPriceLab.font = [UIFont systemFontOfSize:15];
    _currentPriceLab.textColor = HEX_RGB(@"#F2270C");
    
    _oldPriceLab = [[UILabel alloc]init];
    [self addSubview:_oldPriceLab];
    _oldPriceLab.font = [UIFont systemFontOfSize:9];
    _oldPriceLab.textColor = HEX_RGB(@"#7D7F82");
    
    [_commodityImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(1);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
        make.height.mas_equalTo(_commodityImgV.mas_width);
    }];
    
    [_markLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.left.mas_equalTo(_commodityImgV.mas_right).mas_offset(3);
        make.height.mas_equalTo(14);
    }];
    
    [_commodityNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.equalTo(_markLab.mas_right).mas_offset(3);
        make.right.mas_equalTo(self).mas_offset(-20);
    }];
    
    [_currentPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_commodityImgV.mas_right).mas_offset(3);
        make.bottom.mas_equalTo(-12);
    }];
    
    [_oldPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_currentPriceLab.mas_right).mas_offset(6.5);
        make.bottom.mas_equalTo(-12);
    }];
}

-(void)setModel:(SCCommodityModel *)model{

    
    _model = model;
    _commodityNameLab.text = @"";
    _markLab.text = @"";
    _currentPriceLab.attributedText = nil;
    _oldPriceLab.attributedText = nil;
    
    NSString *mark = model.tenantType;
    if ([SCUtilities isValidString:mark]) {
        if ([mark isEqualToString:@"1"]) {
            mark = @"自营";
        }else if ([mark isEqualToString:@"2"]){
            mark = @"他营";
        }else if ([mark isEqualToString:@"3"]){
            mark = @"门店";
        }else{
            mark = @"";
        }
    }
    if ([SCUtilities isValidString:mark]) {
        _markLab.text = mark;
        CGFloat width = [mark calculateWidthWithFont:[UIFont systemFontOfSize:12] height:14];
        [_markLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width+5);
        }];
    }else{
        [_markLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
    }
    if ([SCUtilities isValidString:model.picUrl]) {
        __block typeof(_commodityImgV) wkImg = _commodityImgV;
        [_commodityImgV sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:SCIMAGE(@"categoryCommodity") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {      
            
            UIImage *img = [image thumbWithSize:CGSizeZero];
            wkImg.image = img;
        }];
    }else{
        _commodityImgV.image = [UIImage bundleImageNamed:@"categoryCommodity"];
    }
    _commodityNameLab.text = model.categoryName;
    
    NSString *currentPrice = [NSString stringWithFormat:@"%@",[NSNumber numberWithFloat: model.minSalePrice]];
    NSString *nPrice = [@"¥" stringByAppendingString:currentPrice];
    NSMutableAttributedString *currentStr = [[NSMutableAttributedString alloc]initWithString:nPrice];
    [currentStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9]} range:NSMakeRange(0, 1)];
    _currentPriceLab.attributedText = currentStr;
    
    NSString *oldPrice = [NSString stringWithFormat:@"¥%@",[NSNumber numberWithFloat: model.minSuggPrice]];
    NSMutableAttributedString *oldStr = [[NSMutableAttributedString alloc]initWithString:oldPrice];
    [oldStr addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)} range:NSMakeRange(0, oldPrice.length)];
    _oldPriceLab.attributedText = oldStr;
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
