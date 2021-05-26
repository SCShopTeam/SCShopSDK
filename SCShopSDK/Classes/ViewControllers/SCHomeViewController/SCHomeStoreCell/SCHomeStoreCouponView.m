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
@property (nonatomic, strong) UIButton *couponIcon;
@property (nonatomic, strong) UILabel *tipLabel;
//@property (nonatomic, strong) UILabel *couponLabel;
@property (nonatomic, strong) UIView *couponView;
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

    //如果没有优惠券，或者优惠券类型是1 ,就显示提示语
    BOOL hideCoupons = model.couponList.count == 0 || [model.couponList.firstObject.couId isEqualToString:@"1"];
    
    if (hideCoupons) {
        self.couponView.hidden = YES;
        self.tipLabel.hidden = NO;
        NSString *tipStr = model.couponList.count > 0 ? model.couponList.firstObject.limitDesc : @"逛智慧门店，立享会员服务";
        self.tipLabel.text = tipStr;
        self.tipLabel.width = [tipStr calculateWidthWithFont:self.tipLabel.font height:self.tipLabel.height] + SCREEN_FIX(12);
        
    }else {
        self.tipLabel.hidden = YES;
        self.couponView.hidden = NO;
        [self createCouponLabels];
        
    }
    
    //商品
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

- (void)createCouponLabels
{
    for (UIView *subView in self.couponView.subviews) {
        [subView removeFromSuperview];
    }
    
    CGFloat x = 0;
    
    for (SCHomeCouponModel *coupon in _model.couponList) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, 0, _couponView.height)];
        label.layer.borderWidth = 1;
        label.layer.borderColor = HEX_RGB(@"#FF0300").CGColor;
        label.layer.cornerRadius = 3;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = SCFONT_SIZED_FIX(10);
        label.textColor = HEX_RGB(@"#FF0000");
        
        NSString *text = coupon.limitDesc;
        CGFloat textW = [text calculateWidthWithFont:label.font height:label.height] + SCREEN_FIX(8);
        
        label.width = textW;
        label.text = text;
        
        if (label.right > _couponView.width) {
            break;
        }
        
        [_couponView addSubview:label];
        
        x = label.right + SCREEN_FIX(2.5);
    }
   
}

#pragma mark -ui
//icon
- (UIButton *)couponIcon
{
    if (!_couponIcon) {
        _couponIcon = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_FIX(19.5), SCREEN_FIX(9.5), SCREEN_FIX(39), SCREEN_FIX(15))];
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
        _tipLabel.centerY = self.couponIcon.centerY;
        _tipLabel.backgroundColor = HEX_RGB(@"#FFF8DC");
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = SCFONT_SIZED_FIX(10);
        _tipLabel.textColor = HEX_RGB(@"#FF7E15");
        [self addSubview:_tipLabel];
    }
    return _tipLabel;
}

- (UIButton *)moreButton
{
    if (!_moreButton) {
        CGFloat w = SCREEN_FIX(36);
        _moreButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width - SCREEN_FIX(8.5) - w, SCREEN_FIX(7), w, SCREEN_FIX(20))];
        [_moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _moreButton.titleLabel.font = SCFONT_SIZED_FIX(11);
        [_moreButton setTitle:@"更多" forState:UIControlStateNormal];
        [_moreButton setImage:SCIMAGE(@"home_coupon_more") forState:UIControlStateNormal];
        [_moreButton layoutButtonWithEdgeInsetsStyle:XGButtonEdgeInsetsStyleRight imageTitleSpace:SCREEN_FIX(3.5)];
        
        @weakify(self)
        [_moreButton sc_addEventTouchUpInsideHandle:^(id  _Nonnull sender) {
            @strongify(self)
            if ([self.delegate respondsToSelector:@selector(pushToMoreGoods)]) {
                [self.delegate pushToMoreGoods];
            }
        }];
        
        [self addSubview:_moreButton];
    }
    return _moreButton;
}

- (UIView *)couponView
{
    if (!_couponView) {
        CGFloat x = self.couponIcon.right + SCREEN_FIX(4.5);
        CGFloat w = self.moreButton.left - x - SCREEN_FIX(2);
        _couponView = [[UIView alloc] initWithFrame:CGRectMake(x, 0, w, SCREEN_FIX(16.5))];
        _couponView.centerY = self.couponIcon.centerY;
        [self addSubview:_couponView];
    }
    return _couponView;
}

- (NSArray<SCWSHeaderButton *> *)itemButtonList
{
    if (!_itemButtonList) {
        NSMutableArray *mulArr = [NSMutableArray arrayWithCapacity:3];
        
        CGFloat w = SCREEN_FIX(124.5);
        CGFloat h = SCREEN_FIX(115);
        
        CGFloat lineW = 1; //分隔线宽度
        
        CGFloat x = (self.width - w*3 - lineW*2)/2;
        CGFloat y = SCREEN_FIX(35);
        
        for (int i=0; i<3; i++) {
            //按钮
            SCWSHeaderButton *btn = [[SCWSHeaderButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
            [self addSubview:btn];
            
            @weakify(self)
            [btn sc_addEventTouchUpInsideHandle:^(id  _Nonnull sender) {
                @strongify(self)
                if ([self.delegate respondsToSelector:@selector(pushToGoodDetail:)]) {
                    [self.delegate pushToGoodDetail:i];
                }
            }];
            
            [mulArr addObject:btn];
            
            //分隔线
            if (i < 2) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(btn.right, 0, lineW, SCREEN_FIX(115))];
                line.centerY = btn.centerY;
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
