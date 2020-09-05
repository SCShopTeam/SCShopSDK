//
//  SCMyOrderTopItemView.m
//  shopping
//
//  Created by zhangtao on 2020/7/7.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCMyOrderTopItemView.h"

@implementation SCMyOrderTopItemView

{
    UIButton *orderTypeBtn;
    UIButton *payStateSpaceBtn;
    UIView *orderTypeMark;
    UIImageView *indexMarkImg;
    BOOL isMDType;  //是否是门店类型订单
}

-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imgv = [[UIImageView alloc]init];
        [self addSubview:imgv];
        imgv.image = [UIImage bundleImageNamed:@"order_personHeaderBG"];
        [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.mas_equalTo(360*m6Scale);
        }];
        
        
        _headImgV = [[UIImageView alloc]init];
        _headImgV.image = [UIImage bundleImageNamed:@"sc_header_icon"];
        [self addSubview:_headImgV];
        _headImgV.layer.cornerRadius = SCREEN_FIX(60)/2;
        _headImgV.layer.masksToBounds = YES;
        [_headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.top.mas_equalTo(STATUS_BAR_HEIGHT+25*m6Scale);
            make.height.width.mas_equalTo(SCREEN_FIX(60));
        }];
        
        _phoneLab = [[UILabel alloc]init];
         NSString *userPhone = [SCUserInfo currentUser].phoneNumber;
        if ([SCUtilities isValidString:userPhone] && userPhone.length == 11) {
            NSString *phone = [userPhone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            _phoneLab.text = phone;
        }else{
            _phoneLab.text = @"";
        }
        [self addSubview:_phoneLab];
        _phoneLab.textColor = HEX_RGB(@"#FFFFFF");
        _phoneLab.font = [UIFont systemFontOfSize:18];
        [_phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImgV.mas_right).mas_offset(15);
            make.centerY.equalTo(_headImgV.mas_centerY);
        }];
        
        NSArray *fImages = @[@"order_collection_icon",@"order_coupon_icon",@"order_address_icon",@"order_kefu_icon"];
        NSArray *fNames = @[@"商品收藏",@"优惠券",@"地址管理"/*,@"客服"*/];
        for (NSUInteger i = 0; i<3; i++) {
            UIButton *btn = [[UIButton alloc]init];
            [self addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_headImgV.mas_bottom).mas_offset(20*m6Scale);
                make.width.mas_equalTo(SCREEN_WIDTH/3);
                make.height.mas_equalTo(SCREEN_FIX(44));
                make.left.mas_equalTo(SCREEN_WIDTH/3 * i);
            }];
            [btn setTitleColor:HEX_RGB(@"#FFFFFF") forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn setTag:i];
            [btn setImage:[UIImage bundleImageNamed:fImages[i]] forState:UIControlStateNormal];
            [btn setTitle:fNames[i] forState:UIControlStateNormal];
            [btn layoutButtonWithEdgeInsetsStyle:XGButtonEdgeInsetsStyleTop imageTitleSpace:8];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        UIButton *SCBtn = [[UIButton alloc]init];
        [self addSubview:SCBtn];
        [SCBtn setTitle:@"商城订单" forState:UIControlStateNormal];
        SCBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [SCBtn setTitleColor:HEX_RGB(@"#999999") forState:UIControlStateNormal];
        [SCBtn setTitleColor:HEX_RGB(@"#333333") forState:UIControlStateSelected];
        SCBtn.selected = YES;
        orderTypeBtn = SCBtn;
        [SCBtn setTag:2008121653];
        [SCBtn addTarget:self action:@selector(orderTypeClick:) forControlEvents:UIControlEventTouchUpInside];
        [SCBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SCREEN_FIX(65));
            make.bottom.equalTo(self).mas_offset(SCREEN_FIX(-86));
        }];
        
        UIButton *MDBtn = [[UIButton alloc]init];
        [self addSubview:MDBtn];
        [MDBtn setTitle:@"门店订单" forState:UIControlStateNormal];
        MDBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [MDBtn setTitleColor:HEX_RGB(@"#999999") forState:UIControlStateNormal];
        [MDBtn setTitleColor:HEX_RGB(@"#333333") forState:UIControlStateSelected];
        [MDBtn setTag:2008121654];
        [MDBtn addTarget:self action:@selector(orderTypeClick:) forControlEvents:UIControlEventTouchUpInside];
        [MDBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(SCREEN_FIX(-65));
            //            make.top.equalTo(_phoneLab.mas_bottom).mas_offset(SCREEN_WIDTH/4+20);
            make.bottom.equalTo(self).mas_offset(SCREEN_FIX(-86));
        }];
        
        UILabel *typeMiddleLine = [[UILabel alloc]init];
        typeMiddleLine.backgroundColor = HEX_RGB(@"#DBDBDB");
        [self addSubview:typeMiddleLine];
        [typeMiddleLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.width.mas_equalTo(.5);
            make.height.mas_equalTo(13);
            make.centerY.equalTo(SCBtn.mas_centerY);
        }];
        
        orderTypeMark = [[UIView alloc]init];
        orderTypeMark.layer.cornerRadius = 1.5;
        [self addSubview:orderTypeMark];
        orderTypeMark.backgroundColor = HEX_RGB(@"#FB4E37");
        [orderTypeMark mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(SCBtn.mas_centerX);
            make.top.equalTo(SCBtn.mas_bottom).mas_offset(5);
            make.width.mas_equalTo(SCREEN_FIX(41));
            make.height.mas_equalTo(3);
        }];
        
        NSArray *snormalImages = @[@"sc_waitPay_normal",@"sc_waitAccept_normal",@"sc_completed_normal",@"sc_allOrder_normal"];
        NSArray *sselectedImages = @[@"sc_waitPay_selected",@"sc_waitAccept_selected",@"sc_completed_selected",@"sc_allOrder_selected"];
        NSArray *sNames = @[@"待付款",@"待收货",@"已收货",@"全部订单"];
        for (NSUInteger i = 4; i<8; i++) {
            UIButton *btn = [[UIButton alloc]init];
            [self addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(markLab.mas_bottom).mas_offset(15);
                make.bottom.equalTo(self).mas_offset(SCREEN_FIX(-18));
                make.width.mas_equalTo(SCREEN_WIDTH/4);
                make.height.mas_equalTo(SCREEN_FIX(46));
                make.left.mas_equalTo(SCREEN_WIDTH/4 * (i-4));
            }];
            [btn setTag:i];
            [btn setTitleColor:HEX_RGB(@"#444242") forState:UIControlStateNormal];
            [btn setTitleColor:HEX_RGB(@"#FA353D") forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn setImage:[UIImage bundleImageNamed:snormalImages[i-4]] forState:UIControlStateNormal];
            [btn setImage:[UIImage bundleImageNamed:sselectedImages[i-4]] forState:UIControlStateSelected];

            [btn setTitle:sNames[i-4] forState:UIControlStateNormal];
            [btn layoutButtonWithEdgeInsetsStyle:XGButtonEdgeInsetsStyleTop imageTitleSpace:12];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            
            if (i == 4) {
                 btn.selected = YES;
                payStateSpaceBtn = btn;
                indexMarkImg = [[UIImageView alloc]init];
                [self addSubview:indexMarkImg];
                
                indexMarkImg.image = [UIImage bundleImageNamed:@"order_flagSanjiao"];
                [indexMarkImg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(15*m6Scale);
                    make.width.mas_equalTo(29*m6Scale);
                    make.centerX.mas_equalTo(btn.mas_centerX);
                    make.bottom.equalTo(self);
                }];
            }
            
        }
    }
    
    return self;
}

