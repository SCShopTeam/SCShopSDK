//
//  SCStoreBottomView.m
//  shopping
//
//  Created by gejunyu on 2020/7/9.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCStoreBottomView.h"


@interface SCStoreBottomView ()
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *sumLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *balanceButton;


@end

@implementation SCStoreBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    [self priceLabel];
    [self balanceButton];
}

#pragma mark -public
- (void)setPrice:(CGFloat)price
{
    _price = price;
    self.priceLabel.attributedText = [SCUtilities priceAttributedString:price font:SCFONT_BOLD_SIZED(14) color:HEX_RGB(@"#F2270C")];
}

- (void)setBalanceNum:(NSInteger)balanceNum
{
    _balanceNum = balanceNum;
    
    if (balanceNum) {
        self.balanceButton.backgroundColor = HEX_RGB(@"#EF3E20");
        self.balanceButton.enabled = YES;
        [self.balanceButton setTitle:[NSString stringWithFormat:@"结算(%li)",balanceNum] forState:UIControlStateNormal];
        
    }else {
        self.balanceButton.backgroundColor = HEX_RGB(@"#CBCBCB");
        self.balanceButton.enabled = NO;
        [self.balanceButton setTitle:@"结算" forState:UIControlStateNormal];
    }
}

- (void)balanceClicked
{
    if (_balanceBlock) {
        _balanceBlock();
    }
}

#pragma mark -ui

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.font = SCFONT_SIZED(9);
        _tipLabel.textColor = HEX_RGB(@"#888888");
        _tipLabel.text = @"不含运费";
        [_tipLabel sizeToFit];
        _tipLabel.origin = CGPointMake(SCREEN_FIX(9.5), (self.height-_tipLabel.height)/2);
        [self addSubview:_tipLabel];
    }
    return _tipLabel;
}

- (UILabel *)sumLabel
{
    if (!_sumLabel) {
        _sumLabel = [UILabel new];
        _sumLabel.font = SCFONT_SIZED(11.5);
        _sumLabel.textColor = HEX_RGB(@"#666666");
        _sumLabel.text = @"合计:";
        [_sumLabel sizeToFit];
        _sumLabel.origin = CGPointMake(self.tipLabel.right + SCREEN_FIX(11.5), (self.height-_sumLabel.height)/2);
        [self addSubview:_sumLabel];
    }
    return _sumLabel;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        CGFloat h = 14;
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.sumLabel.right + SCREEN_FIX(10.5), (self.height-h)/2 - 2, 100, h)];
        [self addSubview:_priceLabel];
    }
    return _priceLabel;
}

- (UIButton *)balanceButton
{
    if (!_balanceButton) {
        //85 * 27
        CGFloat w = SCREEN_FIX(85);
        CGFloat h = SCREEN_FIX(27);
        _balanceButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width-SCREEN_FIX(15)-w, (self.height-h)/2, w, h)];
        [_balanceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _balanceButton.titleLabel.font = SCFONT_SIZED(13);
        _balanceButton.layer.cornerRadius = h/2;
        _balanceButton.layer.masksToBounds = YES;
        [_balanceButton addTarget:self action:@selector(balanceClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_balanceButton];
    }
    return _balanceButton;
}

@end
