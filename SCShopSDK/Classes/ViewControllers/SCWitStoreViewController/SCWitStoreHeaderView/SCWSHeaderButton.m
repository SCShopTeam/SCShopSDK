//
//  SCWSHeaderButton.m
//  shopping
//
//  Created by gejunyu on 2020/8/28.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCWSHeaderButton.h"
#import "SCWitStoreGoodModel.h"

@interface SCWSHeaderButton ()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIImageView *qiangIcon;
@property (nonatomic, strong) UILabel *yuanLabel;

@end

@implementation SCWSHeaderButton

- (void)setModel:(SCWitStoreGoodModel *)model
{
    _model = model;

    //图片
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.goodsPictureUrl] placeholderImage:IMG_PLACE_HOLDER];
    
    //标题
    self.titleLabel.text = model.goodsName;
    
    //价格
    CGFloat price = model.wholesalePrice/1000*1.f;
    self.priceLabel.text = [SCUtilities removeFloatSuffix:price];
    [self.priceLabel sizeToFit];
    
    CGFloat edge = self.width - self.qiangIcon.left;
    CGFloat maxWidth = self.width - edge*2;
    self.priceLabel.width   = MIN(maxWidth, self.priceLabel.width);
    self.priceLabel.centerX = self.width/2;
    self.priceLabel.centerY = self.qiangIcon.centerY;
    
    self.yuanLabel.right  = self.priceLabel.left;
    self.yuanLabel.bottom = self.priceLabel.bottom;
}

#pragma mark -ui
- (UIImageView *)icon
{
    if (!_icon) {
        CGFloat wh = SCREEN_FIX(51);
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake((self.width-wh)/2, 0, wh, wh)];
        [self addSubview:_icon];
    }
    return _icon;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        CGFloat x = SCREEN_FIX(10);
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, self.icon.bottom+SCREEN_FIX(13), self.width-x*2, SCREEN_FIX(15))];
        _titleLabel.font = SCFONT_SIZED(11);
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIImageView *)qiangIcon
{
    if (!_qiangIcon) { //sc_wit_qiang
        CGFloat w = SCREEN_FIX(28);
        CGFloat h = SCREEN_FIX(27.5);
        _qiangIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - SCREEN_FIX(7.5) - w, self.titleLabel.bottom+SCREEN_FIX(2), w, h)];
        _qiangIcon.image = SCIMAGE(@"sc_wit_qiang");
        [self addSubview:_qiangIcon];
    }
    return _qiangIcon;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.font = SCFONT_SIZED(14.5);
        _priceLabel.textColor = HEX_RGB(@"#FF3C34");
        [self addSubview:_priceLabel];
    }
    return _priceLabel;
}

- (UILabel *)yuanLabel
{
    if (!_yuanLabel) {
        _yuanLabel = [UILabel new];
        _yuanLabel.font = SCFONT_SIZED(10);
        _yuanLabel.textColor = self.priceLabel.textColor;
        _yuanLabel.text = @"¥ ";
        [_yuanLabel sizeToFit];
        [self addSubview:_yuanLabel];
    }
    return _yuanLabel;
}

@end
