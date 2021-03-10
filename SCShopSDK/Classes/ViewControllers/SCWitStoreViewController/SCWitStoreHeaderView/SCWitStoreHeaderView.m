//
//  SCWitStoreHeaderView.m
//  shopping
//
//  Created by gejunyu on 2020/8/28.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCWitStoreHeaderView.h"
#import "SCWSHeaderButton.h"
#import "SCWitStoreGoodModel.h"
#import "SCWitStoreHeader.h"
#import "SCLocationService.h"

@interface SCWitStoreHeaderView ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *styleIcon;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *peopleNumLabel;
@property (nonatomic, strong) UIButton *phoneBtn;
@property (nonatomic, strong) UILabel *couponTipLabel;
@property (nonatomic, strong) UIButton *orderBtn; //立即取号
@property (nonatomic, strong) UIButton *enterBtn;    //进店逛逛
@property (nonatomic, strong) NSArray <UILabel *> *couponLabelList;
@property (nonatomic, strong) NSArray <SCWSHeaderButton *> *btnList;

//@property (nonatomic, strong) UILabel *emptyTipLabel;

@end

@implementation SCWitStoreHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self btnList];
    }
    return self;
}

- (void)setModel:(SCWitStoreModel *)model
{
    if (_model) {
        _model.headerView = nil;
    }
    
    _model = model;
    model.headerView = self;
    
    CGFloat maxW = self.phoneBtn.left - SCREEN_FIX(1) - self.styleIcon.width - SCREEN_FIX(3) - self.titleLabel.left;
    //标题
    self.titleLabel.text = model.storeName;
    [self.titleLabel sizeToFit];
    if (self.titleLabel.width > maxW) {
        self.titleLabel.width = maxW;
    }
    //style
    self.styleIcon.hidden = !model.professional;
    self.styleIcon.left = self.titleLabel.right + SCREEN_FIX(3);
    //地址
    if ([SCLocationService sharedInstance].longitude && [SCLocationService sharedInstance].latitude && model.geoDistance && ![model.geoDistance isEqualToString:@"0m"]) {
        NSString *length = model.geoDistance;
        NSString *address = model.storeAddress ?: @"";
        NSString *text = NSStringFormat(@"距离您%@|%@",length,address);
        NSMutableAttributedString *mulAtt = [[NSMutableAttributedString alloc] initWithString:text];
        [mulAtt addAttributes:@{NSForegroundColorAttributeName:HEX_RGB(@"#FF3C34")} range:[text rangeOfString:length]];
        self.addressLabel.attributedText = mulAtt;
        
    }else {
        NSString *text = model.storeAddress ?: @"";
        self.addressLabel.text = text;
    }
    

    
    //取号信息
    //排队人数
    //排队人数
    self.peopleNumLabel.hidden = YES;
    if (model.line && model.queueInfoModel) {
        self.peopleNumLabel.hidden = NO;
        NSString *num = model.queueInfoModel.queue_NUMBER;
        if ([num isEqualToString:@"0"] || !VALID_STRING(num)) {
            self.peopleNumLabel.text = @"当前无需排队";
            
        }else {
            NSString *numStr = NSStringFormat(@"当前排队人数%@人",num);
            NSMutableAttributedString *mulas = [[NSMutableAttributedString alloc] initWithString:numStr];
            [mulas addAttributes:@{NSForegroundColorAttributeName:HEX_RGB(@"#FC3E3C")} range:[numStr rangeOfString:num]];
            self.peopleNumLabel.attributedText = mulas;
        }
    }
    

    //进店逛逛
    if (!model.line) {
        self.enterBtn.centerX = self.width/2;
    }else {
        self.enterBtn.left = self.width/2 + SCREEN_FIX(3);
    }
    //取号按钮
    self.orderBtn.hidden = !model.line;


    
    //优惠券
    __block CGFloat x = self.couponTipLabel.left;
    [self.couponLabelList enumerateObjectsUsingBlock:^(UILabel * _Nonnull label, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx >= model.couponList.count) {
            label.hidden = YES;

        }else {
            label.hidden = NO;

            SCWitCouponModel *couponModel = model.couponList[idx];
            
            CGFloat width = [couponModel.couName calculateWidthWithFont:label.font height:label.height] + SCREEN_FIX(8);
            
            label.left  = x;
            label.width = width;
            label.text  = couponModel.couName;
            
            x = label.right + SCREEN_FIX(5);
        }
    }];
    
    self.couponTipLabel.hidden = model.couponList.count;
    

}

