//
//  SCRecommendActivitySubView.m
//  shopping
//
//  Created by gejunyu on 2021/3/4.
//  Copyright © 2021 jsmcc. All rights reserved
//

@interface SCActivityItemView : UIControl //商品
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *oldPriceLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end

@interface SCActivityCountdownView : UIView //倒计时
@property (nonatomic, copy) NSString *startTime;
@end

#import "SCRecommendActivitySubView.h"

//临时用     _list = @[@[@"直播"0],@[@"限时秒杀"1, @"新品预售"]2, @[@"超值拼团"3, @"优惠券"4]];每日抽奖5
@interface SCRecommendActivitySubView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *sellPointLabel;
@property (nonatomic, strong) UILabel *topicLabel;
@property (nonatomic, strong) SCActivityCountdownView *countdownView;
@property (nonatomic, strong) NSArray <SCActivityItemView *> *itemViewList; //商品

@property (nonatomic, strong) UIButton *pushButton;
@property (nonatomic, strong) UIButton *pushIcon;

@end

@implementation SCRecommendActivitySubView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}


- (void)getData
{
    //标题
    self.titleLabel.text = @"正在直播";
    [self.titleLabel sizeToFit];
    
    //卖点 /倒计时
    BOOL showSellPoint = arc4random()%2;
    if (showSellPoint) {
        self.sellPointLabel.hidden = NO;
        self.countdownView.hidden = YES;
        
        NSString *sp = @"直播好货低价购";
        self.sellPointLabel.text = sp;
        self.sellPointLabel.left = self.titleLabel.right + SCREEN_FIX(3.5);
        self.sellPointLabel.width = [sp calculateWidthWithFont:self.sellPointLabel.font height: self.sellPointLabel.height] + SCREEN_FIX(12);
        self.sellPointLabel.textColor = HEX_RGB(@"#007FFF");
        self.sellPointLabel.layer.borderColor = HEX_RGB(@"#007FFF").CGColor;
        
    }else {
        self.sellPointLabel.hidden = YES;
        self.countdownView.hidden = NO;
        
        self.countdownView.startTime = @"aaaaa";
        self.countdownView.left = self.titleLabel.right + SCREEN_FIX(5);

    }
    
    
    //主题
    self.topicLabel.text = @"品质好物 限量开团";
    self.topicLabel.textColor = HEX_RGB(@"#007FFF");
    [self.topicLabel sizeToFit];
    
    
    //是否是优惠券,抽奖
    BOOL hideItems = arc4random()%2;
    
    if (hideItems) {
        for (SCActivityItemView *itemView in self.itemViewList) {
            itemView.hidden = YES;
        }
        self.pushIcon.hidden = NO;
        self.pushButton.hidden = NO;
        [self.pushButton setTitle:@"立即领券 >" forState:UIControlStateNormal];
        [self.pushIcon setImage:IMG_PLACE_HOLDER forState:UIControlStateNormal];
        
        
    }else {
        self.pushIcon.hidden = YES;
        self.pushButton.hidden = YES;
        //商品
        [self.itemViewList enumerateObjectsUsingBlock:^(SCActivityItemView * _Nonnull itemView, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx > 1) {
                *stop = YES;
            }
            itemView.hidden = NO;
            itemView.icon.image = IMG_PLACE_HOLDER;
            itemView.oldPriceLabel.attributedText = [SCUtilities oldPriceAttributedString:3099 font:itemView.oldPriceLabel.font color:itemView.oldPriceLabel.textColor];
            itemView.priceLabel.text = @"¥2034";
            
            
        }];
    }
    

    
}

#pragma mark - ui
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_FIX(22), SCREEN_FIX(8), 0, SCREEN_FIX(16))];
        _titleLabel.font = SCFONT_SIZED_FIX(16);
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)sellPointLabel
{
    if (!_sellPointLabel) {
        _sellPointLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, SCREEN_FIX(18))];
        _sellPointLabel.centerY = self.titleLabel.centerY;
        _sellPointLabel.layer.cornerRadius = _sellPointLabel.height/2;
        _sellPointLabel.layer.borderWidth = 1;
//        _sellPointLabel.layer.masksToBounds = YES;
        _sellPointLabel.font = SCFONT_SIZED_FIX(10);
        _sellPointLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_sellPointLabel];
    }
    return _sellPointLabel;
}

- (UILabel *)topicLabel
{
    if (!_topicLabel) {
        _topicLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_FIX(22), self.titleLabel.bottom + SCREEN_FIX(6), 0, SCREEN_FIX(11))];
        _topicLabel.font = SCFONT_SIZED_FIX(11);
        [self addSubview:_topicLabel];
    }
    return _topicLabel;
}

