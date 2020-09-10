//
//  SCHomeEmptyView.m
//  shopping
//
//  Created by gejunyu on 2020/9/5.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCHomeEmptyView.h"

@interface SCHomeEmptyView ()
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation SCHomeEmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tipLabel.center = CGPointMake(self.width/2, self.height/2);
    }
    return self;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = SCFONT_SIZED(15);
        _tipLabel.textColor = HEX_RGB(@"#999999");
        _tipLabel.text = @"抱歉，暂无商品，看看其他商品吧~";
        [_tipLabel sizeToFit];
        [self addSubview:_tipLabel];
    }
    return _tipLabel;
}

@end




