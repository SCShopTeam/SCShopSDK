//
//  SCRecommendStoreInfoView.m
//  shopping
//
//  Created by gejunyu on 2020/8/20.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCRecommendStoreInfoView.h"
#import "SCHomeStoreModel.h"

@interface SCRecommendStoreInfoView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *styleIcon;
@property (nonatomic, strong) UIButton *enterButton;
@property (nonatomic, strong) UILabel *couponTipLabel;
@property (nonatomic, strong) NSArray <UILabel *> *couponLabelList;

@end

@implementation SCRecommendStoreInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self enterButton];
    }
    return self;
}

- (void)setShopInfoModel:(SCHShopInfoModel *)shopInfoModel
{
    _shopInfoModel = shopInfoModel;
    
    if (!shopInfoModel) {
        return;
    }
    
    //标题
    self.titleLabel.text = shopInfoModel.storeName;
    [self.titleLabel sizeToFit];
    
    //类型
    if (VALID_STRING(shopInfoModel.label)) {
        self.styleIcon.hidden = NO;
        [self.styleIcon setTitle:shopInfoModel.label forState:UIControlStateNormal];
        self.styleIcon.left = self.titleLabel.right + SCREEN_FIX(4.5);
        
    }else {
        self.styleIcon.hidden = YES;
    }
    
    //默认提示
    self.couponTipLabel.text = VALID_STRING(shopInfoModel.defaultStr) ? shopInfoModel.defaultStr : @"逛智慧门店，立享会员服务";

}

- (void)setCouponList:(NSArray<NSString *> *)couponList
{
    _couponList = couponList;
    
    __block CGFloat x = SCREEN_FIX(20);
    
    [self.couponLabelList enumerateObjectsUsingBlock:^(UILabel * _Nonnull label, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx >= couponList.count) {
            label.hidden = YES;
            
        }else {
            label.hidden = NO;
            NSString *str = couponList[idx];
            
            CGFloat width = [str calculateWidthWithFont:label.font height:label.height] + SCREEN_FIX(6);
            
            label.left  = x;
            label.width = MAX(width, SCREEN_FIX(62.5));
            label.text  = str;
            
            x = label.right + SCREEN_FIX(9.5);
        }
    }];
    
    
    
    self.couponTipLabel.hidden = couponList.count > 0;
}


#pragma mark -ui
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_FIX(19.5), SCREEN_FIX(18), 0, SCREEN_FIX(16))];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = SCFONT_SIZED(17);
        [self addSubview:_titleLabel];
        
    }
    return _titleLabel;
}

- (UIButton *)styleIcon
{
    if (!_styleIcon) {
        _styleIcon = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_FIX(18), SCREEN_FIX(29), SCREEN_FIX(14.5))];
        [_styleIcon setBackgroundImage:SCIMAGE(@"sc_home_store_type") forState:UIControlStateNormal];
        [_styleIcon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _styleIcon.titleLabel.font = SCFONT_SIZED(11);
        _styleIcon.userInteractionEnabled = NO;
        [self addSubview:_styleIcon];
    }
    return _styleIcon;
}

- (UIButton *)enterButton
{
    if (!_enterButton) {
        CGFloat w = SCREEN_FIX(49.5);
        _enterButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width - SCREEN_FIX(15.5) - w, SCREEN_FIX(16), w, SCREEN_FIX(20.5))];
        _enterButton.adjustsImageWhenHighlighted = NO;
        [_enterButton setImage:SCIMAGE(@"home_witApollo_enterShop") forState:UIControlStateNormal];
        [self addSubview:_enterButton];
        
        _enterButton.userInteractionEnabled = NO;
//        @weakify(self)
//        [_enterButton sc_addEventTouchUpInsideHandle:^(UIButton * _Nonnull sender) {
//            @strongify(self)
//            if (self.enterShopBlock && VALID_STRING(self.shopInfoModel.link)  ) {
//                self.enterShopBlock(self.shopInfoModel);
//            }
//        }];
    }
    return _enterButton;
}

- (UILabel *)couponTipLabel
{
    if (!_couponTipLabel) {
        _couponTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_FIX(20), SCREEN_FIX(45), SCREEN_FIX(200), SCREEN_FIX(19.5))];
        _couponTipLabel.textColor = [UIColor grayColor];
        _couponTipLabel.font = SCFONT_SIZED(12);
        _couponTipLabel.numberOfLines = 2;
        [self addSubview:_couponTipLabel];
    }
    return _couponTipLabel;
}

- (NSArray<UILabel *> *)couponLabelList
{
    if (!_couponLabelList) {
        NSMutableArray *mulArr = [NSMutableArray arrayWithCapacity:2];
        
        for (int i=0; i<2; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_FIX(45), 0, SCREEN_FIX(19.5))];
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


@end
