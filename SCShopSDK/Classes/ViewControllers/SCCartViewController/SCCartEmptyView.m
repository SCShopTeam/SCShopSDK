//
//  SCCartEmptyView.m
//  shopping
//
//  Created by gejunyu on 2020/9/4.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCCartEmptyView.h"

@interface SCCartEmptyView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIButton *shopButton;

@end

@implementation SCCartEmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self shopButton];
        [self titleLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

#pragma mark -ui
- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.font = SCFONT_SIZED_FIX(15);
        _detailLabel.textColor = [UIColor grayColor];
        _detailLabel.text = @"再忙，也要记得买点什么犒赏自己~";
        [_detailLabel sizeToFit];
        _detailLabel.center = CGPointMake(self.width/2, self.height/2 + SCREEN_FIX(10));
        [self addSubview:_detailLabel];
    }
    return _detailLabel;
}

- (UIButton *)shopButton
{
    if (!_shopButton) {
        CGFloat w = SCREEN_FIX(100);
        _shopButton = [[UIButton alloc] initWithFrame:CGRectMake((self.width-w)/2, self.detailLabel.bottom+SCREEN_FIX(25), w, SCREEN_FIX(45))];
        _shopButton.titleLabel.font = SCFONT_SIZED_FIX(16);
        [_shopButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_shopButton setTitle:@"去逛逛" forState:UIControlStateNormal];
        _shopButton.layer.borderWidth = 1;
        _shopButton.layer.borderColor = HEX_RGB(@"#E2E2E2").CGColor;
        [self addSubview:_shopButton];
        
        @weakify(self)
        [_shopButton sc_addEventTouchUpInsideHandle:^(id  _Nonnull sender) {
            @strongify(self)
            if (self.pushBlock) {
                self.pushBlock();
            }
        }];
    }
    return _shopButton;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, SCREEN_FIX(20))];
        _titleLabel.bottom = self.detailLabel.top - SCREEN_FIX(20);
        _titleLabel.font = SCFONT_SIZED(_titleLabel.height);
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"购物车竟然是空的";
        [self addSubview:_titleLabel];
        
    }
    return _titleLabel;
}

@end
