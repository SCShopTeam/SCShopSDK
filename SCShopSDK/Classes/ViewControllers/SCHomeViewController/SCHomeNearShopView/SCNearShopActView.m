//
//  SCNearShopActView.m
//  shopping
//
//  Created by gejunyu on 2020/8/20.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCNearShopActView.h"
#import "SCHomeShopModel.h"

@interface SCActShopView : UIView
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *pointLabel;
@property (nonatomic, strong) UIButton *shopButton;
@property (nonatomic, strong) SCHActImageModel *imageModel;

@end

@interface SCNearShopActView ()
@property (nonatomic, strong) UILabel *leftTitleLabel;
@property (nonatomic, strong) UILabel *leftSubTitleLabel;
@property (nonatomic, strong) UILabel *rigthTitleLabel;
@property (nonatomic, strong) UILabel *rightSubTitleLabel;
@property (nonatomic, strong) NSArray <SCActShopView *> *shopViewList;

@end

@implementation SCNearShopActView

- (void)actShopSelect:(SCHActImageModel *)model index:(NSInteger)index
{
    if (_actBlock && VALID_STRING(model.actImageLink)) {
        _actBlock(index, model);
    }
}

- (void)setActList:(NSArray<SCHActModel *> *)actList
{
    _actList = actList;
    
    
    //左边活动
    if (!VALID_ARRAY(actList)) {
        return;
    }
    
    SCHActModel *leftModel = actList.firstObject;
    self.leftTitleLabel.text = leftModel.mainTitle;
    [self.leftTitleLabel sizeToFit];
    
    NSString *leftSubTitle = leftModel.subTitle;
    CGFloat leftSubW = [leftSubTitle calculateWidthWithFont:self.leftSubTitleLabel.font height:self.leftSubTitleLabel.height] + SCREEN_FIX(16);
    self.leftSubTitleLabel.left = self.leftTitleLabel.right + SCREEN_FIX(5);
    self.leftSubTitleLabel.width = leftSubW;
    self.leftSubTitleLabel.text = leftSubTitle;
    [leftModel.actImageList enumerateObjectsUsingBlock:^(SCHActImageModel * _Nonnull imageModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < 2) {
            SCActShopView *shopView = self.shopViewList[idx];
            shopView.imageModel = imageModel;
        }
        
    }];
    
    
    //右边活动
    if (actList.count < 2) {
        return;
    }
    
    SCHActModel *rightModel = actList[1];
    self.rigthTitleLabel.text = rightModel.mainTitle;
    [self.rigthTitleLabel sizeToFit];
    
    NSString *rightSubTitle = rightModel.subTitle;
    CGFloat rightSubW = [rightSubTitle calculateWidthWithFont:self.rightSubTitleLabel.font height:self.rightSubTitleLabel.height] + SCREEN_FIX(16);
    self.rightSubTitleLabel.left = self.rigthTitleLabel.right + SCREEN_FIX(5);
    self.rightSubTitleLabel.width = rightSubW;
    self.rightSubTitleLabel.text = rightSubTitle;
    [rightModel.actImageList enumerateObjectsUsingBlock:^(SCHActImageModel * _Nonnull imageModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < 2) {
            SCActShopView *shopView = self.shopViewList[idx+2];
            shopView.imageModel = imageModel;
        }
        
    }];
    
    
    
}

#pragma mark -ui
- (UILabel *)leftTitleLabel
{
    if (!_leftTitleLabel) {
        _leftTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_FIX(18), SCREEN_FIX(14), 0, SCREEN_FIX(15))];
        _leftTitleLabel.font = SCFONT_BOLD_SIZED(15);
        _leftTitleLabel.textColor = [UIColor blackColor];
        _leftTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_leftTitleLabel];
    }
    return _leftTitleLabel;
}

- (UILabel *)leftSubTitleLabel
{
    if (!_leftSubTitleLabel) {
        _leftSubTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, SCREEN_FIX(19))];
        _leftSubTitleLabel.centerY = self.leftTitleLabel.centerY;
        _leftSubTitleLabel.layer.cornerRadius = _leftSubTitleLabel.height/2;
        _leftSubTitleLabel.layer.borderWidth = 1;
        _leftSubTitleLabel.layer.borderColor = HEX_RGB(@"#FC301F").CGColor;
        _leftSubTitleLabel.layer.masksToBounds = YES;
        _leftSubTitleLabel.font = SCFONT_SIZED(11);
        _leftSubTitleLabel.textAlignment = NSTextAlignmentCenter;
        _leftSubTitleLabel.textColor = HEX_RGB(@"#FC301F");
        [self addSubview:_leftSubTitleLabel];
    }
    return _leftSubTitleLabel;
}

