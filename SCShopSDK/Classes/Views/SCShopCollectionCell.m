//
//  SCShopCollectionCell.m
//  shopping
//
//  Created by gejunyu on 2020/7/7.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCShopCollectionCell.h"

@interface SCShopCollectionCell ()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *oldPriceLabel;

@end

@implementation SCShopCollectionCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareUI];

    }
    return self;
}

- (void)prepareUI
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = SCREEN_FIX(5);
    self.contentView.layer.masksToBounds = YES;
    
    //阴影
    self.layer.shadowOffset  = CGSizeMake(0, 2);
    self.layer.shadowColor   = [UIColor lightGrayColor].CGColor;
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowRadius  = 4;
    self.layer.masksToBounds = NO;
    
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(SCREEN_FIX(5), SCREEN_FIX(5))];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = self.contentView.bounds;
//    maskLayer.path = maskPath.CGPath;
//    self.contentView.layer.mask = maskLayer;
}

- (void)setModel:(SCCommodityModel *)model
{
    _model = model;
    //图片
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:IMG_PLACE_HOLDER];
    
    //是否显示标签
    BOOL showTag = VALID_STRING(model.tenantTypeStr);
    self.tagLabel.text = model.tenantTypeStr;
    self.tagLabel.hidden = !showTag;
    
    //内容
    self.contentLabel.width = self.width - self.contentLabel.left*2;
    NSString *str = model.categoryTitle;
    if (showTag) {
        str = [NSString stringWithFormat:@"           %@",str];
    }
    self.contentLabel.attributedText = [str attributedStringWithLineSpacing:4];
    [self.contentLabel sizeToFit];
    
    
    //价格
//    self.priceLabel.text = @"¥1029";
    self.priceLabel.attributedText = [SCUtilities priceAttributedString:model.minSalePrice font:SCFONT_SIZED(18) color:HEX_RGB(@"#F2270C")];
    [self.priceLabel sizeToFit];
    
    //原价
    if (model.minSuggPrice <= 0) {
        self.oldPriceLabel.hidden = YES;
        
    }else {
        self.oldPriceLabel.hidden = NO;
        self.oldPriceLabel.attributedText = [SCUtilities oldPriceAttributedString:model.minSuggPrice font:SCFONT_SIZED(9) color:HEX_RGB(@"#7D7F82")];
        self.oldPriceLabel.left = self.priceLabel.right + SCREEN_FIX(4.5);
    }
    
}


#pragma mark -ui
- (UIImageView *)icon
{
    if (!_icon) {
        CGFloat wh = self.contentView.width;
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, wh, wh)];
        _icon.contentMode = UIViewContentModeScaleAspectFit;
        _icon.layer.masksToBounds = YES;
        [self.contentView addSubview:_icon];
    }
    return _icon;
}

- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, self.icon.bottom, self.contentView.width, 0.5)];
        _line.backgroundColor = HEX_RGB(@"#D3D3D2");
        [self.contentView addSubview:_line];
    }
    return _line;
}

- (UILabel *)tagLabel
{
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_FIX(12.5), self.line.bottom + SCREEN_FIX(8), SCREEN_FIX(30), SCREEN_FIX(14.5))];
        _tagLabel.backgroundColor = HEX_RGB(@"#DD365C");
        _tagLabel.textColor = [UIColor whiteColor];
        _tagLabel.font = SCFONT_SIZED(12);
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        _tagLabel.layer.cornerRadius = 2.5;
        _tagLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:_tagLabel];
    }
    return _tagLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:self.tagLabel.frame];
        _contentLabel.font = SCFONT_SIZED_FIX(13);
        _contentLabel.textColor = HEX_RGB(@"#333333");
        _contentLabel.numberOfLines = 2;
        [self.contentView addSubview:_contentLabel];
        [self.contentView insertSubview:_contentLabel belowSubview:self.tagLabel];
    }
    return _contentLabel;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.tagLabel.left, 0, 100, SCREEN_FIX(18))];
        _priceLabel.bottom = self.height - SCREEN_FIX(12);
        [self.contentView addSubview:_priceLabel];
    }
    return _priceLabel;
}

- (UILabel *)oldPriceLabel
{
    if (!_oldPriceLabel) {
        _oldPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, SCREEN_FIX(7))];
        _oldPriceLabel.bottom = _priceLabel.bottom - SCREEN_FIX(4);
        [self.contentView addSubview:_oldPriceLabel];
    }
    return _oldPriceLabel;
}

@end
