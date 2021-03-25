//
//  SCHomeStoreActivityCell.m
//  shopping
//
//  Created by gejunyu on 2021/3/4.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import "SCHomeStoreActivityCell.h"
#import "SCHomeStoreActivitySubView.h"
#import "SCHomeStoreModel.h"

@interface SCRecommendLiveView : UIButton //直播图
@property (nonatomic, strong) UIView *textBg;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) SCHomeActivityModel *model;
@end

@interface SCHomeStoreActivityCell ()
@property (nonatomic, strong) SCRecommendLiveView *liveView; //直播图
@property (nonatomic, strong) NSArray <SCHomeStoreActivitySubView *> *subViewList;

@end

@implementation SCHomeStoreActivityCell

- (void)setModels:(NSArray<SCHomeActivityModel *> *)models
{
    _models = models;
    
    if (models.count < 2) {
        for (SCHomeStoreActivitySubView *subView in self.subViewList) {
            subView.hidden = YES;
        }
        return;
    }
    
    [self.subViewList enumerateObjectsUsingBlock:^(SCHomeStoreActivitySubView * _Nonnull subView, NSUInteger idx, BOOL * _Nonnull stop) {
        SCHomeActivityModel *model = models[idx];
        
        if (idx == 1 && model.type == SCHomeActivityTypeLive) { //右侧的直播位
            self.liveView.hidden = NO;
            subView.hidden = YES;
            self.liveView.model = model;
            
        }else {
            self.liveView.hidden = YES;
            subView.hidden = NO;
            subView.delegate = self.delegate;
            subView.model = model;
        }
            
    }];

}

#pragma mark -ui
- (NSArray<SCHomeStoreActivitySubView *> *)subViewList
{
    if (!_subViewList) {
        //两个活动位
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:2];
        for (int i=0; i<2; i++) {
            CGFloat w = self.width/2;
            SCHomeStoreActivitySubView *view = [[SCHomeStoreActivitySubView alloc] initWithFrame:CGRectMake(w*i, 0, w, self.height)];
            [self.contentView addSubview:view];
            [temp addObject:view];
        }
        _subViewList = temp.copy;
        
        //分隔线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_FIX(10.5), 1, SCREEN_FIX(133))];
        line.centerX = self.width/2;
        line.backgroundColor = HEX_RGB(@"#EEEEEE");
        [self.contentView addSubview:line];
    }
    return _subViewList;
}

- (SCRecommendLiveView *)liveView
{
    if (!_liveView) {
        CGFloat wh = SCREEN_FIX(133);
        _liveView = [[SCRecommendLiveView alloc] initWithFrame:CGRectMake(self.width - SCREEN_FIX(23) - wh, SCREEN_FIX(9), wh, wh)];
        _liveView.adjustsImageWhenHighlighted = NO;
        [self.contentView addSubview:_liveView];
        
        @weakify(self)
        [_liveView sc_addEventTouchUpInsideHandle:^(id  _Nonnull sender) {
           @strongify(self)
            if (self.liveView.model && [self.delegate respondsToSelector:@selector(pushToLivePage:)]) {
                [self.delegate pushToLivePage:self.liveView.model];
            }
        }];

    }
    return _liveView;
}


@end


@implementation SCRecommendLiveView

- (void)setModel:(SCHomeActivityModel *)model
{
    _model = model;
    
    [self sd_setBackgroundImageWithURL:[NSURL URLWithString:model.imageUrl] forState:UIControlStateNormal placeholderImage:IMG_PLACE_HOLDER];
    
    self.textLabel.text = [NSString stringWithFormat:@"%li",model.liveAudience];
    [self.textLabel sizeToFit];
    self.textLabel.width += SCREEN_FIX(8.5);
    self.textBg.width = self.textLabel.right;
}

- (UIView *)textBg
{
    if (!_textBg) {
        CGFloat h = SCREEN_FIX(15);
        _textBg = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_FIX(6), SCREEN_FIX(7.5), 0, h)];
        _textBg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _textBg.layer.cornerRadius = h/2;
        [self addSubview:_textBg];

    }
    return _textBg;
}

- (UIImageView *)icon
{
    if (!_icon) {
        CGFloat wh = self.textBg.height;
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, wh, wh)];
        _icon.image = SCIMAGE(@"home_reccommend_live");
        [self.textBg addSubview:_icon];
    }
    return _icon;
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.right + SCREEN_FIX(4.5), SCREEN_FIX(2), 10, SCREEN_FIX(9.5))];
//        _textLabel.centerY = self.textBg.height/2;
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = SCFONT_SIZED_FIX(9.5);
        [self.textBg addSubview:_textLabel];
    }
    return _textLabel;
}

@end
