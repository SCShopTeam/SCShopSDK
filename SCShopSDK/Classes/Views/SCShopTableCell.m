//
//  SCShopTableCell.m
//  shopping
//
//  Created by gejunyu on 2020/7/10.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCShopTableCell.h"

//typedef NS_ENUM(NSInteger, ShopShowType) {
//    ShopShowTypeSimple,      //简单信息   只有标题和价格
//    ShopShowTypeSearch       //搜索信息
//};

@interface SCShopTableCell ()
@property (nonatomic, strong) UIImageView *icon;    //图片
@property (nonatomic, strong) UILabel *titleLabel;      //标题
@property (nonatomic, strong) UILabel *tipLabel;        //简介
@property (nonatomic, strong) UILabel *titleTagLabel;   //标题标签(门店，自营)
@property (nonatomic, strong) UILabel *priceLabel;      //价格
@property (nonatomic, strong) UILabel *oldPriceLabel;   //原价
@property (nonatomic, strong) UILabel *shopLabel;       //商店
@property (nonatomic, strong) UILabel *addressLabel;    //地址
@property (nonatomic, strong) NSMutableArray <UIButton *> *tagBtnList;

//@property (nonatomic, assign) ShopShowType showType;

@end

@implementation SCShopTableCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSearchModel:(SCSearchItemModel *)searchModel
{
    //图片
    [self.icon sd_setImageWithURL:[NSURL URLWithString:searchModel.busiImage] placeholderImage:IMG_PLACE_HOLDER];
    
    //是否有标签
    BOOL showTag = VALID_STRING(searchModel.goodsSource);
    self.titleTagLabel.text = searchModel.goodsSource;
    self.titleTagLabel.hidden = !showTag;
    
    //标题
    NSString *str = searchModel.title;
    if (showTag) {
        str = [NSString stringWithFormat:@"          %@",str];
    }
    self.titleLabel.width = SCREEN_WIDTH - self.titleLabel.left - SCREEN_FIX(30);
    self.titleLabel.attributedText = [str attributedStringWithLineSpacing:4];
    [self.titleLabel sizeToFit];
    
    //价格
    self.priceLabel.attributedText = [SCUtilities priceAttributedString:searchModel.rate.floatValue font:SCFONT_BOLD_SIZED(15) color:HEX_RGB(@"#F2270C")];
    [self.priceLabel sizeToFit];
    self.priceLabel.height = 14;
    //原价
    if (searchModel.linePrice.floatValue <= searchModel.rate.floatValue) {
        self.oldPriceLabel.hidden = YES;
        
    }else {
        self.oldPriceLabel.hidden = NO;
        self.oldPriceLabel.attributedText = [SCUtilities oldPriceAttributedString:searchModel.linePrice.floatValue font:SCFONT_SIZED(10) color:HEX_RGB(@"#7D7F82")];
        self.oldPriceLabel.left = self.priceLabel.right + SCREEN_FIX(7);
    }
    
    //简介
    self.tipLabel.text = searchModel.labels;
    
    //地址
    NSAttributedString *att = [searchModel addressAttributedText];
    BOOL hasAddress = att.length > 0;
    if (hasAddress) {
        self.addressLabel.hidden = NO;
        self.addressLabel.attributedText = att;
    }else {
        self.addressLabel.hidden = YES;
    }


    //店名
    self.shopLabel.text = searchModel.shopName;
    self.shopLabel.bottom = hasAddress ? self.addressLabel.top - SCREEN_FIX(5) : self.addressLabel.bottom;
    
    //价格
    self.priceLabel.bottom = self.shopLabel.top - SCREEN_FIX(12.5);
    self.oldPriceLabel.bottom = self.priceLabel.bottom + SCREEN_FIX(2);

}

- (void)setModel:(SCCommodityModel *)model
{
    _model = model;
    //图片
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:IMG_PLACE_HOLDER completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        NSLog(@"%@",NSStringFromCGSize(image.size));
    }];
    
    //是否有标签
    BOOL showTag = VALID_STRING(model.tenantTypeStr);
    self.titleTagLabel.text = model.tenantTypeStr;
    self.titleTagLabel.hidden = !showTag;
    
    //标题
    NSString *str = model.categoryTitle;
    if (showTag) {
        str = [NSString stringWithFormat:@"          %@",str];
    }
    self.titleLabel.width = SCREEN_WIDTH - self.titleLabel.left - SCREEN_FIX(30);
    self.titleLabel.attributedText = [str attributedStringWithLineSpacing:4];
    [self.titleLabel sizeToFit];
    
    //价格
    self.priceLabel.attributedText = [SCUtilities priceAttributedString:model.minSalePrice font:SCFONT_BOLD_SIZED(18) color:HEX_RGB(@"#F2270C")];
    [self.priceLabel sizeToFit];
    self.priceLabel.height = 14;
    //原价
    if (model.minSuggPrice <= model.minSalePrice) {
        self.oldPriceLabel.hidden = YES;
        
    }else {
        self.oldPriceLabel.hidden = NO;
        self.oldPriceLabel.attributedText = [SCUtilities oldPriceAttributedString:model.minSuggPrice font:SCFONT_SIZED(12) color:HEX_RGB(@"#7D7F82")];
        self.oldPriceLabel.left = self.priceLabel.right + SCREEN_FIX(7);
    }
    
    self.priceLabel.bottom = self.icon.bottom - SCREEN_FIX(10);
    self.oldPriceLabel.bottom = self.priceLabel.bottom + SCREEN_FIX(2);
  
}

