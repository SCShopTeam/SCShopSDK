//
//  SCWitStoreCell.m
//  shopping
//
//  Created by gejunyu on 2020/8/29.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCWitStoreCell.h"
#import "SCWitStoreHeader.h"

#define kVerEdge   SCREEN_FIX(10)
#define kOrderH    SCREEN_FIX(45)
#define kInfoH     SCREEN_FIX(97)

@interface SCWitStoreCell ()
@property (nonatomic, strong) UIView *whiteBG;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *dataView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIButton *styleIcon;
@property (nonatomic, strong) UILabel *couponTipLabel;
@property (nonatomic, strong) NSArray <UILabel *>*couponLabelList;
@property (nonatomic, strong) UILabel *peopleNumLabel;
@property (nonatomic, strong) UIButton *phoneBtn;
@property (nonatomic, strong) UIView *blueView;

@end

@implementation SCWitStoreCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+ (void)calculateRowHeight:(SCWitStoreModel *)model
{
    CGFloat h = kVerEdge*2 + kInfoH + (model.line ? kOrderH : 0);
    
    model.rowHeight = h;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.whiteBG.height    = self.height;
    self.bottomView.bottom = self.height;
    self.dataView.height   = self.whiteBG.height - kVerEdge*2;
    self.blueView.bottom   = self.dataView.height;
}


- (void)setStyle:(SCWitCornerStyle)style
{
    _style = style;
    
    switch (style) {
        case SCWitCornerStyleNone:
            self.topView.hidden    = NO;
            self.bottomView.hidden = NO;
            break;
        case SCWitCornerStyleTop:
            self.topView.hidden    = YES;
            self.bottomView.hidden = NO;
            break;
        case SCWitCornerStyleBottom:
            self.topView.hidden    = NO;
            self.bottomView.hidden = YES;
            break;
            
        case SCWitCornerStyleTop | SCWitCornerStyleBottom:
            self.topView.hidden    = YES;
            self.bottomView.hidden = YES;
            break;
            
        default:
            break;
    }
}


- (void)setModel:(SCWitStoreModel *)model
{
    if (_model) {
        _model.cell = nil;
    }
    
    _model = model;
    _model.cell = self;
    
    //标题
    self.titleLabel.text = model.storeName;
    [self.titleLabel sizeToFit];
    if (self.titleLabel.width > SCREEN_FIX(200)) {
        self.titleLabel.width = SCREEN_FIX(200);
    }
    
    //旗舰
    self.styleIcon.hidden = !model.professional;
    self.styleIcon.left = self.titleLabel.right + SCREEN_FIX(4); //professional
    
    //地址
    self.addressLabel.text = NSStringFormat(@"%@ | %@",(model.geoDistance ?: @"0m"), (model.storeAddress ?: @""));
    
    //电话
    self.phoneBtn.hidden = !VALID_STRING(model.contactPhone);
    
    //排队
    self.blueView.hidden = !model.line;
    
    //排队人数
    self.peopleNumLabel.hidden = YES;
    if (model.line && model.queueInfoModel) {
        self.peopleNumLabel.hidden = NO;
        NSString *num = model.queueInfoModel.queue_NUMBER;
        if ([num isEqualToString:@"0"] || !VALID_STRING(num)) {
            self.peopleNumLabel.text = @"当前无需排队";
            
        }else {
            NSString *numStr = NSStringFormat(@"前方排队人数：%@",num);
            NSMutableAttributedString *mulAtt = [[NSMutableAttributedString alloc] initWithString:numStr];
            [mulAtt addAttributes:@{NSForegroundColorAttributeName:HEX_RGB(@"#1D94FC"), NSFontAttributeName:SCFONT_SIZED(SCREEN_FIX(15))} range:[numStr rangeOfString:num]];
            self.peopleNumLabel.attributedText = mulAtt;
        }
    }

    
    //优惠券
    __block CGFloat x = self.couponTipLabel.left;
    
    [self.couponLabelList enumerateObjectsUsingBlock:^(UILabel * _Nonnull label, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx >= model.couponList.count) {
            label.hidden = YES;

        }else {
            label.hidden = NO;

            SCWitCouponModel *couponModel = model.couponList[idx];
            
            CGFloat width = [couponModel.couName calculateWidthWithFont:label.font height:label.height] + SCREEN_FIX(8);
            
            label.left  = x;
            label.width = width;
            label.text  = couponModel.couName;
            
            x = label.right + SCREEN_FIX(5);
        }
    }];
    
    self.couponTipLabel.hidden = model.couponList.count;
}

