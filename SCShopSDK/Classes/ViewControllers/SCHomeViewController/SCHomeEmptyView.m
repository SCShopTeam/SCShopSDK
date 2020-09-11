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

- (void)setStatus:(SCHomeEmptyStatus)status
{
    _status = status;
    
    switch (status) {
        case SCHomeEmptyStatusLoading:
            self.tipLabel.text = @"加载中...";
            break;
            
        case SCHomeEmptyStatusNull:
            self.tipLabel.text = @"抱歉，暂无商品，看看其他商品吧~";
            break;
            
        default:
            break;
    }
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.width, SCREEN_FIX(20))];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = SCFONT_SIZED(15);
        _tipLabel.textColor = HEX_RGB(@"#999999");
        [self addSubview:_tipLabel];
    }
    return _tipLabel;
}

@end




