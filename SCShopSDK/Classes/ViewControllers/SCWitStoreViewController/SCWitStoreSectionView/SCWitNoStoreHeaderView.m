//
//  SCWitNoStoreHeaderView.m
//  shopping
//
//  Created by gejunyu on 2020/9/3.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCWitNoStoreHeaderView.h"
#import "SCWitStoreHeader.h"

@interface SCWitNoStoreHeaderView ()

@property (nonatomic, strong) UIView *whiteBG;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation SCWitNoStoreHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = ({
        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor clearColor];
        view;
        });

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.tipLabel.hidden = !self.showTip;

}

- (UIView *)whiteBG
{
    if (!_whiteBG) {
        CGFloat x = kWitStoreHorMargin;
        _whiteBG = [[UIView alloc] initWithFrame:CGRectMake(x, 0, self.width-x*2, self.height)];
        _whiteBG.backgroundColor = [UIColor whiteColor];
        _whiteBG.layer.cornerRadius = kWitStoreCorner;
        _whiteBG.layer.masksToBounds = YES;
        [self.contentView addSubview:_whiteBG];
        
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_whiteBG.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(kWitStoreCorner, kWitStoreCorner)];
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//        maskLayer.frame = _whiteBG.bounds;
//        maskLayer.path = maskPath.CGPath;
//        _whiteBG.layer.mask = maskLayer;
    }
    return _whiteBG;
}

- (UIImageView *)icon //489 402
{
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithImage:SCIMAGE(@"sc_wit_no_data")];
        _icon.centerX = self.whiteBG.width/2;
        _icon.top = SCREEN_FIX(20);
        [self.whiteBG addSubview:_icon];
    }
    return _icon;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _tipLabel.font = SCFONT_SIZED(15);
        _tipLabel.textColor = [UIColor grayColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.text = @"没有符合条件的门店";
        [_tipLabel sizeToFit];
        _tipLabel.top = self.icon.bottom + SCREEN_FIX(15);
        _tipLabel.centerX = self.whiteBG.width/2;
        [self.whiteBG addSubview:_tipLabel];
    }
    return _tipLabel;
}

@end