- (void)createTagButtons
{
    NSArray *tags = @[@"领券减30",@"包邮"];
    
    //先确定btn数量够不够，不够先添加
    if (tags.count > self.tagBtnList.count) {
        NSInteger num = tags.count - self.tagBtnList.count;
        
        for (int i=0; i<num; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.icon.top + SCREEN_FIX(83), 0, SCREEN_FIX(14))];
            btn.titleLabel.font = SCFONT_SIZED(9);
            [btn setTitleColor:HEX_RGB(@"#FF611F") forState:UIControlStateNormal];
            btn.layer.cornerRadius = 2.5;
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = HEX_RGB(@"#FF611F").CGColor;
            btn.layer.masksToBounds = YES;
            [self.contentView addSubview:btn];
            [self.tagBtnList addObject:btn];
        }
    }
    
    

    //赋值
    __block CGFloat x = self.titleTagLabel.left;
    [self.tagBtnList enumerateObjectsUsingBlock:^(UIButton * _Nonnull btn, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx >= tags.count) {
            btn.hidden = YES;
            
        }else {
            btn.hidden = NO;
            btn.left = x;
            
            NSString *tag = tags[idx];
            [btn setTitle:tag forState:UIControlStateNormal];
            CGFloat textW = [tag calculateWidthWithFont:btn.titleLabel.font height:btn.height];
            btn.width = textW + SCREEN_FIX(8);
            
            x = btn.right + SCREEN_FIX(5);
            
        }
    }];
}

#pragma mark -ui

- (UIImageView *)icon
{
    if (!_icon) {
//        CGFloat h = SCREEN_FIX(112);
        CGFloat wh = SCREEN_FIX(133.5);
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_FIX(10), (kCommonShopRowH-wh)/2, wh, wh)];
        _icon.contentMode = UIViewContentModeScaleAspectFill;
        _icon.layer.masksToBounds = YES;
        [self.contentView addSubview:_icon];

    }
    return _icon;
}

- (UILabel *)titleTagLabel
{
    if (!_titleTagLabel) {
        _titleTagLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.right + SCREEN_FIX(10), self.icon.top + SCREEN_FIX(10), SCREEN_FIX(29), SCREEN_FIX(14))];
        _titleTagLabel.backgroundColor = HEX_RGB(@"#F2270C");
        _titleTagLabel.textColor = [UIColor whiteColor];
        _titleTagLabel.font = SCFONT_SIZED(12);
        _titleTagLabel.textAlignment = NSTextAlignmentCenter;
        _titleTagLabel.layer.cornerRadius = 2.5;
        _titleTagLabel.layer.masksToBounds = YES;
        _titleTagLabel.text = @"自营";
        [self.contentView addSubview:_titleTagLabel];
    }
    return _titleTagLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        CGFloat x = self.titleTagLabel.left;

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, self.titleTagLabel.top - SCREEN_FIX(1), 0, 0)];
        _titleLabel.font = SCFONT_SIZED_FIX(14);
        _titleLabel.textColor = HEX_RGB(@"#333333");
        _titleLabel.numberOfLines = 2;
        [self.contentView addSubview:_titleLabel];
        [self.contentView insertSubview:_titleLabel belowSubview:self.titleTagLabel];
    }
    return _titleLabel;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        CGFloat x = self.titleTagLabel.left;
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, 100, SCREEN_FIX(18))];
        [self.contentView addSubview:_priceLabel];
    }
    return _priceLabel;
}

- (UILabel *)oldPriceLabel
{
    if (!_oldPriceLabel) {
        _oldPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, SCREEN_FIX(12))];
        [self.contentView addSubview:_oldPriceLabel];
    }
    return _oldPriceLabel;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleTagLabel.left, self.icon.top + SCREEN_FIX(50), 200, SCREEN_FIX(13))];
        _tipLabel.font = SCFONT_SIZED(13);
        _tipLabel.textColor = HEX_RGB(@"#888888");
        [self.contentView addSubview:_tipLabel];
    }
    return _tipLabel;
}

- (UILabel *)shopLabel
{
    if (!_shopLabel) {
        CGFloat x = self.titleTagLabel.left;
        _shopLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, SCREEN_FIX(200), SCREEN_FIX(11))];
        _shopLabel.bottom = self.icon.bottom + SCREEN_FIX(2);
        _shopLabel.font = SCFONT_SIZED(11);
        _shopLabel.textColor = HEX_RGB(@"#888888");
        [self.contentView addSubview:_shopLabel];
    }
    return _shopLabel;
}

- (UILabel *)addressLabel
{
    if (!_addressLabel) {
        CGFloat x = self.titleTagLabel.left;
        CGFloat h = SCREEN_FIX(10);
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, self.icon.bottom - h - SCREEN_FIX(10), SCREEN_WIDTH - x - SCREEN_FIX(40), SCREEN_FIX(10))];
        _addressLabel.textColor = HEX_RGB(@"#C0C0C0");
        _addressLabel.font = SCFONT_SIZED(10);
        [self.contentView addSubview:_addressLabel];
    }
    return _addressLabel;
}

- (NSMutableArray<UIButton *> *)tagBtnList
{
    if (!_tagBtnList) {
        _tagBtnList = [NSMutableArray array];

    }
    return _tagBtnList;
}


@end