//商城订单、 门店订单
-(void)orderTypeClick:(UIButton *)sender{
    //2008121653
    NSInteger tag = sender.tag;
    
    orderTypeBtn.selected = NO;
    orderTypeBtn = nil;
    orderTypeBtn = sender;
    orderTypeBtn.selected = YES;
    
    [orderTypeMark mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(sender.mas_centerX);
        make.top.equalTo(sender.mas_bottom).mas_offset(5);
        make.width.mas_equalTo(SCREEN_FIX(41));
        make.height.mas_equalTo(3);
    }];
    
    if (tag == 2008121653) {  //商城订单
        isMDType = NO;
    }else if (tag == 2008121654){  //门店订单
        isMDType = YES;
    }
     UIButton *btn = [self viewWithTag:4];
    [self btnClick:btn];
}

//代付款、待收货、。。。全部订单
-(void)btnClick:(UIButton *)sender{
    NSUInteger tag = sender.tag;
    if (tag == itemWaitPayType_SC ||
        tag == itemWaitAcceptType_SC ||
        tag == itemFinishedType_SC ||
        tag == itemAllOrderType_SC) {
        [indexMarkImg mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(sender.mas_centerX);
            make.bottom.equalTo(self);

        }];
        payStateSpaceBtn.selected = NO;
        payStateSpaceBtn = nil;
        sender.selected = YES;
        payStateSpaceBtn = sender;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(itemClick:)]) {
            NSInteger num = tag;
            if (isMDType) {
               num = tag + 4;
            }else{
                num = tag;
            }
            [self.delegate itemClick:num];
           }
        
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(itemClick:)]) {
               [self.delegate itemClick:tag];
           }
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