- (SCActivityCountdownView *)countdownView
{
    if (!_countdownView) {
        _countdownView = [[SCActivityCountdownView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_FIX(57), SCREEN_FIX(16))];
        _countdownView.centerY = self.titleLabel.centerY;
        [self addSubview:_countdownView];
    }
    return _countdownView;
}

- (NSArray<SCActivityItemView *> *)itemViewList
{
    if (!_itemViewList) {
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:2];
        
        CGFloat w = SCREEN_FIX(65);
    //    CGFloat h = SCREEN_FIX(95);
        CGFloat edge = SCREEN_FIX(21); //屏幕边距
        CGFloat margin = self.width - edge*2 - w*2;
        
        for (int i=0; i<2; i++) {
            SCActivityItemView *itemView = [[SCActivityItemView alloc] initWithFrame:CGRectMake(edge + (w+margin)*i, self.topicLabel.bottom + SCREEN_FIX(6.5), w, SCREEN_FIX(95))];
            [self addSubview:itemView];
            [temp addObject:itemView];
        }
        
        _itemViewList = temp.copy;
    }
    return _itemViewList;
}

- (UIButton *)pushButton
{
    if (!_pushButton) {
        _pushButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_FIX(12), SCREEN_FIX(87), SCREEN_FIX(79.5), SCREEN_FIX(21))];
        [_pushButton setBackgroundImage:SCIMAGE(@"home_orange") forState:UIControlStateNormal];
        _pushButton.titleLabel.font = SCFONT_SIZED_FIX(12);
        [_pushButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _pushButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 1, 0);
        [self addSubview:_pushButton];
        
    }
    return _pushButton;
}

- (UIButton *)pushIcon
{
    if (!_pushIcon) {
        CGFloat wh = SCREEN_FIX(110);
        _pushIcon = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_FIX(67), SCREEN_FIX(30), wh, wh)];
        _pushIcon.adjustsImageWhenHighlighted = NO;
        [self addSubview:_pushIcon];
        [self insertSubview:_pushIcon belowSubview:self.pushButton];
    }
    return _pushIcon;
}

@end




@implementation SCActivityItemView

- (UIImageView *)icon
{
    if (!_icon) {
        CGFloat wh = self.width;
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, wh, wh)];
        [self addSubview:_icon];
    }
    
    return _icon;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        CGFloat h = SCREEN_FIX(12);
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height-h, self.width, h)];
        _priceLabel.font = SCFONT_SIZED_FIX(12);
        _priceLabel.textColor = HEX_RGB(@"#FF0000");
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_priceLabel];
    }
    return _priceLabel;
}

- (UILabel *)oldPriceLabel
{
    if (!_oldPriceLabel) {
        CGFloat h = SCREEN_FIX(9);
        CGFloat margin = (self.height - self.icon.height - self.priceLabel.height - h)/2; //在图片和现价空隙的中间位置
        _oldPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.icon.bottom+margin, self.width, h)];
        _oldPriceLabel.font = SCFONT_SIZED_FIX(9);
        _oldPriceLabel.textAlignment = NSTextAlignmentCenter;
        _oldPriceLabel.textColor = HEX_RGB(@"#8D8D8D");
        [self addSubview:_oldPriceLabel];
    }
    return _oldPriceLabel;
}


@end


@implementation SCActivityCountdownView
{
    NSMutableArray *_labelList;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        sc_pink
        [self prepareUI];
        
    }
    return self;
}

- (void)prepareUI
{
    _labelList = [NSMutableArray arrayWithCapacity:3];
    
    CGFloat wh = self.height;
    CGFloat m = (self.width - wh*3)/2;
    
    CGFloat x = 0;
    //0 2 4     1 3
    for (int i=0; i<5; i++) {
        if (i%2) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, m, SCREEN_FIX(11))];
            label.centerY = self.height/2 - 1;
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = HEX_RGB(@"#FF1448");
            label.font = SCFONT_SIZED_FIX(11);
            label.text = @":";
            [self addSubview:label];
            x = label.right;
            
        }else {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x, 0, wh, wh)];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = HEX_RGB(@"#FF1448");
            label.textColor = [UIColor whiteColor];
            label.font = SCFONT_SIZED_FIX(11);
            label.layer.cornerRadius = SCREEN_FIX(3);
            label.layer.masksToBounds = YES;
            [self addSubview:label];
            x = label.right;
            [_labelList addObject:label];
        }
    }
}

- (void)setStartTime:(NSString *)startTime
{
    if (_labelList.count < 3) {
        return;
    }
    
    UILabel *hourLabel = _labelList[0];
    hourLabel.text = @"12";
    
    UILabel *minuteLabel = _labelList[1];
    minuteLabel.text = @"48";
    
    UILabel *secondLabel = _labelList[2];
    secondLabel.text = @"59";
}

@end