- (void)setGoodsList:(NSArray<SCWitStoreGoodModel *> *)goodsList
{
    [self.btnList enumerateObjectsUsingBlock:^(SCWSHeaderButton * _Nonnull btn, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx >= goodsList.count) {
            btn.hidden = YES;
            
        }else {
            btn.hidden = NO;
            
            SCWitStoreGoodModel *model = goodsList[idx];
            btn.model = model;
        }
    }];
    
//    self.emptyTipLabel.hidden = goodsList.count > 0;
}


#pragma mark - btnAction

- (void)goodSelected:(SCWSHeaderButton *)sender
{
    if (_goodSelectBlock && VALID_STRING(sender.model.goodsH5Link)) {
        _goodSelectBlock(sender.model);
    }
}


#pragma mark -ui
- (UIView *)contentView
{
    if (!_contentView) {
        CGFloat x = kWitStoreHorMargin;
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(x, 0, self.width-x*2, SCREEN_FIX(334))];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = kWitStoreCorner;
        _contentView.layer.masksToBounds = YES;
        [self addSubview:_contentView];
        
        /****店铺信息***/
        //距离最近
        UIButton *nearIcon = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_FIX(12.5), SCREEN_FIX(56), SCREEN_FIX(21))];
        [nearIcon setBackgroundImage:SCIMAGE(@"sc_near_icon") forState:UIControlStateNormal];
        nearIcon.titleLabel.font = SCFONT_SIZED(10);
        [nearIcon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [nearIcon setTitle:@"距离最近" forState:UIControlStateNormal];
        nearIcon.titleEdgeInsets = UIEdgeInsetsMake(SCREEN_FIX(4), SCREEN_FIX(2), SCREEN_FIX(7), SCREEN_FIX(6));
        nearIcon.userInteractionEnabled = NO;
        [_contentView addSubview:nearIcon];
        
        //我的排队记录
//        CGFloat w = SCREEN_FIX(80);
//        UIButton *recordBtn = [[UIButton alloc] initWithFrame:CGRectMake(_contentView.width - SCREEN_FIX(15) - w, SCREEN_FIX(15), w, SCREEN_FIX(14))];
//        [recordBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        recordBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//        recordBtn.titleLabel.font = SCFONT_SIZED(10);
//        [recordBtn setTitle:@"我的排队记录  >" forState:UIControlStateNormal];
//        [_contentView addSubview:recordBtn];
//        @weakify(self)
//        [recordBtn sc_addEventTouchUpInsideHandle:^(id  _Nonnull sender) {
//            @strongify(self)
//            if (self.orderHistoryBlock) {
//                self.orderHistoryBlock();
//            }
//        }];
        
        //电话
        CGFloat wh = SCREEN_FIX(36.5);
        _phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(_contentView.width-SCREEN_FIX(5)-wh, SCREEN_FIX(40), wh, wh)];
        [_phoneBtn setImage:SCIMAGE(@"sc_wit_tel") forState:UIControlStateNormal];
        @weakify(self)
        [_phoneBtn sc_addEventTouchUpInsideHandle:^(id  _Nonnull sender) {
            @strongify(self)
            if (self.phoneBlock && VALID_STRING(self.model.contactPhone)) {
                self.phoneBlock(self.model.contactPhone);
            }
        }];
        
        [_contentView addSubview:_phoneBtn];
        
        //取号背景
        UIImageView *orderBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_FIX(97.5), _contentView.width, SCREEN_FIX(69))];
        orderBg.image = SCIMAGE(@"sc_wit_order_bg");
        [_contentView addSubview:orderBg];
        
        
        //本店优惠
        UIImageView *couponIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, orderBg.bottom + SCREEN_FIX(5.5), SCREEN_FIX(79.5), SCREEN_FIX(23.5))];
        couponIcon.image = SCIMAGE(@"sc_wit_coupon");
        [_contentView addSubview:couponIcon];
        
        _couponTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(couponIcon.right + SCREEN_FIX(7.5), orderBg.bottom+SCREEN_FIX(10.5), SCREEN_FIX(121.5), SCREEN_FIX(17))];
        _couponTipLabel.backgroundColor = HEX_RGB(@"#FFF9E8");
        _couponTipLabel.textAlignment = NSTextAlignmentCenter;
        _couponTipLabel.font = SCFONT_SIZED(9.5);
        _couponTipLabel.textColor = HEX_RGB(@"#FFAB02");
        _couponTipLabel.text = @"逛智慧门店，立享会员服务";
        _couponTipLabel.layer.cornerRadius = 4;
        _couponTipLabel.layer.masksToBounds = YES;
        [_contentView addSubview:_couponTipLabel];
        
