//
//  SCHomePopupView.m
//  shopping
//
//  Created by gejunyu on 2020/10/23.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCHomePopupView.h"

@interface SCHomePopupView ()
@property (nonatomic, strong) UIButton *imageButton;
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation SCHomePopupView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _moveAfterClicked = YES;
    }
    return self;
}

#pragma mark -data
- (void)setModel:(SCHomeTouchModel *)model
{
    _model = model;
    
    [self.imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:model.picUrl] forState:UIControlStateNormal placeholderImage:IMG_PLACE_HOLDER];
}

#pragma mark -public
- (void)setCloseFrame:(CGRect)closeFrame
{
    self.closeButton.frame = closeFrame;
}

- (void)setImageFrame:(CGRect)imageFrame
{
    self.imageFrame = imageFrame;
}

#pragma mark -action
- (void)linkClicked
{
    if (_linkBlock) {
        _linkBlock(self.model);
    }
    
    if (_moveAfterClicked) {
        [self removeFromSuperview];
    }
}

- (void)closeClicked
{
    [self removeFromSuperview];
}

#pragma mark - ui
- (UIButton *)imageButton
{
    if (!_imageButton) {
        _imageButton = [[UIButton alloc] initWithFrame:self.bounds];
        _imageButton.adjustsImageWhenHighlighted = NO;
        [_imageButton addTarget:self action:@selector(linkClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_imageButton];
        [self insertSubview:_imageButton belowSubview:self.closeButton];
    }
    return _imageButton;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        //sc_popup_close 37*37
        CGFloat wh = SCREEN_FIX(25);
        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width-wh, 0, wh, wh)];
        [_closeButton setImage:SCIMAGE(@"sc_popup_close") forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_closeButton];
    }
    return _closeButton;
}

@end
