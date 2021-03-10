//
//  SCHomeRecommendTopView.m
//  shopping
//
//  Created by gejunyu on 2021/3/4.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import "SCHomeRecommendTopView.h"


@interface SCHomeRecommendTopView ()
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UIButton *serviceButton;
@property (nonatomic, strong) UIButton *phonebutton;
@property (nonatomic, strong) UIButton *enterStoreButton;

@end

@implementation SCHomeRecommendTopView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self serviceButton];
    }
    return self;
}


 
- (void)getData
{
    //标题
    self.titleLabel.text = @"南京移动龙江阳光智享生活馆";
    [self.titleLabel sizeToFit];
    self.titleLabel.width = MIN(self.titleLabel.width, SCREEN_FIX(213));
    
    //距离
    self.distanceLabel.left = self.titleLabel.right + SCREEN_FIX(10);
    NSInteger num = 421;
    NSString *numStr = [NSString stringWithFormat:@"%lim",num];
    NSString *distanceStr = [NSString stringWithFormat:@"距离您%@",numStr];
    NSMutableAttributedString *mulA = [[NSMutableAttributedString alloc] initWithString:distanceStr];
    [mulA addAttributes:@{NSForegroundColorAttributeName:HEX_RGB(@"#ff3434")} range:[distanceStr rangeOfString:numStr]];
    self.distanceLabel.attributedText = mulA;
    [self.distanceLabel sizeToFit];
    
    //标签
    BOOL isInHoure = num <= 5000; //是否是1小时达
    NSArray *data = @[@"官方好店",@"本地包邮",@"赠品"];

    //最多显示4个标签， 1小时达占一个
    NSInteger maxNum = isInHoure ? 3 : 4;
    NSMutableArray *tags = [data subarrayWithRange:NSMakeRange(0, MIN(data.count, maxNum))].mutableCopy;
    if (isInHoure) {
        [tags addObject:@"一小时达"];
    }

//    home_recommend_tag0@2x
    
    __block CGFloat x = SCREEN_FIX(19);
    CGFloat btnH = SCREEN_FIX(18);
    [tags enumerateObjectsUsingBlock:^(NSString * _Nonnull tag, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, self.height - SCREEN_FIX(8) - btnH, 0, btnH)];
        btn.titleLabel.font = SCFONT_SIZED_FIX(11);
        [btn setTitle:tag forState:UIControlStateNormal];
        btn.userInteractionEnabled = NO;
        //是否是一小时达的标签
        BOOL isInHourTag = isInHoure && idx == tags.count - 1;
        if (isInHourTag) {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setBackgroundImage:SCIMAGE(@"home_recommend_tag3") forState:UIControlStateNormal];
            
        }else {
            [btn setTitleColor:(idx == 0 ? [UIColor whiteColor] : [UIColor blackColor]) forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage sc_imageNamed:[NSString stringWithFormat:@"home_recommend_tag%li",idx]]forState:UIControlStateNormal];
        }
        CGFloat textW = [tag calculateWidthWithFont:btn.titleLabel.font height:btnH];
        btn.width = textW + SCREEN_FIX(5)*2; //两边5的间距
    
        [self addSubview:btn];
        
        x = btn.right + SCREEN_FIX(12.5);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.enterStoreBlock) {
        self.enterStoreBlock();
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
        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.line.bottom + SCREEN_FIX(13), 20, SCREEN_FIX(12))];
        _distanceLabel.font = SCFONT_SIZED_FIX(12);
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
            if (self.telBlock) {
                self.telBlock();
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
            if (self.serviceBlock) {
                self.serviceBlock();
            }
        }];
    }
    return _serviceButton;
}


@end