//        CGFloat emptyY = couponIcon.bottom;
//        _emptyTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, emptyY, _contentView.width, _contentView.height-emptyY)];
//
//        _emptyTipLabel.textAlignment = NSTextAlignmentCenter;
//        _emptyTipLabel.font = SCFONT_SIZED(15);
//        _emptyTipLabel.textColor = HEX_RGB(@"#999999");
//        _emptyTipLabel.text = @"抱歉，商品不存在~";
//        CGPoint center = _emptyTipLabel.center;
//        [_emptyTipLabel sizeToFit];
//        _emptyTipLabel.center = center;
//        _emptyTipLabel.hidden = YES;
//        [_contentView addSubview:_emptyTipLabel];
        
        UIButton *enterButton = [[UIButton alloc] initWithFrame:CGRectMake(0, nearIcon.bottom, _phoneBtn.left, self.addressLabel.bottom-nearIcon.bottom)];
        [enterButton sc_addEventTouchUpInsideHandle:^(id  _Nonnull sender) {
            @strongify(self)
            if (self.enterBlock && VALID_STRING(self.model.storeLink)) {
                self.enterBlock(self.model);
            }
        }];
        [_contentView addSubview:enterButton];
        [_contentView bringSubviewToFront:enterButton];
        
    }
    return _contentView;
}


- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_FIX(11), SCREEN_FIX(42.5), 0, SCREEN_FIX(16))];
        _titleLabel.font          = SCFONT_SIZED(16);
        _titleLabel.textColor     = HEX_RGB(@"#333333");
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIButton *)styleIcon
{
    if (!_styleIcon) {
        _styleIcon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_FIX(29), SCREEN_FIX(14.5))];
        _styleIcon.centerY = self.titleLabel.centerY;
        [_styleIcon setBackgroundImage:SCIMAGE(@"sc_home_store_type") forState:UIControlStateNormal];
        [_styleIcon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _styleIcon.titleLabel.font = SCFONT_SIZED(11);
        _styleIcon.userInteractionEnabled = NO;
        [_styleIcon setTitle:@"旗舰" forState:UIControlStateNormal];
        [self.contentView addSubview:_styleIcon];
        [self.contentView sendSubviewToBack:_styleIcon];
    }
    return _styleIcon;
}

- (UILabel *)addressLabel
{
    if (!_addressLabel) { //68
        CGFloat x = self.titleLabel.left;
        CGFloat w = self.phoneBtn.left - SCREEN_FIX(5) - x;
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, SCREEN_FIX(68), w, SCREEN_FIX(11.5))];
        _addressLabel.font = SCFONT_SIZED(11.5);
        _addressLabel.textColor = HEX_RGB(@"#666666");
        [self.contentView addSubview:_addressLabel];
    }
    return _addressLabel;
}

- (UILabel *)peopleNumLabel
{
    if (!_peopleNumLabel) {
        CGFloat w = 300;
        _peopleNumLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.contentView.width-w)/2, SCREEN_FIX(91.5), w, SCREEN_FIX(22.5))];
        _peopleNumLabel.font = SCFONT_SIZED(14);
        _peopleNumLabel.textAlignment = NSTextAlignmentCenter;
        _peopleNumLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_peopleNumLabel];
    }
    return _peopleNumLabel;
}

