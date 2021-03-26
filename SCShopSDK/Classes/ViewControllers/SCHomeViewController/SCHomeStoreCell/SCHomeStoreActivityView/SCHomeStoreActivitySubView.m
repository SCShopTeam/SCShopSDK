//
//  SCHomeStoreActivitySubView.m
//  shopping
//
//  Created by gejunyu on 2021/3/4.
//  Copyright © 2021 jsmcc. All rights reserved
//

#import "SCHomeStoreActivitySubView.h"
#import "SCHomeStoreModel.h"

@interface SCActivityItemView : UIControl //商品
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *oldPriceLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *preferentialFeeButton;  //膨胀折扣
@property (nonatomic, strong) UIButton *groupPersonCountButton; //成团人数
@property (nonatomic, strong) SCHomeGoodsModel *model;

@end

@interface SCActivityCountdownView : UIView //倒计时
@property (nonatomic, assign) NSInteger countdownSeconds;
@property (nonatomic, strong) UILabel *hourLabel;
@property (nonatomic, strong) UILabel *minuteLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, weak) NSTimer *timer;
- (void)startCountdown:(NSString *)endTime;
@end


@interface SCHomeStoreActivitySubView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *sellPointLabel;
@property (nonatomic, strong) UILabel *topicLabel;
@property (nonatomic, strong) SCActivityCountdownView *countdownView;
@property (nonatomic, strong) NSArray <SCActivityItemView *> *itemViewList; //商品

@property (nonatomic, strong) UIButton *activityButton;
@property (nonatomic, strong) UIImageView *activityIcon;

@end

@implementation SCHomeStoreActivitySubView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setModel:(SCHomeActivityModel *)model
{
    _model = model;
    
    //标题
    self.titleLabel.text = model.name;
    [self.titleLabel sizeToFit];
    
    
    UIColor *textColor = (model.type == SCHomeActivityTypeLimited || model.type == SCHomeActivityTypeActivity) ? HEX_RGB(@"#FF1448") : HEX_RGB(@"#007FFF");
    
    // 卖点 /倒计时
    if (model.type == SCHomeActivityTypeLimited) { //倒计时
        self.sellPointLabel.hidden = YES;
        self.countdownView.hidden = NO;
        
        [self.countdownView startCountdown:model.endTime];
        self.countdownView.left = self.titleLabel.right + SCREEN_FIX(5);
        
    }else {  //卖点
        self.sellPointLabel.hidden = NO;
        self.countdownView.hidden = YES;
        [self.countdownView startCountdown:@""];
        
        //        NSString *sp = model.sellPoint.length > 5 ? [model.sellPoint substringToIndex:5] : model.sellPoint; //最多5个字
        self.sellPointLabel.left = self.titleLabel.right + SCREEN_FIX(3.5);
        self.sellPointLabel.text = model.sellPoint;
        self.sellPointLabel.width = [model.sellPoint calculateWidthWithFont:self.sellPointLabel.font height:self.sellPointLabel.height] + SCREEN_FIX(12);
        
        self.sellPointLabel.textColor = textColor;
        self.sellPointLabel.layer.borderColor = textColor.CGColor;
    }
    
    
    
    //主题
    self.topicLabel.text = model.topic;
    self.topicLabel.textColor = textColor;
    [self.topicLabel sizeToFit];
    
    
    //活动
    if (model.type == SCHomeActivityTypeActivity) {
        for (SCActivityItemView *itemView in self.itemViewList) {
            itemView.hidden = YES;
        }
        self.activityIcon.hidden = NO;
        self.activityButton.hidden = NO;
        
        [self.activityIcon sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:IMG_PLACE_HOLDER];
        
    }else {
        self.activityIcon.hidden = YES;
        self.activityButton.hidden = YES;
        
        //商品
        [self.itemViewList enumerateObjectsUsingBlock:^(SCActivityItemView * _Nonnull itemView, NSUInteger idx, BOOL * _Nonnull stop) {
            if (model.goodsList.count == 0) {
                itemView.hidden = YES;
                
            }else {
                itemView.hidden = NO;
                
                //固定显示两个商品，如果不足两个，重复显示第一个
                NSInteger index = (idx >= model.goodsList.count ? 0 : idx);
                SCHomeGoodsModel *goodsModel = model.goodsList[index];
                
                itemView.model = goodsModel;
                
                @weakify(self)
                [itemView sc_addEventTouchUpInsideHandle:^(id  _Nonnull sender) {
                    @strongify(self)
                    if ([self.delegate respondsToSelector:@selector(pushToGoodsList:)]) {
                        [self.delegate pushToGoodsList:model];
                    }
                }];
                
            }
            
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

- (UIButton *)activityButton
{
    if (!_activityButton) {
        _activityButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_FIX(12), SCREEN_FIX(87), SCREEN_FIX(79.5), SCREEN_FIX(21))];
        [_activityButton setBackgroundImage:SCIMAGE(@"home_orange") forState:UIControlStateNormal];
        _activityButton.titleLabel.font = SCFONT_SIZED_FIX(12);
        [_activityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_activityButton setTitle:@"立即领券 >" forState:UIControlStateNormal];
        _activityButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 1, 0);
        [self addSubview:_activityButton];
        
        @weakify(self)
        [_activityButton sc_addEventTouchUpInsideHandle:^(id  _Nonnull sender) {
            @strongify(self)
            if (self.model && [self.delegate respondsToSelector:@selector(pushToActivityPage:)]) {
                [self.delegate pushToActivityPage:self.model];
            }
        }];
        
    }
    return _activityButton;
}

- (UIImageView *)activityIcon
{
    if (!_activityIcon) {
        CGFloat wh = SCREEN_FIX(110);
        _activityIcon = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_FIX(67), SCREEN_FIX(30), wh, wh)];
        [self addSubview:_activityIcon];
        [self insertSubview:_activityIcon belowSubview:self.activityButton];
    }
    return _activityIcon;
}

