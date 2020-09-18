//
//  SCGoodStoreCell.m
//  shopping
//
//  Created by gejunyu on 2020/8/17.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCGoodStoreCell.h"

@interface SCShowItemButton : UIControl
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) SCHActImageModel *imgModel;
@end


@interface SCGoodStoreCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *styleIcon;
@property (nonatomic, strong) NSArray <UILabel *> *couponLabelList; //优惠券
@property (nonatomic, strong) UILabel *couponTipLabel;
@property (nonatomic, strong) NSArray <SCShowItemButton *> *itemList;
@property (nonatomic, strong) UIButton *enterShopBtn; //进店逛逛
@property (nonatomic, strong) UIView *line;

@end

@implementation SCGoodStoreCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self enterShopBtn];
        [self line];
    }
    return self;
}

- (void)setModel:(SCHomeStoreModel *)model
{
    _model = model;
    
    if (model.shopInfo) {
        //标题
        self.titleLabel.text = model.shopInfo.storeName;
        [self.titleLabel sizeToFit];
        
        //类型
        if (VALID_STRING(model.shopInfo.label)) {
            self.styleIcon.hidden = NO;
            [self.styleIcon setTitle:model.shopInfo.label forState:UIControlStateNormal];
            self.styleIcon.left = self.titleLabel.right + SCREEN_FIX(4.5);
            
        }else {
            self.styleIcon.hidden = YES;
        }
    }

    
    //折扣 优惠券
    self.couponTipLabel.hidden = model.couponList.count > 0;
    
    NSString *tip = VALID_STRING(model.shopInfo.defaultStr) ? model.shopInfo.defaultStr : @"逛智慧门店，立享会员服务";
    self.couponTipLabel.text = tip;
    
    [self.couponLabelList enumerateObjectsUsingBlock:^(UILabel * _Nonnull label, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx >= model.couponList.count) {
            label.hidden = YES;
            
        }else {
            label.hidden = NO;
            
            NSString *str = model.couponList[idx];
            CGFloat width = [str calculateWidthWithFont:label.font height:label.height] + SCREEN_FIX(6);
            label.width = MAX(SCREEN_FIX(62.5), width);
            label.text = str;
            
        }
    }];
    

    //活动商品
    NSMutableArray *shopList = [NSMutableArray array];
    
    for (SCHActModel *actModel in model.actList) {
        [shopList addObjectsFromArray:actModel.actImageList];
    }
    
    
    [self.itemList enumerateObjectsUsingBlock:^(SCShowItemButton * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx >= shopList.count) {
            button.hidden = YES;
            
        }else {
            button.hidden = NO;
            button.imgModel = shopList[idx];
            
        }
        
    }];
    
}

- (void)itemSelected:(SCShowItemButton *)sender
{
    NSInteger index = [self.itemList indexOfObject:sender];
    if (self.imgBlock) {
        self.imgBlock(index, sender.imgModel);
    }
}


#pragma mark -UI
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_FIX(19), SCREEN_FIX(11.5), 0, SCREEN_FIX(16))];
        _titleLabel.font = SCFONT_SIZED(17);
        _titleLabel.textColor = [UIColor blackColor];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIButton *)styleIcon
{
    if (!_styleIcon) {
        _styleIcon = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_FIX(11), SCREEN_FIX(29), SCREEN_FIX(14.5))];
        [_styleIcon setBackgroundImage:SCIMAGE(@"sc_home_store_type") forState:UIControlStateNormal];
        [_styleIcon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _styleIcon.titleLabel.font = SCFONT_SIZED(11);
        _styleIcon.userInteractionEnabled = NO;
        [self addSubview:_styleIcon];
    }
    return _styleIcon;
}

- (UILabel *)couponTipLabel
{
    if (!_couponTipLabel) {
        _couponTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_FIX(18), SCREEN_FIX(43.5), SCREEN_FIX(75), SCREEN_FIX(55))];
        _couponTipLabel.textColor = [UIColor grayColor];
        _couponTipLabel.font = SCFONT_SIZED_FIX(11);
        _couponTipLabel.numberOfLines = 2;
        [self addSubview:_couponTipLabel];
    }
    return _couponTipLabel;
}

