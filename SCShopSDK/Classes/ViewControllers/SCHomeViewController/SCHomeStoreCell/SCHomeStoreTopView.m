//
//  SCHomeStoreTopView.m
//  shopping
//
//  Created by gejunyu on 2021/3/4.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import "SCHomeStoreTopView.h"
#import "SCHomeStoreModel.h"

@interface SCHomeStoreTopView ()
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UIButton *serviceButton;
@property (nonatomic, strong) UIButton *phonebutton;
@property (nonatomic, strong) NSArray <UIButton *>*lightSpotBtns;

@end

@implementation SCHomeStoreTopView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self serviceButton];
    }
    return self;
}

- (void)setModel:(SCHomeStoreModel *)model
{
    _model = model;
    
    //距离
    if (model.locationError) {
        self.distanceLabel.text = @"暂无位置信息";
        
    }else if (model.distance >= 10000) { //大于10km不展示
        self.distanceLabel.text = nil;
        
    }else {
        NSString *numStr = model.distance >= 1000 ? [NSString stringWithFormat:@"%.1fkm",(model.distance/1000.0)] : [NSString stringWithFormat:@"%lim",model.distance]; //大于1000m单位用km
        NSString *distanceStr = [NSString stringWithFormat:@"距离您%@",numStr];
        NSMutableAttributedString *mulA = [[NSMutableAttributedString alloc] initWithString:distanceStr];
        [mulA addAttributes:@{NSForegroundColorAttributeName:HEX_RGB(@"#ff3434")} range:[distanceStr rangeOfString:numStr]];
        self.distanceLabel.attributedText = mulA;
    }
    
    [self.distanceLabel sizeToFit];
    
    CGFloat titleW = self.serviceButton.left - 2 - self.distanceLabel.width - SCREEN_FIX(5);
    
    //标题
    self.titleLabel.text = model.storeName;
    [self.titleLabel sizeToFit];
    self.titleLabel.width = MIN(self.titleLabel.width, titleW);
    //
    self.distanceLabel.left = self.titleLabel.right + SCREEN_FIX(5);
    

    
    //亮点标签
    BOOL isInHoure = model.distance <= 5000 && !model.locationError; //是否是1小时达

    //最多显示4个标签， 1小时达占一个
    NSInteger maxLightSpotNum = isInHoure ? 3 : 4;

    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:4];
    [model.lightspotList enumerateObjectsUsingBlock:^(SCHomeLightSpotModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < maxLightSpotNum) {
            [temp addObject:obj.lightSpotName];
        }
    }];
    
    if (isInHoure) {
        [temp addObject:@"一小时达"];
    }

    
    __block CGFloat x = SCREEN_FIX(19);
    [self.lightSpotBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull btn, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx >= temp.count) {
            btn.hidden = YES;
            
        }else {
            btn.hidden = NO;
            btn.left = x;
            NSString *tag = temp[idx];
            [btn setTitle:tag forState:UIControlStateNormal];
            //是否是一小时达的标签
            BOOL isInHourTag = isInHoure && idx == temp.count - 1;
            if (isInHourTag) {
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn setBackgroundImage:SCIMAGE(@"home_recommend_tag3") forState:UIControlStateNormal];
                
            }else {
                [btn setTitleColor:(idx == 0 ? [UIColor whiteColor] : [UIColor blackColor]) forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage sc_imageNamed:[NSString stringWithFormat:@"home_recommend_tag%li",idx]]forState:UIControlStateNormal];
            }
            
            CGFloat textW = [tag calculateWidthWithFont:btn.titleLabel.font height:btn.height];
            btn.width = textW + SCREEN_FIX(5)*2; //两边5的间距
            
            x = btn.right + SCREEN_FIX(12.5);
        }
    }];

}

- (NSArray<UIButton *> *)lightSpotBtns
{
    if (!_lightSpotBtns) {
        CGFloat btnH = SCREEN_FIX(18);
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:4];
        
        for (int i=0; i<4; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.height - SCREEN_FIX(8) - btnH, 0, btnH)];
            btn.titleLabel.font = SCFONT_SIZED_FIX(11);
            btn.userInteractionEnabled = NO;
            [self addSubview:btn];
            [temp addObject:btn];
        }
        
        _lightSpotBtns = temp.copy;
    }
    return _lightSpotBtns;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(pushToStorePage)]) {
        [self.delegate pushToStorePage];
    }
}

#pragma mark -ui
- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, SCREEN_FIX(4))];
        _line.backgroundColor = HEX_RGB(@"#F6F6F6");
        [self addSubview:_line];
    }
    return _line;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_FIX(18.5), self.line.bottom + SCREEN_FIX(9.5), 100, SCREEN_FIX(16))];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = SCFONT_SIZED_FIX(16);
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)distanceLabel
{
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.line.bottom + (IsIPhoneXLater ? SCREEN_FIX(14.5) : SCREEN_FIX(13)), 20, SCREEN_FIX(12))];
        _distanceLabel.font = SCFONT_SIZED(12);
        _distanceLabel.textColor = HEX_RGB(@"#7F7F7E");
        [self addSubview:_distanceLabel];
    }
    return _distanceLabel;
}

- (UIButton *)phonebutton
{
    if (!_phonebutton) {
        CGFloat wh = SCREEN_FIX(28.5);
        _phonebutton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - SCREEN_FIX(5) - wh, self.line.bottom + SCREEN_FIX(15.5), wh, wh)];
        _phonebutton.adjustsImageWhenHighlighted = NO;
        [_phonebutton setImage:SCIMAGE(@"home_recommend_tel") forState:UIControlStateNormal];
        [self addSubview:_phonebutton];
        
        @weakify(self)
        [_phonebutton sc_addEventTouchUpInsideHandle:^(id  _Nonnull sender) {
            @strongify(self)
            if ([self.delegate respondsToSelector:@selector(call)]) {
                [self.delegate call];
            }
        }];
    }
    return _phonebutton;
}

- (UIButton *)serviceButton
{
    if (!_serviceButton) {
        CGFloat wh = SCREEN_FIX(28.5);
        _serviceButton = [[UIButton alloc] initWithFrame:CGRectMake(self.phonebutton.left - SCREEN_FIX(3) - wh, self.line.bottom + SCREEN_FIX(15.5), wh, wh)];
        _serviceButton.adjustsImageWhenHighlighted = NO;
        [_serviceButton setImage:SCIMAGE(@"home_recommend_service") forState:UIControlStateNormal];
        [self addSubview:_serviceButton];
        
        @weakify(self)
        [_serviceButton sc_addEventTouchUpInsideHandle:^(id  _Nonnull sender) {
           @strongify(self)
            if ([self.delegate respondsToSelector:@selector(pushToService)]) {
                [self.delegate pushToService];
            }
        }];
    }
    return _serviceButton;
}

@end