- (UILabel *)rigthTitleLabel
{
    if (!_rigthTitleLabel) {
        _rigthTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_FIX(199.5), SCREEN_FIX(14), 0, SCREEN_FIX(15))];
        _rigthTitleLabel.font = SCFONT_BOLD_SIZED(15);
        _rigthTitleLabel.textColor = [UIColor blackColor];
        _rigthTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_rigthTitleLabel];
    }
    return _rigthTitleLabel;
}

- (UILabel *)rightSubTitleLabel
{
    if (!_rightSubTitleLabel) {
        _rightSubTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, SCREEN_FIX(19))];
        _rightSubTitleLabel.centerY = self.rigthTitleLabel.centerY;
        _rightSubTitleLabel.layer.cornerRadius = _rightSubTitleLabel.height/2;
        _rightSubTitleLabel.layer.borderWidth = 1;
        _rightSubTitleLabel.layer.borderColor = HEX_RGB(@"#2C81FF").CGColor;
        _rightSubTitleLabel.layer.masksToBounds = YES;
        _rightSubTitleLabel.font = SCFONT_SIZED(11);
        _rightSubTitleLabel.textAlignment = NSTextAlignmentCenter;
        _rightSubTitleLabel.textColor = HEX_RGB(@"#2C81FF");
        [self addSubview:_rightSubTitleLabel];
        
    }
    return _rightSubTitleLabel;
}

- (NSArray<SCActShopView *> *)shopViewList
{
    if (!_shopViewList) {
        NSMutableArray *mulArr = [NSMutableArray arrayWithCapacity:4];
        
        CGFloat leftMargin  = SCREEN_FIX(14);
        CGFloat rightMargin = SCREEN_FIX(19);
        CGFloat w = SCREEN_FIX(67.5);
        CGFloat horMargin = (self.width - leftMargin - rightMargin -w*4)/3;
        
        for (int i=0; i<4; i++) {
            SCActShopView *view = [[SCActShopView alloc] initWithFrame:CGRectMake(leftMargin + (w+horMargin)*i, SCREEN_FIX(46.5), w, SCREEN_FIX(101))];
            view.index = i;
            [self addSubview:view];
            [mulArr addObject:view];
            
            @weakify(self)
            [view.shopButton sc_addEventTouchUpInsideHandle:^(UIButton * _Nonnull sender) {
                @strongify(self)
                [self actShopSelect:view.imageModel index:i];
            }];
        }
        _shopViewList = mulArr.copy;
        
    }
    return _shopViewList;
}

@end


@implementation SCActShopView

- (void)setIndex:(NSInteger)index
{
    _index = index;
    
    switch (index) {
        case 0:
        {
            self.titleLabel.textColor = HEX_RGB(@"#3778EC");
            self.pointLabel.textColor = HEX_RGB(@"#F2270C");
        }
            break;
        case 1:
        {
            self.titleLabel.textColor = HEX_RGB(@"#FF8B24");
            self.pointLabel.textColor = HEX_RGB(@"#F2270C");
        }
            break;
        case 2:
        {
            self.titleLabel.textColor = HEX_RGB(@"#FF00A3");
            self.pointLabel.textColor = HEX_RGB(@"#3A86EE");
        }
            break;
        case 3:
        {
            self.titleLabel.textColor = HEX_RGB(@"#FF8B24");
            self.pointLabel.textColor = HEX_RGB(@"#3A86EE");
        }
            break;
            
        default:
            break;
    }
}

- (void)setImageModel:(SCHActImageModel *)imageModel
{
    _imageModel = imageModel;
    
    self.titleLabel.text = imageModel.title;
    self.pointLabel.text = imageModel.sellingPoint;
    [self.shopButton sd_setImageWithURL:[NSURL URLWithString:imageModel.actImageUrl] forState:UIControlStateNormal placeholderImage:IMG_PLACE_HOLDER];
}

#pragma mark -ui
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, SCREEN_FIX(12))];
        _titleLabel.font = SCFONT_BOLD_SIZED(12);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIButton *)shopButton
{
    if (!_shopButton) {
        CGFloat wh = SCREEN_FIX(67.5);
        _shopButton = [[UIButton alloc] initWithFrame:CGRectMake((self.width-wh)/2, self.titleLabel.bottom + SCREEN_FIX(3), wh, wh)];
        _shopButton.adjustsImageWhenHighlighted = NO;
        [self addSubview:_shopButton];
    }
    return _shopButton;
}

- (UILabel *)pointLabel
{
    if (!_pointLabel) {
        _pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, SCREEN_FIX(12))];
        _pointLabel.bottom = self.height;
        _pointLabel.textAlignment = NSTextAlignmentCenter;
        _pointLabel.font = SCFONT_SIZED(12);
        [self addSubview:_pointLabel];
    }
    return _pointLabel;
}

@end
