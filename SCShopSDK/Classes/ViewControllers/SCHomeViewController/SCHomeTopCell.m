//
//  SCHomeTopCell.m
//  shopping
//
//  Created by gejunyu on 2021/3/2.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import "SCHomeTopCell.h"
#import "UIButton+SCEextension.h"

@interface SCHomeTopCell ()
@property (nonatomic, strong) NSArray *btnList;
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
        if (idx > 1) { //只要两条数据
            *stop = YES;
        }
        
        UIButton *btn = self.btnList[idx];
        
        [btn sd_setImageWithURL:[NSURL URLWithString:model.picUrl] forState:UIControlStateNormal placeholderImage:IMG_PLACE_HOLDER];
        [btn setTitle:model.txt forState:UIControlStateNormal];
    }];
}

- (void)createButtons
{
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:4];
    
    NSArray *imgList   = @[@"home_award", @"home_activity", @"home_cart", @"home_order"];
    NSArray *titleList = @[@"福利", @"活动", @"购物车", @"我的订单"];
    
    CGFloat wh     = SCREEN_FIX(51);                     //宽高
    CGFloat horM   = SCREEN_FIX(20.5);                   //屏幕边距
    CGFloat margin = (SCREEN_WIDTH - horM*2 - wh*4)/3;   //按钮间距
    
    for (int i=0; i<4; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(horM + (wh+margin)*i, kHomeTopRowH-SCREEN_FIX(9.5)-wh, wh, wh)];
        [btn setImage:SCIMAGE(imgList[i]) forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = SCFONT_SIZED(12);
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [btn setTitle:titleList[i] forState:UIControlStateNormal];
        
        [btn layoutButtonWithEdgeInsetsStyle:XGButtonEdgeInsetsStyleTop imageTitleSpace:SCREEN_FIX(9)];
        
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