- (UIButton *)enterBtn
{
    if (!_enterBtn) {
        CGFloat bgW = SCREEN_FIX(126);
        CGFloat bgH = SCREEN_FIX(33);
        _enterBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.contentView.width/2+SCREEN_FIX(3), SCREEN_FIX(127), bgW, bgH)];
        _enterBtn.left = self.contentView.width/2 + SCREEN_FIX(3);
        [_enterBtn setBackgroundImage:SCIMAGE(@"sc_orangeBG") forState:UIControlStateNormal];
        _enterBtn.titleLabel.font = SCFONT_SIZED(SCREEN_FIX(14));
        [_enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_enterBtn setTitle:@"进店逛逛" forState:UIControlStateNormal];
        _enterBtn.titleEdgeInsets = UIEdgeInsetsMake(SCREEN_FIX(8.5), 0, SCREEN_FIX(10.5), 0);
        [self.contentView addSubview:_enterBtn];
        
        @weakify(self)
        [_enterBtn sc_addEventTouchUpInsideHandle:^(id  _Nonnull sender) {
           @strongify(self)
            if (self.enterBlock && VALID_STRING(self.model.storeLink)) {
                self.enterBlock(self.model);
            }
        }];
    }
    return _enterBtn;
}


- (UIButton *)orderBtn
{
    if (!_orderBtn) {

        _orderBtn = [[UIButton alloc] initWithFrame:self.enterBtn.frame];
        _orderBtn.left = self.contentView.width/2 - SCREEN_FIX(3) - _orderBtn.width;
        [_orderBtn setBackgroundImage:SCIMAGE(@"sc_blueBG") forState:UIControlStateNormal];
        _orderBtn.titleLabel.font = SCFONT_SIZED(SCREEN_FIX(14));
        [_orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_orderBtn setTitle:@"立即取号" forState:UIControlStateNormal];
        _orderBtn.titleEdgeInsets = UIEdgeInsetsMake(SCREEN_FIX(8.5), 0, SCREEN_FIX(10.5), 0);
        _orderBtn.hidden = YES;
        [self.contentView addSubview:_orderBtn];
        
        @weakify(self)
        [_orderBtn sc_addEventTouchUpInsideHandle:^(id  _Nonnull sender) {
           @strongify(self)
            if (self.orderBlock && self.model) {
                self.orderBlock(self.model);
            }
        }];
    }
    return _orderBtn;
}




- (NSArray<UILabel *> *)couponLabelList
{
    if (!_couponLabelList) {
        NSMutableArray *mulArr = [NSMutableArray arrayWithCapacity:3];
        
        for (int i=0; i<3; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(_couponTipLabel.left, 0, 0, SCREEN_FIX(17))];
            label.centerY = _couponTipLabel.centerY;
            label.layer.cornerRadius  = 2;
            label.layer.borderWidth   = 1;
            label.layer.borderColor   = HEX_RGB(@"#FFE2E2").CGColor;
            label.layer.masksToBounds = YES;
            label.textAlignment       = NSTextAlignmentCenter;
            label.textColor           = HEX_RGB(@"#FF635D");
            label.font                = SCFONT_SIZED(SCREEN_FIX(10));
            [self.contentView addSubview:label];
            [mulArr addObject:label];
        }
        _couponLabelList = mulArr.copy;
    }
    return _couponLabelList;
}

- (NSArray<SCWSHeaderButton *> *)btnList
{
    if (!_btnList) {
        NSMutableArray *mulArr = [NSMutableArray arrayWithCapacity:3];
        CGFloat w = self.contentView.width/3;
        CGFloat h = SCREEN_FIX(112);
        for (int i=0; i<3; i++) {
            SCWSHeaderButton *btn = [[SCWSHeaderButton alloc] initWithFrame:CGRectMake(w*i, 0, w, h)];
            btn.bottom = self.contentView.height - SCREEN_FIX(6);
            [btn addTarget:self action:@selector(goodSelected:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:btn];
            [self.contentView sendSubviewToBack:btn];
            [mulArr addObject:btn];
            
        }
        _btnList = mulArr.copy;
        
    }
    return _btnList;
}

@end
