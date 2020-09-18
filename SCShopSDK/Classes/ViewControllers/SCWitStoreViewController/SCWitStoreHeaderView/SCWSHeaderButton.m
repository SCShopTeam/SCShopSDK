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
    self.priceLabel.attributedText = [SCUtilities priceAttributedString:model.wholesalePrice font:SCFONT_SIZED(14.5) color:HEX_RGB(@"#FF3C34")];
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
        CGFloat margin = SCREEN_FIX(10);
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, self.titleLabel.bottom+SCREEN_FIX(5), self.qiangIcon.left - margin - SCREEN_FIX(5), SCREEN_FIX(22))];
        _priceLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_priceLabel];
    }
    return _priceLabel;
}

@end