#pragma mark -ui
- (UIView *)whiteBG
{
    if (!_whiteBG) {
        CGFloat x = kWitStoreHorMargin;
        _whiteBG = [[UIView alloc] initWithFrame:CGRectMake(x, 0, SCREEN_WIDTH-x*2, 0)];
        _whiteBG.backgroundColor = [UIColor whiteColor];
        _whiteBG.layer.cornerRadius = kWitStoreCorner;
        _whiteBG.layer.masksToBounds = YES;
        [self.contentView addSubview:_whiteBG];
    }
    return _whiteBG;
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(self.whiteBG.left, 0, self.whiteBG.width, kVerEdge)];
        _topView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_topView];
    }
    return _topView;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(self.whiteBG.left, 0, self.whiteBG.width, kVerEdge)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bottomView];
    }
    return _bottomView;
}

- (UIView *)dataView
{
    if (!_dataView) {
        CGFloat dataX = SCREEN_FIX(6);
        _dataView = [[UIView alloc] initWithFrame:CGRectMake(dataX, kVerEdge, self.whiteBG.width-dataX*2, 0)];
        _dataView.layer.cornerRadius  = SCREEN_FIX(5);
        _dataView.layer.borderWidth   = 1;
        _dataView.layer.borderColor   = HEX_RGB(@"#E0EBF7").CGColor;
        _dataView.layer.masksToBounds = YES;
        [self.whiteBG addSubview:_dataView];
        
        //进店逛逛
        CGFloat enterW = SCREEN_FIX(74);
        UIButton *enterButton = [[UIButton alloc] initWithFrame:CGRectMake(_dataView.width - SCREEN_FIX(11.5) - enterW, SCREEN_FIX(11.5), enterW, SCREEN_FIX(23))];
        enterButton.layer.cornerRadius  = enterButton.height/2;
        enterButton.layer.borderWidth   = 1;
        enterButton.layer.borderColor   = HEX_RGB(@"#058FFF").CGColor;
        enterButton.layer.masksToBounds = YES;
        enterButton.titleLabel.font = SCFONT_SIZED(SCREEN_FIX(12));
        [enterButton setTitleColor:HEX_RGB(@"#058FFF") forState:UIControlStateNormal];
        [enterButton setTitle:@"进店逛逛 >" forState:UIControlStateNormal];
        [_dataView addSubview:enterButton];
        
        @weakify(self)
        [enterButton sc_addEventTouchUpInsideHandle:^(id  _Nonnull sender) {
           @strongify(self)
            if (self.enterBlock && VALID_STRING(self.model.storeLink)) {
                self.enterBlock(self.model);
            }
        }];

    }
    return _dataView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_FIX(10.5), SCREEN_FIX(15), 0, SCREEN_FIX(15))];
        _titleLabel.font = SCFONT_SIZED(_titleLabel.height);
        _titleLabel.textColor = [UIColor blackColor];
        [self.dataView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIButton *)styleIcon
{
    if (!_styleIcon) {
        _styleIcon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_FIX(29), SCREEN_FIX(14.5))];
        _styleIcon.centerY = self.titleLabel.centerY;
        [_styleIcon setBackgroundImage:SCIMAGE(@"sc_home_store_type") forState:UIControlStateNormal];
        [_styleIcon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _styleIcon.titleLabel.font = SCFONT_SIZED(11);
        _styleIcon.userInteractionEnabled = NO;
        [_styleIcon setTitle:@"旗舰" forState:UIControlStateNormal];
        [self.dataView addSubview:_styleIcon];
    }
    return _styleIcon;
}

- (UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.left, self.titleLabel.bottom + SCREEN_FIX(13.5), SCREEN_FIX(250), SCREEN_FIX(11))];
        _addressLabel.font = SCFONT_SIZED(_addressLabel.height);
        _addressLabel.textAlignment = NSTextAlignmentLeft;
        _addressLabel.textColor = HEX_RGB(@"#666666");
        [self.dataView addSubview:_addressLabel];
    }
    return _addressLabel;
}

- (UIButton *)phoneBtn
{
    if (!_phoneBtn) {
        CGFloat phoneWh = SCREEN_FIX(36.5);
        _phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.dataView.width-SCREEN_FIX(20)-phoneWh, SCREEN_FIX(48.5), phoneWh, phoneWh)];
        [_phoneBtn setImage:SCIMAGE(@"sc_wit_tel") forState:UIControlStateNormal];
        [self.dataView addSubview:_phoneBtn];
        
        @weakify(self)
        [_phoneBtn sc_addEventTouchUpInsideHandle:^(id  _Nonnull sender) {
           @strongify(self)
            if (self.phoneBlock && VALID_STRING(self.model.contactPhone)) {
                self.phoneBlock(self.model.contactPhone);
            }
        }];
    }
    return _phoneBtn;
}

