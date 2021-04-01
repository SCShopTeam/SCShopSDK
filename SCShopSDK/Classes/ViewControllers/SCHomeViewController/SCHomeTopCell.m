//
//  SCHomeTopCell.m
//  shopping
//
//  Created by gejunyu on 2021/3/2.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import "SCHomeTopCell.h"
#import "UIButton+SCEextension.h"

@interface SCHomeTopButton : UIButton

@end

@interface SCHomeTopCell ()
@property (nonatomic, strong) NSArray <SCHomeTopButton *>*btnList;
@end

@implementation SCHomeTopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = HEX_RGB(@"#F2270C");
        [self createButtons];
    }
    return self;
}

- (void)setTopList:(NSArray<SCHomeTouchModel *> *)topList
{
    if (topList == _topList || topList.count == 0) {
        return;
    }
    
    _topList = topList;
    
    [topList enumerateObjectsUsingBlock:^(SCHomeTouchModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > 1 || idx >= self.btnList.count) { //只要两条数据
            *stop = YES;
        }
        
        SCHomeTopButton *btn = self.btnList[idx];
        
        [btn sd_setImageWithURL:[NSURL URLWithString:model.picUrl] forState:UIControlStateNormal placeholderImage:IMG_PLACE_HOLDER];
        [btn setTitle:model.txt forState:UIControlStateNormal];
    }];
}

- (void)createButtons
{
    
    NSArray *imgList   = @[@"home_award", @"home_activity", @"home_cart", @"home_order"];
    NSArray *titleList = @[@"福利", @"活动", @"购物车", @"我的订单"];
    
    CGFloat wh     = SCREEN_FIX(51);                     //宽高
    CGFloat horM   = SCREEN_FIX(20.5);                   //屏幕边距
    CGFloat margin = (SCREEN_WIDTH - horM*2 - wh*4)/3;   //按钮间距
    
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:imgList.count];
    
    for (int i=0; i<imgList.count; i++) {
        SCHomeTopButton *btn = [[SCHomeTopButton alloc] initWithFrame:CGRectMake(horM + (wh+margin)*i, kHomeTopRowH-SCREEN_FIX(9.5)-wh, wh, wh)];
        [btn setImage:SCIMAGE(imgList[i]) forState:UIControlStateNormal];
        [btn setTitle:titleList[i] forState:UIControlStateNormal];

        [self addSubview:btn];
        
        [temp addObject:btn];
        
        @weakify(self)
        [btn sc_addEventTouchUpInsideHandle:^(id  _Nonnull sender) {
          @strongify(self)
            
            if (self.selectBlock) {
                SCHomeTouchModel *model = i<self.topList.count ? self.topList[i] : nil;
                self.selectBlock(i, model);
            }
            
            
        }];
    }
    
    self.btnList = temp.copy;

}

@end


@implementation SCHomeTopButton
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.font = SCFONT_SIZED_FIX(12);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imgWh = SCREEN_FIX(30);
    self.imageView.frame = CGRectMake((self.width-imgWh)/2, 0, imgWh, imgWh);
    
    CGFloat titleH = SCREEN_FIX(12);
    self.titleLabel.frame = CGRectMake(0, self.height-titleH, self.width, titleH);
}

@end
