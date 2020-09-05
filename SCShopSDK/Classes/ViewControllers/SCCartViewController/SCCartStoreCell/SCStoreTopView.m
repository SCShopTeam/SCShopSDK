//
//  SCStoreTopView.m
//  shopping
//
//  Created by gejunyu on 2020/7/9.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCStoreTopView.h"

@interface SCStoreTopView ()
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *line;

@end

@implementation SCStoreTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self line];
    }
    return self;
}

- (void)selectClicked
{
    if (_selectActionBlock) {
        _selectActionBlock();
    }
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    
    [self.selectButton setImage:(selected ? SCIMAGE(@"Circle_selected") : SCIMAGE(@"Circle_normal")) forState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

#pragma mark -ui
- (UIButton *)selectButton
{
    if (!_selectButton) {
        CGFloat h = self.height;
        //设置实际大小比图片大小大，方便用户点击
        CGFloat w = SCREEN_FIX((11.5 + 15.5 + 8));
        _selectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        [_selectButton addTarget:self action:@selector(selectClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_selectButton];
    }
    return _selectButton;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        CGFloat h = 20;
        CGFloat x = self.selectButton.right;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, (self.height-h)/2, self.width-x*2, h)];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = SCFONT_NAME_SIZED(@"HiraginoSansGB-W3", 15);
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-0.5, self.width, 0.5)];
        _line.backgroundColor = HEX_RGB(@"#E1E1E1");
        [self addSubview:_line];
    }
    return _line;
}

@end
