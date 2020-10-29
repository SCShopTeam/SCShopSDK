//
//  SCFavouriteCell.m
//  shopping
//
//  Created by gejunyu on 2020/7/14.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCFavouriteCell.h"

@interface SCFavouriteCell ()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation SCFavouriteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setModel:(SCFavouriteModel *)model
{
    _model = model;
    //图片
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.itemThumb] placeholderImage:IMG_PLACE_HOLDER];
    
    //标题
    self.titleLabel.width = self.width - self.titleLabel.left - SCREEN_FIX(36);
    self.titleLabel.attributedText = [model.itemTitle attributedStringWithLineSpacing:3];
    [self.titleLabel sizeToFit];
    
    //价格
    self.priceLabel.attributedText = [SCUtilities priceAttributedString:model.itemPrice font:SCFONT_BOLD_SIZED(14) color:HEX_RGB(@"#F2270C")];
}

#pragma mark -ui
- (UIImageView *)icon
{
    if (!_icon) { //720*494
//        CGFloat w = SCREEN_FIX(131);
//        CGFloat h = w/720*494;
        CGFloat wh = SCREEN_FIX(90);
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_FIX(20), (self.height-wh)/2, wh, wh)];
        _icon.contentMode = UIViewContentModeScaleAspectFit;
        _icon.layer.masksToBounds = YES;
        [self.contentView addSubview:_icon];
    }
    return _icon;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.right + SCREEN_FIX(20), self.icon.top + SCREEN_FIX(3), 0, 0)];
        _titleLabel.font = SCFONT_SIZED(14);
        _titleLabel.textColor = HEX_RGB(@"#333333");
        _titleLabel.numberOfLines = 2;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.left, 0, 100, SCREEN_FIX(15))];
        _priceLabel.bottom = self.icon.bottom - SCREEN_FIX(3);
        [self.contentView addSubview:_priceLabel];
    }
    return _priceLabel;
}

@end
