//
//  SCWSHeaderButton.m
//  shopping
//
//  Created by gejunyu on 2020/8/28.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCWSHeaderButton.h"
#import "SCWitStoreGoodModel.h"
#import "SCHomeStoreModel.h"

@interface SCWSHeaderButton ()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIImageView *qiangIcon;
@property (nonatomic, strong) UILabel *yuanLabel;
@property (nonatomic, strong) UILabel *oldPriceLabel;
@property (nonatomic, strong) UIImageView *tagIcon;

@end

@implementation SCWSHeaderButton

- (void)setWitGoodModel:(SCWitStoreGoodModel *)witGoodModel
{
    _witGoodModel = witGoodModel;

    //图片
    [self.icon sd_setImageWithURL:[NSURL URLWithString:witGoodModel.goodsPictureUrl] placeholderImage:IMG_PLACE_HOLDER];
    
    //标题
    self.titleLabel.text = witGoodModel.goodsName;
    
    //价格
    CGFloat price = witGoodModel.wholesalePrice/1000*1.f;
    self.priceLabel.text = [SCUtilities removeFloatSuffix:price];
    [self.priceLabel sizeToFit];
    
    CGFloat edge = self.width - self.qiangIcon.left;
    CGFloat maxWidth = self.width - edge*2;
    self.priceLabel.width   = MIN(maxWidth, self.priceLabel.width);
    self.priceLabel.centerX = self.width/2;
    self.priceLabel.centerY = self.qiangIcon.centerY;
    
//
    
    self.yuanLabel.right  = self.priceLabel.left;
    self.yuanLabel.bottom = self.priceLabel.bottom;
}

- (void)setHomeGoodsModel:(SCHomeGoodsModel *)homeGoodsModel
{
    _homeGoodsModel = homeGoodsModel;
    
    //图片
    [self.icon sd_setImageWithURL:[NSURL URLWithString:homeGoodsModel.goodsPictureUrl] placeholderImage:IMG_PLACE_HOLDER completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        CGFloat bigWh = self.titleLabel.top;
        CGFloat imgWh = MIN(bigWh, image.size.height);
        self.icon.size = CGSizeMake(imgWh, imgWh);
        self.icon.centerX = self.width/2;
    }];
    
    //标签
    [self.tagIcon sd_setImageWithURL:[NSURL URLWithString:homeGoodsModel.goodsLabel] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            CGFloat w = MIN(image.size.width, SCREEN_FIX(25));
            CGFloat h = (image.size.height/image.size.width)*w;
            self.tagIcon.size = CGSizeMake(w, h);
        }
    }];
    
    
    //标题
    self.titleLabel.text = homeGoodsModel.goodsName;
    
    //划线价
    CGFloat oldPrice = homeGoodsModel.guidePrice/1000*1.f;
    self.oldPriceLabel.attributedText = [SCUtilities oldPriceAttributedString:oldPrice font:self.oldPriceLabel.font color:self.oldPriceLabel.textColor];
    
    //价格
    CGFloat price = homeGoodsModel.wholesalePrice/1000*1.f;
    self.priceLabel.text = [SCUtilities removeFloatSuffix:price];
    [self.priceLabel sizeToFit];
    
    CGFloat edge = self.width - self.qiangIcon.left;
    CGFloat maxWidth = self.width - edge*2;
    self.priceLabel.width   = MIN(maxWidth, self.priceLabel.width);
    self.priceLabel.centerX = self.width/2;
    self.priceLabel.bottom = self.oldPriceLabel.top - SCREEN_FIX(3);
    
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

- (UIImageView *)tagIcon
{
    if (!_tagIcon) {
        _tagIcon = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_FIX(20), 0, 0, 0)];
        
        [self addSubview:_tagIcon];
    }
    return _tagIcon ;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        CGFloat x = SCREEN_FIX(10);
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, SCREEN_FIX(64), self.width-x*2, SCREEN_FIX(15))];
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
        _qiangIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - SCREEN_FIX(7.5) - w, self.height - SCREEN_FIX(3) - h, w, h)];
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
        _yuanLabel.font = SCFONT_SIZED_FIX(10);
        _yuanLabel.textColor = self.priceLabel.textColor;
        _yuanLabel.text = @"¥ ";
        [_yuanLabel sizeToFit];
        [self addSubview:_yuanLabel];
    }
    return _yuanLabel;
}

- (UILabel *)oldPriceLabel
{
    if (!_oldPriceLabel) {
        CGFloat h = SCREEN_FIX(9);
        _oldPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height - h, SCREEN_FIX(60), h)];
        _oldPriceLabel.centerX = self.width/2;
        _oldPriceLabel.textAlignment = NSTextAlignmentCenter;
        _oldPriceLabel.font = SCFONT_SIZED_FIX(9);
        _oldPriceLabel.textColor = HEX_RGB(@"#8D8D8D");
        [self addSubview:_oldPriceLabel];
    }
    return _oldPriceLabel;
}

@end