- (UILabel *)couponTipLabel
{
    if (!_couponTipLabel) {
        _couponTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_FIX(10.5), self.addressLabel.bottom + SCREEN_FIX(12), SCREEN_FIX(113), SCREEN_FIX(17))];
        _couponTipLabel.backgroundColor = HEX_RGB(@"#EEFBF8");
        _couponTipLabel.textColor = HEX_RGB(@"#01CDCD");
        _couponTipLabel.font = SCFONT_SIZED(SCREEN_FIX(10));
        _couponTipLabel.textAlignment = NSTextAlignmentCenter;
        _couponTipLabel.text = @"线下门店，智慧体验!";
        [self.dataView addSubview:_couponTipLabel];
    }
    return _couponTipLabel;
}

- (NSArray<UILabel *> *)couponLabelList
{
    if (!_couponLabelList) {
        NSMutableArray *mulArr = [NSMutableArray arrayWithCapacity:3];
        
        for (int i=0; i<3; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:self.couponTipLabel.frame];
            label.layer.cornerRadius  = 2;
            label.layer.borderWidth   = 1;
            label.layer.borderColor   = HEX_RGB(@"#FFE2E2").CGColor;
            label.layer.masksToBounds = YES;
            label.textAlignment       = NSTextAlignmentCenter;
            label.textColor           = HEX_RGB(@"#FF635D");
            label.font                = SCFONT_SIZED(SCREEN_FIX(10));
            [self.dataView addSubview:label];
            [mulArr addObject:label];
        }
        
        _couponLabelList = mulArr.copy;
    }
    return _couponLabelList;
}

- (UIView *)blueView
{
    if (!_blueView) {
        //底部蓝色
        _blueView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.dataView.width, kOrderH)];
        _blueView.backgroundColor = HEX_RGB(@"#EFF4F9");
        [self.dataView addSubview:_blueView];
        
        //排队icon
        CGFloat iconWH = SCREEN_FIX(12);
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_FIX(11), 0, iconWH, iconWH)];
        icon.centerY = _blueView.height/2;
        icon.image = SCIMAGE(@"sc_wit_watch");
        [_blueView addSubview:icon];
        
        //排队人数
        _peopleNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(icon.right + SCREEN_FIX(5), 0, SCREEN_FIX(130), SCREEN_FIX(15))];
        _peopleNumLabel.centerY = _blueView.height/2 - SCREEN_FIX(1);
        _peopleNumLabel.textAlignment = NSTextAlignmentLeft;
        _peopleNumLabel.font = SCFONT_SIZED(SCREEN_FIX(11));
        _peopleNumLabel.textColor = HEX_RGB(@"#0891FF");
        [_blueView addSubview:_peopleNumLabel];
        
        //取号
        CGFloat orderW = SCREEN_FIX(70);
        UIView *orderView = [[UIView alloc] initWithFrame:CGRectMake(_blueView.width - SCREEN_FIX(11.5) - orderW, 0, orderW, SCREEN_FIX(21))];
        orderView.centerY = _blueView.height/2;
        
        [_blueView addSubview:orderView];
        
        // gradient
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = orderView.bounds;
        gl.startPoint = CGPointMake(0, 0.5);
        gl.endPoint = CGPointMake(1, 0.5);
        gl.colors = @[(__bridge id)[UIColor colorWithRed:47/255.0 green:183/255.0 blue:255/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:59/255.0 green:135/255.0 blue:255/255.0 alpha:1.0].CGColor];
        gl.locations = @[@(0), @(1.0f)];
        orderView.layer.cornerRadius = 6;
        orderView.layer.masksToBounds = YES;
        [orderView.layer addSublayer:gl];
        
        UIButton *orderButton = [[UIButton alloc] initWithFrame:orderView.bounds];
        orderButton.titleLabel.font = SCFONT_SIZED(SCREEN_FIX(12));
        [orderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [orderButton setTitle:@"取号" forState:UIControlStateNormal];
        [orderView addSubview:orderButton];
        
        @weakify(self)
        [orderButton sc_addEventTouchUpInsideHandle:^(id  _Nonnull sender) {
           @strongify(self)
            if (self.orderBlock && self.model) {
                self.orderBlock(self.model);
            }
        }];
    }
    return _blueView;
}


@end
