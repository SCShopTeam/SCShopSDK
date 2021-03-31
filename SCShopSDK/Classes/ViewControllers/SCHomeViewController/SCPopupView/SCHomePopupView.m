//
//  SCHomePopupView.m
//  shopping
//
//  Created by gejunyu on 2020/10/23.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCHomePopupView.h"

@interface SCHomePopupView ()
@property (nonatomic, strong) SCHomeTouchModel *model;
@property (nonatomic, copy) SCPopupBlock clickBlock;
@property (nonatomic, strong) UIButton *imageButton;
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation SCHomePopupView
+ (void)showIn:(UIViewController *)vc model:(SCHomeTouchModel *)model clickBlock:(nonnull SCPopupBlock)clickBlock
{
    if (!vc || !model || model.popupType < 0 || model.popupType > 2) {
        return;
    }
    
    CGFloat viewW = vc.view.width;
    CGFloat viewH = vc.view.height;

    CGRect frame;
    
    if (model.popupType == SCPopupTypeSide) {
        CGFloat w = SCREEN_FIX(62.5);
        CGFloat h = SCREEN_FIX(78);
        frame = CGRectMake(viewW - w, (viewH - TAB_BAR_HEIGHT - h)/2, w, h);
        
    }else if (model.popupType == SCPopupTypeBottom) {
        CGFloat h = SCREEN_FIX(200);
        frame = CGRectMake(0, viewH - h - TAB_BAR_HEIGHT, viewW, h);
        
    }else {
        CGFloat w = SCREEN_FIX(285);
        CGFloat h = SCREEN_FIX(400);
        frame = CGRectMake((viewW - w)/2, (viewH - TAB_BAR_HEIGHT - h)/2, w, h);
    }
    
    SCHomePopupView *popupView = [[SCHomePopupView alloc] initWithFrame:frame];
    popupView.model = model;
    popupView.clickBlock = clickBlock;
    
    [vc.view addSubview:popupView];
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self closeButton];
    }
    return self;
}

- (void)setModel:(SCHomeTouchModel *)model
{
    _model = model;
    
    [self.imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:model.picUrl] forState:UIControlStateNormal placeholderImage:IMG_PLACE_HOLDER];
}

#pragma mark -action
- (void)linkClicked
{
    if (_clickBlock) {
        _clickBlock(self.model);
    }
    
    if (self.model.popupType != SCPopupTypeSide) {
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
