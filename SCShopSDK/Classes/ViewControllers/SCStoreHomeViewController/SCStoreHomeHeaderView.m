//
//  SCStoreHomeHeaderView.m
//  shopping
//
//  Created by gejunyu on 2020/7/23.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCStoreHomeHeaderView.h"


@interface SCStoreHomeHeaderView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *tagView;
@property (nonatomic, strong) UIButton *bannerView;  //IOS_T_NZDSCSDDP_A01

@end

@implementation SCStoreHomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setTenantInfo:(SCTenantInfoModel *)tenantInfo
{
    _tenantInfo = tenantInfo;
    
    self.titleLabel.text = tenantInfo.shopName;
    [self.titleLabel sizeToFit];
    
    self.tagView.hidden = ![tenantInfo.tenantType isEqualToString:@"1"];
    self.tagView.left = self.titleLabel.right + SCREEN_FIX(4);
    
    [self.bannerView sd_setBackgroundImageWithURL:[NSURL URLWithString:tenantInfo.tenantIcon] forState:UIControlStateNormal placeholderImage:IMG_PLACE_HOLDER];
    
}

#pragma mark -ui
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_FIX(19.5), SCREEN_FIX(14.5), 0, SCREEN_FIX(16))];
        _titleLabel.font = SCFONT_SIZED(16);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIImageView *)tagView
{
    if (!_tagView) {
        _tagView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_FIX(30), SCREEN_FIX(15.5))];
        _tagView.image = SCIMAGE(@"qijian");
        _tagView.centerY = self.titleLabel.centerY;
        [self addSubview:_tagView];
    }
    return _tagView;
}

- (UIButton *)bannerView
{
    if (!_bannerView) {
        CGFloat y = SCREEN_FIX(45);
        _bannerView = [[UIButton alloc] initWithFrame:CGRectMake(0, y, self.width, self.height - y)];
        _bannerView.adjustsImageWhenHighlighted = NO;
        [self addSubview:_bannerView];
        
        @weakify(self)
        [_bannerView sc_addEventTouchUpInsideHandle:^(id  _Nonnull sender) {
           @strongify(self)
            if (self.bannerBlock) {
                self.bannerBlock(self.tenantInfo);
            }
        }];
    }
    return _bannerView;
}

@end
