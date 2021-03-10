//
//  SCHomeAdCell.m
//  shopping
//
//  Created by gejunyu on 2021/3/2.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import "SCHomeAdCell.h"

@interface SCHomeAdCell ()
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) NSArray <UIButton *> *btnList;
@end

@implementation SCHomeAdCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        [self line];
        [self btnList];
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
    if (adList == _adList || adList.count == 0) {
        return;
    }
    
    
    _adList = adList;
    
    [self.btnList enumerateObjectsUsingBlock:^(UIButton * _Nonnull btn, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx >= adList.count) {
//            btn.hidden = YES;
            
        }else {
//            btn.hidden = NO;
            SCHomeTouchModel *model = adList[idx];
            
            [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.picUrl] forState:UIControlStateNormal placeholderImage:IMG_PLACE_HOLDER];
        }
        
    }];
    
    if (self.touchShowBlock) {
        SCHomeTouchModel *firstModel = adList.firstObject;
        self.touchShowBlock(firstModel);
    }
}

- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_FIX(4))];
        _line.backgroundColor = HEX_RGB(@"#F6F6F6");
        [self.contentView addSubview:_line];
    }
    return _line;
}

- (NSArray<UIButton *> *)btnList
{
    if (!_btnList) {
        CGFloat w      = SCREEN_FIX(162);
        CGFloat h      = SCREEN_FIX(94);
        CGFloat margin = SCREEN_FIX(10.5);
        CGFloat x      = (SCREEN_WIDTH - w*2 - margin)/2;
        
        NSArray *imgs = @[@"sc_phb",@"sc_ttdj"];
        
        NSMutableArray *mulArr = [NSMutableArray arrayWithCapacity:2];
        for (int i=0; i<2; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x + (w+margin)*i,kHomeAdRowH-h, w, h)];
            btn.layer.cornerRadius = 8;
            btn.layer.masksToBounds = YES;
            btn.adjustsImageWhenHighlighted = NO;
            btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
            [btn setBackgroundImage:SCIMAGE(imgs[i]) forState:UIControlStateNormal];
            [self.contentView addSubview:btn];
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
