//
//  SCHomeStoreCouponView.m
//  shopping
//
//  Created by gejunyu on 2021/3/8.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import "SCHomeStoreCouponView.h"
#import "SCWSHeaderButton.h"
#import "SCHomeStoreModel.h"

@interface SCHomeStoreCouponView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *couponIcon;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) NSArray <UILabel *> *couponLabelList;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) NSArray <SCWSHeaderButton *> *itemButtonList;

@end

@implementation SCHomeStoreCouponView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self moreButton];
    }
    return self;
}

- (void)setModel:(SCHomeStoreModel *)model
{
    _model = model;

    
    BOOL hasCoupons = model.couponList.count;
    
    //提示
    self.tipLabel.hidden = hasCoupons;

    //优惠券
    __block CGFloat x = self.couponIcon.right + SCREEN_FIX(4.5);
    
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:2];
    [model.couponList enumerateObjectsUsingBlock:^(SCHomeCouponModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < 2) { //最多显示两个
            [temp addObject:obj.limitDesc];
        }
    }];
    
    [self.couponLabelList enumerateObjectsUsingBlock:^(UILabel * _Nonnull label, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx >= temp.count || !hasCoupons) {
            label.hidden = YES;
            
        }else {
            label.hidden = NO;
            label.left = x;
            NSString *text = temp[idx];
            label.text = text;
            CGFloat textW = [text calculateWidthWithFont:label.font height:label.height];
            label.width = textW + SCREEN_FIX(8);
            x = label.right + SCREEN_FIX(6.5);
            
        }
    }];
    
    //按钮
    [self.itemButtonList enumerateObjectsUsingBlock:^(SCWSHeaderButton * _Nonnull btn, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx >= model.topGoodsList.count) {
            btn.hidden = YES;
            
        }else {
            btn.hidden = NO;
            SCHomeGoodsModel *goodsModel = model.topGoodsList[idx];
            btn.homeGoodsModel = goodsModel;
        }
    }];

}

#pragma mark -ui
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_FIX(22), SCREEN_FIX(8), 0, SCREEN_FIX(16))];
        _titleLabel.font = SCFONT_SIZED_FIX(16);
        _titleLabel.text = @"更多优惠";
        [_titleLabel sizeToFit];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

//icon
- (UIButton *)couponIcon
{
    if (!_couponIcon) {
        _couponIcon = [[UIButton alloc] initWithFrame:CGRectMake(self.titleLabel.right + SCREEN_FIX(4.5), 0, SCREEN_FIX(39), SCREEN_FIX(15))];
        _couponIcon.centerY = self.titleLabel.centerY;
        _couponIcon.userInteractionEnabled = NO;
        [_couponIcon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_couponIcon setTitle:@"优惠券" forState:UIControlStateNormal];
        [_couponIcon setBackgroundImage:SCIMAGE(@"home_coupon_icon") forState:UIControlStateNormal];
        _couponIcon.titleLabel.font = SCFONT_SIZED_FIX(10);
        [self addSubview:_couponIcon];
    }
    return _couponIcon;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.couponIcon.right + SCREEN_FIX(3), 0, SCREEN_FIX(132.5), SCREEN_FIX(15.5))];
        _tipLabel.centerY = self.titleLabel.centerY;
        _tipLabel.backgroundColor = HEX_RGB(@"#FFF8DC");
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = SCFONT_SIZED_FIX(10);
        _tipLabel.textColor = HEX_RGB(@"#FF7E15");
        _tipLabel.text = @"迎智慧门店，立享会员服务";
        [self addSubview:_tipLabel];
    }
    return _tipLabel;
}

- (NSArray<UILabel *> *)couponLabelList
{
    if (!_couponLabelList) {
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:2];
        
        for (int i=0; i<2; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, SCREEN_FIX(16.5))];
            label.centerY = self.titleLabel.centerY;
            label.layer.borderWidth = 1;
            label.layer.borderColor = HEX_RGB(@"#FF0300").CGColor;
            label.layer.cornerRadius = 3;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = SCFONT_SIZED_FIX(10);
            label.textColor = HEX_RGB(@"#FF0000");
            [self addSubview:label];
            [temp addObject:label];
        }
        
        _couponLabelList = temp.copy;
    }
    return _couponLabelList;
}

- (UIButton *)moreButton
{
    if (!_moreButton) {
        CGFloat w = SCREEN_FIX(56);
        _moreButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width - SCREEN_FIX(8.5) - w, SCREEN_FIX(13.5), w, SCREEN_FIX(11))];
        [_moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _moreButton.titleLabel.font = SCFONT_SIZED_FIX(11);
        [_moreButton setTitle:@"更多热销" forState:UIControlStateNormal];
        [_moreButton setImage:SCIMAGE(@"home_coupon_more") forState:UIControlStateNormal];
        [_moreButton layoutButtonWithEdgeInsetsStyle:XGButtonEdgeInsetsStyleRight imageTitleSpace:SCREEN_FIX(3.5)];
        
        @weakify(self)
        [_moreButton sc_addEventTouchUpInsideHandle:^(id  _Nonnull sender) {
            @strongify(self)
            if (self.pushBlock) {
                self.pushBlock();
            }
        }];
        
        [self addSubview:_moreButton];
    }
    return _moreButton;
}

- (NSArray<SCWSHeaderButton *> *)itemButtonList
{
    if (!_itemButtonList) {
        NSMutableArray *mulArr = [NSMutableArray arrayWithCapacity:3];
        
        CGFloat w = SCREEN_FIX(124.5);
        CGFloat h = SCREEN_FIX(115);
        
        CGFloat lineW = 1; //分隔线宽度
        CGFloat x = (self.width - w*3 - lineW*2)/2;
        
        CGFloat centerY = (self.height - self.titleLabel.bottom)/2 + self.titleLabel.bottom;

        for (int i=1; i<6; i++) {
            if (i%2) { //按钮
                SCWSHeaderButton *btn = [[SCWSHeaderButton alloc] initWithFrame:CGRectMake(x, 0, w, h)];
                btn.centerY = centerY;
                x = btn.right;
                [self addSubview:btn];
                [mulArr addObject:btn];
                
            }else {  // 分隔线
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, 0, lineW, SCREEN_FIX(115))];
                line.centerY = centerY;
                line.backgroundColor = HEX_RGB(@"#EEEEEE");
                [self addSubview:line];
                x = line.right;
            }
            
        }
        _itemButtonList = mulArr.copy;
        
    }
    return _itemButtonList;
}

@end