@end




@implementation SCActivityItemView
- (void)setModel:(SCHomeGoodsModel *)model
{
    _model = model;
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.goodsPictureUrl] placeholderImage:IMG_PLACE_HOLDER];
    self.oldPriceLabel.attributedText = [SCUtilities oldPriceAttributedString:(model.guidePrice/1000*1.f) font:self.oldPriceLabel.font color:self.oldPriceLabel.textColor];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", [SCUtilities removeFloatSuffix:model.activityPrice/1000*1.f]];
    
    _preferentialFeeButton.hidden  = YES;
    _groupPersonCountButton.hidden = YES;
    
    if (model.parentType == SCHomeActivityTypePresale) {
        if (model.offerType.length > 0 && model.preferentialFee > 0) {
            self.preferentialFeeButton.hidden = NO;
            [self.preferentialFeeButton setTitle:[NSString stringWithFormat:@"%@%li",model.offerType,model.preferentialFee] forState:UIControlStateNormal];
            
        }
        
    }else if (model.parentType == SCHomeActivityTypeGroup) {
        self.groupPersonCountButton.hidden = NO;
        [self.groupPersonCountButton setTitle:[NSString stringWithFormat:@"%li人团",model.groupPersonCount] forState:UIControlStateNormal];
    }
    
}

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

- (UIButton *)preferentialFeeButton
{
    if (!_preferentialFeeButton) {
        _preferentialFeeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_FIX(54), SCREEN_FIX(14))];
        _preferentialFeeButton.centerX = self.icon.centerX;
        _preferentialFeeButton.bottom  = self.icon.bottom;
        [_preferentialFeeButton setBackgroundImage:SCIMAGE(@"home_fee") forState:UIControlStateNormal];
        _preferentialFeeButton.titleLabel.font = SCFONT_SIZED_FIX(7);
        [_preferentialFeeButton setTitleColor:HEX_RGB(@"#FF1448") forState:UIControlStateNormal];
        _preferentialFeeButton.userInteractionEnabled = NO;
        [self addSubview:_preferentialFeeButton];
        
    }
    return _preferentialFeeButton;
}

- (UIButton *)groupPersonCountButton
{
    if (!_groupPersonCountButton) { //home_group_num 32 17
        _groupPersonCountButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_FIX(32), SCREEN_FIX(17))];
        _groupPersonCountButton.centerX = self.icon.centerX;
        _groupPersonCountButton.bottom  = self.icon .bottom - SCREEN_FIX(3.5);
        _groupPersonCountButton.titleLabel.font = SCFONT_SIZED_FIX(9);
        [_groupPersonCountButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _groupPersonCountButton.userInteractionEnabled = NO;
        [self addSubview:_groupPersonCountButton];
        
    }
    return _groupPersonCountButton;
}

@end


@implementation SCActivityCountdownView
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
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:3];
    
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
            label.font = SCFONT_SIZED_FIX(10);
            label.text = @":";
            [self addSubview:label];
            x = label.right;
            
        }else {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x, 0, wh, wh)];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = HEX_RGB(@"#FF1448");
            label.textColor = [UIColor whiteColor];
            label.font = SCFONT_SIZED_FIX(10);
            label.layer.cornerRadius = SCREEN_FIX(3);
            label.layer.masksToBounds = YES;
            [self addSubview:label];
            x = label.right;
            [temp addObject:label];
        }
    }
    
    _hourLabel   = temp[0];
    _minuteLabel = temp[1];
    _secondLabel = temp[2];
}

- (void)startCountdown:(NSString *)endTime
{
    [self invalidateTimer];
    
    if (!VALID_STRING(endTime)) {
        self.countdownSeconds = 0;
        return;
    }
    
    NSDate *endDate = [[NSDate alloc] initWithTimeIntervalSince1970:(endTime.integerValue/1000)];
    
    NSDate *today = [NSDate date];
    
    NSTimeInterval time = [endDate timeIntervalSinceDate:today];
    
    if (time < 0) {
        self.countdownSeconds = 0;
        
    }else {
        self.countdownSeconds = time;
        [self setupTimer];
    }
}

#pragma mark -timer
- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)setupTimer
{
    [self invalidateTimer];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    
    _timer = timer;
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)countDown
{
    if (self.countdownSeconds*1.f <= 0.9999) {
        [self invalidateTimer];
    }
    
    self.countdownSeconds--;
    
    
    
}

- (void)setCountdownSeconds:(NSInteger)countdownSeconds
{
    _countdownSeconds = countdownSeconds;
    
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",countdownSeconds/3600];
    self.hourLabel.text = str_hour;
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(countdownSeconds%3600)/60];
    self.minuteLabel.text = str_minute;
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",countdownSeconds%60];
    self.secondLabel.text = str_second;
    
    
    
}

- (void)dealloc
{
    [self invalidateTimer];
}

@end