- (NSArray<UILabel *> *)couponLabelList
{
    if (!_couponLabelList) {
        NSMutableArray *mulArr = [NSMutableArray arrayWithCapacity:2];
        
        CGFloat h = SCREEN_FIX(19.5);
        for (int i=0; i<2; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_FIX(19.5), SCREEN_FIX(43.5) + (h+SCREEN_FIX(10))*i, SCREEN_FIX(62.5), h)];
            label.layer.cornerRadius = 2.5;
            label.layer.borderWidth = 0.5;
            label.layer.borderColor = HEX_RGB(@"#FE6763").CGColor;
            label.layer.masksToBounds = YES;
            label.textColor = HEX_RGB(@"#FE6763");
            label.font = SCFONT_SIZED(12);
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
            [mulArr addObject:label];
        }
        _couponLabelList = mulArr.copy;

    }
    return _couponLabelList;
}


- (UIButton *)enterShopBtn
{
    if (!_enterShopBtn) {
        _enterShopBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_FIX(18), SCREEN_FIX(110.5), SCREEN_FIX(70), SCREEN_FIX(23))];
        _enterShopBtn.backgroundColor = HEX_RGB(@"#3778EC");
        _enterShopBtn.layer.cornerRadius = _enterShopBtn.height/2;
        _enterShopBtn.layer.masksToBounds = YES;
        _enterShopBtn.titleLabel.font = SCFONT_SIZED(13);
        [_enterShopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_enterShopBtn setTitle:@"进店逛逛" forState:UIControlStateNormal];
        _enterShopBtn.userInteractionEnabled = NO;
//        @weakify(self)
//        [_enterShopBtn sc_addEventTouchUpInsideHandle:^(UIButton * _Nonnull sender) {
//            @strongify(self)
//            if (self.enterShopBlock && self.model.shopInfo) {
//                self.enterShopBlock(self.model.shopInfo);
//            }
//        }];
        
        [self addSubview:_enterShopBtn];
    }
    return _enterShopBtn;
}

- (NSArray<SCShowItemButton *> *)itemList
{
    if (!_itemList) {
        NSMutableArray *mulArr = [NSMutableArray arrayWithCapacity:3];
        CGFloat w = SCREEN_FIX(80);
        CGFloat margin = SCREEN_FIX(4);
        CGFloat x = SCREEN_FIX(102.5);
        for (int i=0; i<3; i++) {
            SCShowItemButton *btn = [[SCShowItemButton alloc] initWithFrame:CGRectMake(x, SCREEN_FIX(39.5), w, SCREEN_FIX(98.5))];
            [self addSubview:btn];
            [btn addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
            [mulArr addObject:btn];
            
            //分隔线
            if (i<2) {
                UIView *sepline = [[UIView alloc] initWithFrame:CGRectMake(btn.right + margin, btn.top, 0.5, btn.height)];
                sepline.backgroundColor = HEX_RGB(@"#CCCCCC");
                [self addSubview:sepline];
                x = sepline.right + margin;
            }

        }
        _itemList = mulArr.copy;

    }
    return _itemList;
}

- (UIView *)line
{
    if (!_line) {
        CGFloat margin = SCREEN_FIX(14.5);
        _line = [[UIView alloc] initWithFrame:CGRectMake(margin, kGoodStoreRowH - 0.5, SCREEN_WIDTH-margin*2, 0.5)];
        _line.backgroundColor = HEX_RGB(@"#DBDBDB");
        [self.contentView addSubview:_line];
    }
    return _line;
}

@end


@implementation SCShowItemButton

- (void)setImgModel:(SCHActImageModel *)imgModel
{
    _imgModel = imgModel;

    [self.icon sd_setImageWithURL:[NSURL URLWithString:imgModel.actImageUrl] placeholderImage:IMG_PLACE_HOLDER];
    self.titleLabel.text = imgModel.sellingPoint;
}

- (UIImageView *)icon
{
    if (!_icon) {
        CGFloat wh = self.width;
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, wh, wh)];
        _icon.contentMode = UIViewContentModeScaleAspectFill;
        _icon.layer.masksToBounds = YES;
        [self addSubview:_icon];
    }
    return _icon;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        CGFloat h = SCREEN_FIX(12);
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height-h, self.width, h)];
        _titleLabel.font = SCFONT_SIZED(12);
        _titleLabel.textColor = HEX_RGB(@"#F2270C");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}


@end
