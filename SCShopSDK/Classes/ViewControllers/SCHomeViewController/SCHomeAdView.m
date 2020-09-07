//
//  SCHomeAdView.m
//  shopping
//
//  Created by gejunyu on 2020/7/8.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCHomeAdView.h"

@interface SCHomeAdView ()
@property (nonatomic, strong) NSArray <UIButton *> *btnList;
@end

@implementation SCHomeAdView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)btnClicked:(NSInteger)index
{
    if (!_selectBlock || index >= _adList.count) {
        return;
    }
    
    SCHomeTouchModel *model = _adList[index];
    
    if (VALID_STRING(model.linkUrl)) {
        _selectBlock(index, model);
    }
}


- (void)setAdList:(NSArray<SCHomeTouchModel *> *)adList
{
    _adList = adList;
    
    [self.btnList enumerateObjectsUsingBlock:^(UIButton * _Nonnull btn, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx >= adList.count) {
//            [btn setImage:IMG_PLACE_HOLDER forState:UIControlStateNormal];
            btn.hidden = YES;
            
        }else {
            btn.hidden = NO;
            SCHomeTouchModel *model = adList[idx];
            
            [btn sd_setImageWithURL:[NSURL URLWithString:model.picUrl] forState:UIControlStateNormal placeholderImage:IMG_PLACE_HOLDER];
        }
        
    }];
}

- (NSArray<UIButton *> *)btnList
{
    if (!_btnList) {
        CGFloat w      = SCREEN_FIX(162.5);
        CGFloat h      = SCREEN_FIX(90);
        CGFloat margin = SCREEN_FIX(10);
        CGFloat x      = (self.width - w*2 - margin)/2;
        
        NSMutableArray *mulArr = [NSMutableArray arrayWithCapacity:2];
        for (int i=0; i<2; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x + (w+margin)*i,(self.height-h)/2, w, h)];
            btn.layer.cornerRadius = 8;
            btn.layer.masksToBounds = YES;
            btn.adjustsImageWhenHighlighted = NO;
            btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
            [self addSubview:btn];
            [mulArr addObject:btn];
            
            @weakify(self)
            [btn sc_addEventTouchUpInsideHandle:^(UIButton * _Nonnull sender) {
                @strongify(self)
                [self btnClicked:i];
            }];
            
        }
        _btnList = mulArr.copy;
    }
    return _btnList;
}


@end
